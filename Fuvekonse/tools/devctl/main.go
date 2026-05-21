package main

import (
	"context"
	"crypto/rand"
	"encoding/base64"
	"errors"
	"fmt"
	"io"
	"net"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"runtime"
	"strings"
	"time"
)

type envPair struct {
	key        string
	value      string
	allowEmpty bool
}

type envFileSpec struct {
	envPath     string
	examplePath string
}

func main() {
	if len(os.Args) < 2 {
		usage()
		os.Exit(2)
	}

	var err error
	switch os.Args[1] {
	case "check":
		err = runCheck()
	case "ensure-tools":
		err = runEnsureTools()
	case "ensure-env":
		err = runEnsureEnv()
	case "wait":
		err = runWait()
	case "run-air":
		if len(os.Args) != 3 {
			err = errors.New("usage: devctl run-air <service-path>")
		} else {
			err = runAir(os.Args[2])
		}
	default:
		err = fmt.Errorf("unknown command %q", os.Args[1])
	}

	if err != nil {
		fmt.Fprintln(os.Stderr, "devctl:", err)
		os.Exit(1)
	}
}

func usage() {
	fmt.Fprintln(os.Stderr, "usage: devctl <check|ensure-tools|ensure-env|wait|run-air>")
}

func runCheck() error {
	if err := requireCommand("go"); err != nil {
		return err
	}
	if err := requireCommand("docker"); err != nil {
		return err
	}
	if err := runQuiet("docker", "compose", "version"); err != nil {
		return fmt.Errorf("docker compose is required: %w", err)
	}
	if err := runQuiet("docker", "info"); err != nil {
		return fmt.Errorf("docker is installed but the daemon is not reachable: %w", err)
	}

	for _, port := range []int{8085, 8081} {
		if err := assertServicePortFree(port); err != nil {
			return err
		}
	}
	for _, port := range []int{5432, 6379, 4566} {
		if err := assertInfraPortAvailable(port); err != nil {
			return err
		}
	}

	fmt.Println("Prerequisite check passed.")
	return nil
}

func requireCommand(name string) error {
	if _, err := exec.LookPath(name); err != nil {
		return fmt.Errorf("required command %q was not found on PATH", name)
	}
	return nil
}

func runQuiet(name string, args ...string) error {
	cmd := exec.Command(name, args...)
	out, err := cmd.CombinedOutput()
	if err != nil {
		return fmt.Errorf("%s %s failed: %s", name, strings.Join(args, " "), strings.TrimSpace(string(out)))
	}
	return nil
}

func assertServicePortFree(port int) error {
	if isPortFree(port) {
		return nil
	}
	return fmt.Errorf("port %d is already in use; stop that service before running task dev", port)
}

func assertInfraPortAvailable(port int) error {
	if isPortFree(port) {
		return nil
	}
	if isInfraPortOwnedByCompose(port) {
		fmt.Printf("Port %d is already used by this Docker compose stack; continuing.\n", port)
		return nil
	}
	return fmt.Errorf("infra port %d is already in use and does not look like the Fuvekonse compose stack", port)
}

func isPortFree(port int) bool {
	ln, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
	if err != nil {
		return false
	}
	_ = ln.Close()
	return true
}

func isInfraPortOwnedByCompose(port int) bool {
	for _, container := range []string{"fuvekon-db", "fuvekon-cache", "fuvekon-cloud"} {
		out, err := exec.Command("docker", "inspect", container, "--format", "{{json .NetworkSettings.Ports}}").CombinedOutput()
		if err != nil {
			continue
		}
		if strings.Contains(string(out), fmt.Sprintf(`"HostPort":"%d"`, port)) {
			return true
		}
	}
	return false
}

func runEnsureTools() error {
	if err := requireCommand("go"); err != nil {
		return err
	}
	if err := addGoBinToPath(); err != nil {
		return err
	}
	if err := ensureGoTool("air", "github.com/air-verse/air@latest"); err != nil {
		return err
	}
	if err := ensureGoTool("swag", "github.com/swaggo/swag/cmd/swag@latest"); err != nil {
		return err
	}
	fmt.Println("Go dev tools are ready.")
	return nil
}

func ensureGoTool(commandName, pkg string) error {
	if _, err := exec.LookPath(commandName); err == nil {
		fmt.Printf("%s is available.\n", commandName)
		return nil
	}

	fmt.Printf("Installing %s...\n", commandName)
	cmd := exec.Command("go", "install", pkg)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	if err := cmd.Run(); err != nil {
		return err
	}
	if err := addGoBinToPath(); err != nil {
		return err
	}
	if _, err := exec.LookPath(commandName); err != nil {
		return fmt.Errorf("%s was installed, but it is not available on PATH; add GOPATH/bin or GOBIN to PATH", commandName)
	}
	return nil
}

func addGoBinToPath() error {
	goBin, err := goBinPath()
	if err != nil {
		return err
	}
	if goBin == "" {
		return nil
	}
	prependPath(goBin)
	return nil
}

