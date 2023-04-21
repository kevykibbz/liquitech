class ProfileModel {
  final String? id;
  final String? fullName;
  final String? username;
  final String? cardNo;
  final String? role;
  final String? photoUri;
  final String email;
  final int? phone;

  ProfileModel(
      {
        this.id,
        this.fullName,
        this.phone,
        this.role,
        this.photoUri,
        this.cardNo,
        this.username,
        required this.email,
      });

  toJson() {
    return {
      "FullName": fullName,
      "UserName": username,
      "Email": email,
      "Phone": phone,
      "PhotoURI": photoUri,
      "Role": role,
      "CardNo": cardNo,
    };
  }
}
