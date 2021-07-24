import 'package:hive/hive.dart';

class HiveAuthServices {
  // Future box;

  /// The authentication service.
  ///

  // HiveAuthServices() {
  //   this.box = _init();
  // }

  // Future _init() async {
  //   return await Hive.openBox("authbox");
  // }
  var box = Hive.box("authbox");

  /// Puts login information into the database.
  putlogin(String email, String password) {
    box.put("email", email);
    box.put("password", password);
  }

  /// Gets the email from the database.
  getEmail() {
    return box.get("email");
  }

  /// Gets the password from the database.
  getPassword() {
    return box.get("password");
  }

  /// Sets the information stored flag.
  setInformationStored(bool stored) {
    box.put("informationStored", stored);
  }

  /// Gets the information stored flag.
  getInformationStored() {
    return box.get("informationStored");
  }

  /// Clears the login information.
  clearLogin() {
    box.clear();
    setInformationStored(false);
  }
}
