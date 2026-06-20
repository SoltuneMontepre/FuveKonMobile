class RegisterInput {
  const RegisterInput({
    required this.fullName,
    required this.nickname,
    required this.email,
    required this.dateOfBirth,
    required this.country,
    required this.password,
    required this.confirmPassword,
  });

  final String fullName;
  final String nickname;
  final String email;
  final String dateOfBirth;
  final String country;
  final String password;
  final String confirmPassword;

  Map<String, dynamic> toJson() => {
    'fullName': fullName.trim(),
    'nickname': nickname.trim(),
    'email': email.trim().toLowerCase(),
    'dateOfBirth': dateOfBirth,
    'country': country.trim(),
    'password': password,
    'confirmPassword': confirmPassword,
  };
}
