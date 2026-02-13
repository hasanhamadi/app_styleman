class UserModel {
  final String id;
  final String username;
  final String name;
  final String lestname; // مطابق غلط املایی در دیتابیس
  final String zipcode;
  final String adderss;  // مطابق غلط املایی در دیتابیس
  final String city;
  final String province;

  UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.lestname,
    required this.zipcode,
    required this.adderss,
    required this.city,
    required this.province,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      lestname: json['lestname'] ?? '',
      zipcode: json['zipcode'] ?? '',
      adderss: json['adderss'] ?? '',
      city: json['city'] ?? '',
      province: json['province'] ?? '',
    );
  }
}