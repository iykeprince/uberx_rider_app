import 'package:firebase_database/firebase_database.dart';

class AllUser {
  String id;
  String email;
  String name;
  String phone;

  AllUser({
    this.id,
    this.email,
    this.name,
    this.phone,
  });

  AllUser.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key;
    email = dataSnapshot.value['email'];
    name = dataSnapshot.value['name'];
    phone = dataSnapshot.value['phone'];
  }
}
