import 'package:firebase_task_app/providers/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/my_text_field.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseProvider = Provider.of<FirebaseProvider>(context);
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Profile Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Hi, ${firebaseProvider.currentUser!.userName}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: mediaQuery.size.height * 0.2,
          ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                fixedSize: Size(
                  mediaQuery.size.width * 0.5,
                  mediaQuery.size.height * 0.07,
                ),
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'Change Password',
              ),
              onPressed: () {
                changePasswordDialog(
                  context: context,
                  mediaQuery: mediaQuery,
                  firebaseProvider: firebaseProvider,
                );
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          if (firebaseProvider.currentUser!.role == 'Admin')
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                fixedSize: Size(
                  mediaQuery.size.width * 0.5,
                  mediaQuery.size.height * 0.07,
                ),
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                addUserDialog(
                  context: context,
                  mediaQuery: mediaQuery,
                  firebaseProvider: firebaseProvider,
                );
              },
              child: const Text(
                'Add User',
              ),
            ),
        ],
      ),
    );
  }

  Future<dynamic> changePasswordDialog({
    required BuildContext context,
    required MediaQueryData mediaQuery,
    required FirebaseProvider firebaseProvider,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: StatefulBuilder(builder: (context, setState) {
          return Container(
            width: mediaQuery.size.width * 0.5,
            height: mediaQuery.size.height * 0.35,
            padding:
                EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.05),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Current Password",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                MyTextField(
                  showBorder: true,
                  hintText: "*************",
                  controller: firebaseProvider.passwordController,
                  obscureText: firebaseProvider.showPassWord ? false : true,
                  onChanged: (value) {
                    firebaseProvider.getPassword();
                  },
                  onSubmitted: (value) {
                    firebaseProvider.getPassword();
                    firebaseProvider.changePassword(context);
                  },
                ),
                const Text(
                  "New Password",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                MyTextField(
                  showBorder: true,
                  hintText: "*************",
                  controller: firebaseProvider.newPasswordController,
                  obscureText: firebaseProvider.showPassWord ? false : true,
                  onChanged: (value) {
                    firebaseProvider.getNewPassword();
                  },
                  onSubmitted: (value) {
                    firebaseProvider.getNewPassword();
                    var snackBarText =
                        firebaseProvider.validatePassword(value!);
                    if (snackBarText != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            snackBarText,
                          ),
                        ),
                      );
                    }
                  },
                ),
                checkBoxWidget(firebaseProvider, setState),
                ElevatedButton(
                  onPressed: () {
                    firebaseProvider.changePassword(context);
                  },
                  child: const Text('Change Password'),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future<dynamic> addUserDialog({
    required BuildContext context,
    required MediaQueryData mediaQuery,
    required FirebaseProvider firebaseProvider,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: StatefulBuilder(builder: (context, setsate) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: mediaQuery.size.width * 0.6,
              height: mediaQuery.size.height * 0.54,
              padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.size.width * 0.05),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Select Role : '),
                      Container(
                        height: mediaQuery.size.height * 0.06,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(10),
                        width: mediaQuery.size.width * 0.21,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButton(
                          underline: Container(
                            color: Colors.transparent,
                          ),
                          icon: const Icon(Icons.arrow_drop_down),
                          items: firebaseProvider.roleItems.map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setsate(() => firebaseProvider.getRole(value!));
                          },
                          value: firebaseProvider.role,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  MyTextField(
                    showBorder: true,
                    hintText: "hello@gmail.com",
                    controller: firebaseProvider.emailController,
                    obscureText: false,
                    onChanged: (value) {
                      firebaseProvider.getEmail();
                    },
                    onSubmitted: (value) {
                      firebaseProvider.getEmail();
                      String? snackBarText =
                          firebaseProvider.validateEmail(value!);
                      if (snackBarText != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              snackBarText,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "User Name",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  MyTextField(
                    showBorder: true,
                    hintText: "Abc@123",
                    controller: firebaseProvider.userNameController,
                    obscureText: false,
                    onChanged: (value) {
                      firebaseProvider.getUserName();
                    },
                    onSubmitted: (value) {
                      firebaseProvider.getUserName();
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  MyTextField(
                    showBorder: true,
                    hintText: "*************",
                    controller: firebaseProvider.passwordController,
                    obscureText: firebaseProvider.showPassWord ? false : true,
                    onChanged: (value) {
                      firebaseProvider.getPassword();
                    },
                    onSubmitted: (value) {
                      firebaseProvider.getPassword();
                      var snackBarText =
                          firebaseProvider.validatePassword(value!);
                      if (snackBarText != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              snackBarText,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  checkBoxWidget(
                    firebaseProvider,
                    setsate,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          firebaseProvider.registerUser(
                              context: context, isRegister: false);
                        },
                        child: const Text(
                          'Add User',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  checkBoxWidget(FirebaseProvider firebaseProvider, StateSetter setState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: firebaseProvider.showPassWord,

          // onChanged: registerProvider.toggleShowPassWord(),
          onChanged: (_) {
            setState(() => firebaseProvider.toggleShowPassWord());
          },
        ),
        const Text('Show Password'),
      ],
    );
  }
}
