

class User {
  late String password;
  bool isLoggedIn;

  User({required this.password, this.isLoggedIn = false});
  void modifyPassword(String newPassword) {
    password = newPassword;
  }
}