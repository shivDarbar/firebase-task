import 'package:firebase_task_app/providers/firebase_provider.dart';
import 'package:firebase_task_app/screens/login_screen.dart';
import 'package:firebase_task_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var firebaseProvider = Provider.of<FirebaseProvider>(context);
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: Column(
                children: [
                  Icon(
                    Icons.account_circle,
                    size: mediaQuery.size.height * 0.15,
                    color: Colors.orange,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          width: mediaQuery.size.width,
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.orange,
                    size: mediaQuery.size.width * 0.1,
                  ),
                ),
                title: Text(
                  firebaseProvider.userList[index].userName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                subtitle: Text(
                  firebaseProvider.userList[index].email,
                ),
                trailing: Text(
                  firebaseProvider.userList[index].role,
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(),
            ],
          ),
        ),
        itemCount: firebaseProvider.userList.length,
      ),
    );
  }
}
