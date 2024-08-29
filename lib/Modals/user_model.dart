class UserModel {
   String name;
   String location;
   String iban;
   String phone;
   String profilePic;
   String uid;
   String createdAt;

  UserModel(
      {required this.name,
      required this.location,
      required this.iban,
      required this.phone,
      required this.profilePic,
      required this.uid,
      required this.createdAt});

  // from map
  factory UserModel.fromMap(Map<String, dynamic>map){
    return UserModel(
        name: map['name'] ?? '',
        location: map['location'] ?? '',
        iban: map['iban'] ?? '',
        phone: map['phone'] ?? '',
        profilePic: map['profilePic'] ?? '',
        uid: map['uid'] ?? '',
        createdAt: map['createdAt'] ?? '');
  }

  // to Map
  Map<String , dynamic>toMap(){
    return {
      "name": name,
      "location": location,
      "iban": iban,
      "phone": phone,
      "profilePic": profilePic,
      "uid": uid,
      "createdAt": createdAt,
    };
  }
}
