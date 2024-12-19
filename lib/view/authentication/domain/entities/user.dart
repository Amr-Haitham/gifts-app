class User {
  final String id;
  final String name;
  final String email;
  final String? profilePic;
  final String phoneNumber;
  final String country;
  final String? city;
  final String? address;
  final String? accessToken;

  User(
      {required this.name,
      this.profilePic,
      required this.phoneNumber,
      required this.country,
      this.city,
      this.address,
      this.accessToken,
      required this.id,
      required this.email});
}
