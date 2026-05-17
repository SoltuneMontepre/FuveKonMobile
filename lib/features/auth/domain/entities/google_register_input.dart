class GoogleRegisterInput {
  const GoogleRegisterInput({
    required this.credential,
    required this.fullName,
    required this.nickname,
    required this.dateOfBirth,
    required this.country,
  });

  final String credential;
  final String fullName;
  final String nickname;
  final String dateOfBirth;
  final String country;

  Map<String, dynamic> toJson() => {
        'credential': credential,
        'fullName': fullName.trim(),
        'nickname': nickname.trim(),
        'dateOfBirth': dateOfBirth,
        'country': country.trim(),
      };
}