func goBinPath() (string, error) {
	gobin, err := goEnv("GOBIN")
	if err != nil {
		return "", err
	}
	if gobin != "" {
		return gobin, nil
	}
	gopath, err := goEnv("GOPATH")
	if err != nil {
		return "", err
	}
	if gopath == "" {
		return "", nil
	}
	first := strings.Split(gopath, string(os.PathListSeparator))[0]
	return filepath.Join(first, "bin"), nil
}

func goEnv(key string) (string, error) {
	out, err := exec.Command("go", "env", key).Output()
	if err != nil {
		return "", fmt.Errorf("go env %s failed: %w", key, err)
	}
	return strings.TrimSpace(string(out)), nil
}

func prependPath(dir string) {
	dir = filepath.Clean(dir)
	for _, entry := range filepath.SplitList(os.Getenv("PATH")) {
		if samePath(entry, dir) {
			return
		}
	}
	os.Setenv("PATH", dir+string(os.PathListSeparator)+os.Getenv("PATH"))
}

func samePath(a, b string) bool {
	a = filepath.Clean(a)
	b = filepath.Clean(b)
	if runtime.GOOS == "windows" {
		return strings.EqualFold(a, b)
	}
	return a == b
}

func runEnsureEnv() error {
	specs := []envFileSpec{
		{
			envPath:     "services/general-service/.env",
			examplePath: "services/general-service/.env.example",
		},
		{
			envPath:     "services/rbac-service/.env",
			examplePath: "services/rbac-service/.env.example",
		},
		{
			envPath:     "services/sqs-worker/.env",
			examplePath: "services/sqs-worker/.env.example",
		},
	}

	for _, spec := range specs {
		if err := ensureEnvFile(spec.envPath, spec.examplePath); err != nil {
			return err
		}

		defaults, err := loadEnvDefaults(spec.examplePath)
		if err != nil {
			return err
		}

		if err := setEnvDefaults(spec.envPath, defaults); err != nil {
			return err
		}
	}

	fmt.Println("Service env files are ready.")
	return nil
}

func loadEnvDefaults(examplePath string) ([]envPair, error) {
	examplePath = filepath.FromSlash(examplePath)
	content, err := os.ReadFile(examplePath)
	if err != nil {
		return nil, err
	}

	var pairs []envPair
	for lineNumber, line := range splitLines(string(content)) {
		key, value, ok := parseEnvLine(line)
		if !ok {
			continue
		}

		resolvedValue, err := resolveDefaultEnvValue(value)
		if err != nil {
			return nil, fmt.Errorf("%s:%d: %w", filepath.ToSlash(examplePath), lineNumber+1, err)
		}

		pairs = append(pairs, envPair{
			key:        key,
			value:      resolvedValue,
			allowEmpty: strings.TrimSpace(value) == "",
		})
	}

	return pairs, nil
}

func resolveDefaultEnvValue(value string) (string, error) {
	if isGeneratedPlaceholder(value) {
		return newBase64Key()
	}
	return value, nil
}

func isGeneratedPlaceholder(value string) bool {
	return strings.TrimSpace(value) == "{{generate:base64:32}}"
}

func ensureEnvFile(envPath, examplePath string) error {
	envPath = filepath.FromSlash(envPath)
	examplePath = filepath.FromSlash(examplePath)
	if _, err := os.Stat(envPath); err == nil {
		return nil
	} else if !errors.Is(err, os.ErrNotExist) {
		return err
	}

	if err := os.MkdirAll(filepath.Dir(envPath), 0o755); err != nil {
		return err
	}

	content := []byte{}
	if data, err := os.ReadFile(examplePath); err == nil {
		content = data
		fmt.Printf("Created %s from %s\n", filepath.ToSlash(envPath), filepath.ToSlash(examplePath))
	} else if !errors.Is(err, os.ErrNotExist) {
		return err
	} else {
		fmt.Printf("Created empty %s\n", filepath.ToSlash(envPath))
	}

	return os.WriteFile(envPath, content, 0o644)
}

func setEnvDefaults(envPath string, defaults []envPair) error {
	for _, pair := range defaults {
		changed, err := setEnvDefault(envPath, pair)
		if err != nil {
			return err
		}
		if changed {
			fmt.Printf("Updated %s: %s\n", envPath, pair.key)
		}
	}
	return nil
}

func setEnvDefault(envPath string, pair envPair) (bool, error) {
	envPath = filepath.FromSlash(envPath)
	content, err := os.ReadFile(envPath)
	if err != nil {
		return false, err
	}

	lines := splitLines(string(content))
	found := false
	changed := false
	commentPattern := regexp.MustCompile(`\s+#`)

	for i, line := range lines {
		key, value, ok := parseEnvLine(line)
		if !ok || key != pair.key {
			continue
		}

		found = true
		valueBeforeComment := value
		if loc := commentPattern.FindStringIndex(value); loc != nil {
			valueBeforeComment = value[:loc[0]]
		}
		currentValue := strings.TrimSpace(valueBeforeComment)
		if (!pair.allowEmpty && currentValue == "") || isGeneratedPlaceholder(currentValue) {
			lines[i] = pair.key + "=" + pair.value
			changed = true
		}
		break
	}

	if !found {
		if len(lines) > 0 && strings.TrimSpace(lines[len(lines)-1]) != "" {
			lines = append(lines, "")
		}
		lines = append(lines, pair.key+"="+pair.value)
		changed = true
	}

	if !changed {
		return false, nil
	}
	return true, os.WriteFile(envPath, []byte(strings.Join(lines, "\n")+"\n"), 0o644)
}

