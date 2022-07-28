class UserModel {
  late String name;
  late String email;
  late String phone;
  late String height;
  late String weight;
  late String uId;
  late String image;
  late String cover;
  late String bio;
  late bool isEmailVerfied;
  late String emergency_email;

  UserModel({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.height = '',
    this.weight = '',
    this.uId = '',
    this.image = '',
    this.cover = '',
    this.emergency_email = '',
    this.bio = '',
    this.isEmailVerfied = false,
  });
  UserModel.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    email = json['email'];
    phone = json['phone'];
    height = json['height'];
    weight = json['weight'];
    emergency_email = json['emergency_email'];
    uId = json['uId'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    isEmailVerfied = json['isEmailVerfied'];
  }

  Object? get length => null;
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'height': height,
      'weight': weight,
      'uId': uId,
      'image': image,
      'cover': cover,
      'bio': bio,
      'emergency_email': emergency_email,
      'isEmailVerfied': isEmailVerfied,
    };
  }
}
