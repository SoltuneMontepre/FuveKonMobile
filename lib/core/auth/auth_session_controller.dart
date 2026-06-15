class AuthSessionController {
  void Function()? onSessionExpired;

  void notifySessionExpired() => onSessionExpired?.call();
}