func splitLines(content string) []string {
	content = strings.ReplaceAll(content, "\r\n", "\n")
	content = strings.ReplaceAll(content, "\r", "\n")
	content = strings.TrimSuffix(content, "\n")
	if content == "" {
		return []string{}
	}
	return strings.Split(content, "\n")
}

func parseEnvLine(line string) (key string, value string, ok bool) {
	trimmed := strings.TrimLeft(line, " \t")
	if trimmed == "" || strings.HasPrefix(trimmed, "#") {
		return "", "", false
	}
	idx := strings.Index(line, "=")
	if idx < 0 {
		return "", "", false
	}
	key = strings.TrimSpace(line[:idx])
	if key == "" {
		return "", "", false
	}
	return key, line[idx+1:], true
}

func newBase64Key() (string, error) {
	bytes := make([]byte, 32)
	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}
	return base64.StdEncoding.EncodeToString(bytes), nil
}

func runWait() error {
	if err := waitFor("Postgres", 90*time.Second, 2*time.Second, func() error {
		return runQuiet("docker", "exec", "fuvekon-db", "pg_isready", "-U", "root", "-d", "fuvekon")
	}); err != nil {
		printContainerDiagnostics("fuvekon-db")
		return err
	}

	if err := waitFor("Redis", 90*time.Second, 2*time.Second, func() error {
		out, err := exec.Command("docker", "exec", "fuvekon-cache", "redis-cli", "ping").CombinedOutput()
		if err != nil {
			return fmt.Errorf("%w: %s", err, strings.TrimSpace(string(out)))
		}
		if strings.TrimSpace(string(out)) != "PONG" {
			return fmt.Errorf("unexpected Redis ping response: %s", strings.TrimSpace(string(out)))
		}
		return nil
	}); err != nil {
		printContainerDiagnostics("fuvekon-cache")
		return err
	}

	if err := waitFor("LocalStack", 90*time.Second, 2*time.Second, func() error {
		ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
		defer cancel()

		req, err := http.NewRequestWithContext(ctx, http.MethodGet, "http://localhost:4566/_localstack/health", nil)
		if err != nil {
			return err
		}
		resp, err := http.DefaultClient.Do(req)
		if err != nil {
			return err
		}
		defer resp.Body.Close()
		_, _ = io.Copy(io.Discard, resp.Body)
		if resp.StatusCode != http.StatusOK {
			return fmt.Errorf("health endpoint returned %s", resp.Status)
		}
		return nil
	}); err != nil {
		printContainerDiagnostics("fuvekon-cloud")
		return err
	}

	return nil
}

func waitFor(name string, timeout, interval time.Duration, check func() error) error {
	deadline := time.Now().Add(timeout)
	var lastErr error

	for time.Now().Before(deadline) {
		if err := check(); err == nil {
			fmt.Printf("%s is ready.\n", name)
			return nil
		} else {
			lastErr = err
		}
		time.Sleep(interval)
	}

	if lastErr != nil {
		return fmt.Errorf("%s did not become ready within %s; last error: %w", name, timeout, lastErr)
	}
	return fmt.Errorf("%s did not become ready within %s", name, timeout)
}

func printContainerDiagnostics(container string) {
	fmt.Fprintf(os.Stderr, "\nDiagnostics for %s:\n", container)
	if out, err := exec.Command("docker", "inspect", container, "--format", "status={{.State.Status}} exit={{.State.ExitCode}}").CombinedOutput(); err == nil {
		fmt.Fprintln(os.Stderr, strings.TrimSpace(string(out)))
	}
	if out, err := exec.Command("docker", "logs", "--tail", "80", container).CombinedOutput(); err == nil && len(out) > 0 {
		fmt.Fprintf(os.Stderr, "\nLast logs for %s:\n%s\n", container, string(out))
	}
}

func runAir(servicePath string) error {
	if err := addGoBinToPath(); err != nil {
		return err
	}
	if _, err := exec.LookPath("air"); err != nil {
		return errors.New("air is not available; run task tools first")
	}

	absPath, err := filepath.Abs(filepath.FromSlash(servicePath))
	if err != nil {
		return err
	}
	info, err := os.Stat(absPath)
	if err != nil {
		return err
	}
	if !info.IsDir() {
		return fmt.Errorf("%s is not a directory", servicePath)
	}

	cmd := exec.Command("air")
	cmd.Dir = absPath
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	cmd.Env = os.Environ()
	return cmd.Run()
}
