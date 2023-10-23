
import 'package:fiboutiquesv1/Database/user.dart';
import 'package:hive_flutter/adapters.dart';


class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0; // Identifiant unique pour votre modèle User

  @override
  User read(BinaryReader reader) {
    return User(password: reader.read());
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.write(obj.password);
  }
}