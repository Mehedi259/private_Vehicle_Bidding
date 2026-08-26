class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? dob;
  final String? gender;
  final String? phoneNumber;
  final String? address;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.dob,
    this.gender,
    this.phoneNumber,
    this.address,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? dob,
    String? gender,
    String? phoneNumber,
    String? address,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'dob': dob,
      'gender': gender,
      'phone_number': phoneNumber,
      'address': address,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'],
      dob: json['dob'],
      gender: json['gender'],
      phoneNumber: json['phone_number'],
      address: json['address'],
    );
  }
}
