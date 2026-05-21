# fuvekonmobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Backend Integration (Git Subtree)

The backend project `Fuvekonse` has been integrated into this repository under the `Fuvekonse/` folder using Git Subtree. 

### How to pull updates from the original repository:
Run the following command from the root of `FuveKonMobile`:
```bash
git subtree pull --prefix Fuvekonse https://github.com/SoltuneMontepre/Fuvekonse.git main --squash
```

### Safety
Since this is integrated as a subtree, your local commits and normal push commands (`git push origin main`) will only affect your own mobile repository. There is no risk of pushing to the production/original backend repository.
