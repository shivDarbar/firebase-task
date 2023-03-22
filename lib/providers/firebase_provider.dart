import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_task_app/models/user.dart';
import 'package:firebase_task_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

class FirebaseProvider with ChangeNotifier {
  final List<User> _userList = [];
  List<User> get userList {
    return [..._userList];
  }

  String? _email;
  String? get email => _email;
  String? _password;
  String? get password => _password;
  String? _userName;
  String? get userName => _userName;
  String? _newPassword;
  String? get newPassword => _newPassword;

  String? _role = 'Admin';
  String? get role => _role;

  bool userNameAvailable = false;

  bool _showPassWord = false;
  bool get showPassWord => _showPassWord;

  User? currentUser;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  TextEditingController userNameController = TextEditingController();

  List<String> roleItems = ['Admin', 'Viewer'];

  toggleShowPassWord() {
    _showPassWord = !_showPassWord;
    notifyListeners();
  }

  getRole(String value) {
    _role = value;
    notifyListeners();
  }

  getEmail() {
    _email = emailController.text;
  }

  getPassword() {
    _password = passwordController.text;
  }

  getNewPassword() {
    _newPassword = newPasswordController.text;
  }

  getUserName() {
    _userName = userNameController.text;
  }

  mySnackBar({
    required BuildContext context,
    required String text,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  checkIfUserNameAvailable() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    if (userNameController.text.isNotEmpty) {
      var userRef = await db.collection('users').doc(_userName).get();

      if (userRef.exists) {
        userNameAvailable = false;
      } else {
        userNameAvailable = true;
      }
      notifyListeners();
    }
    return userNameAvailable;
  }

  String? validateEmail(String value) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (value.isEmpty) {
      return 'Please enter Email Address';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter a valid Email Address.';
      } else {
        return null;
      }
    }
  }

  String? validatePassword(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter a valid password';
      } else {
        return null;
      }
    }
  }

  registerUser({
    required BuildContext context,
    required bool isRegister,
  }) async {
    if (_userName!.isNotEmpty) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      var userNameAvailable = await checkIfUserNameAvailable();
      if (userNameAvailable) {
        DocumentReference roomRef = db.collection('users').doc(_userName);
        currentUser = User(
          userName: _userName!,
          email: _email!,
          password: _password!,
          role: _role!,
        );

        roomRef.set({
          'userName': _userName,
          'email': _email,
          'password': _password,
          'role': _role,
        }).then(
          (value) async {
            await getUserList();
            mySnackBar(
                context: context,
                text: isRegister
                    ? 'Registered Successfully.'
                    : 'User added Successfully.');
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //     content: Text(isRegister
            //         ? 'Registered Successfully.'
            //         : 'User added Successfully.')));
            clearTextControllers();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
        );
      } else {
        mySnackBar(context: context, text: 'User Name not avilable!');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('User Name not avilable!'),
        //   ),
        // );
      }
    }
  }

  loginUser(BuildContext context) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    if (_userName == null || _password == null) {
      mySnackBar(context: context, text: 'Please fill all the fields.');
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Please fill all the fields.')));
    } else {
      var userRef = await db.collection('users').doc(_userName).get();
      if (userRef.exists) {
        await getUserList();
        var userData = userRef.data();
        if (_userName == userData!['userName'] &&
            _password == userData['password']) {
          currentUser = User(
            userName: userData['userName'],
            email: userData['email'],
            password: userData['password'],
            role: userData['role'],
          );
          mySnackBar(context: context, text: 'Logged in Successfully.');
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text(
          //       'Logged in Successfully.',
          //     ),
          //   ),
          // );
          clearTextControllers();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else {
          mySnackBar(
              context: context,
              text: 'Please type correct User name and Password.');
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //     content: Text('Please type correct User name and Password.')));
        }
      } else {
        mySnackBar(context: context, text: 'User not found.');
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('User not found.')));
      }
    }
  }

  clearTextControllers() {
    emailController.clear();
    passwordController.clear();
    userNameController.clear();
  }

  changePassword(BuildContext context) async {
    if (_password == currentUser!.password) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      var userRef = db.collection('users').doc(_userName);
      userRef.set({'password': _newPassword}, SetOptions(merge: true));
      mySnackBar(context: context, text: 'Password changed successfully.');
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Password changed successfully.')));
      passwordController.clear();
      newPasswordController.clear();
      Navigator.pop(context);
    } else {
      mySnackBar(context: context, text: 'Please enter a correct Password.');
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Please enter a correct Password.')));
    }
  }

  checkPassword(BuildContext context) {
    if (_password != currentUser!.password) {
      mySnackBar(context: context, text: 'Please Enter correct PassWord');
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Please Enter correct PassWord')));
    }
  }

  getUserList() async {
    _userList.clear();
    FirebaseFirestore db = FirebaseFirestore.instance;
    var users = await db.collection('users').get();

    users.docs.map((doc) => doc.data()).forEach((user) {
      var temp = User(
          userName: user['userName'],
          email: user['email'],
          password: user['password'],
          role: user['role']);
      _userList.add(temp);
    });

    notifyListeners();
  }
}
