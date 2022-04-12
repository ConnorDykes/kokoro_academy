import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kokoro_academy/Screens/admin.dart';

import '../main.dart';

class Info extends StatefulWidget {
  Info({Key? key}) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  TextEditingController passwordCntrl = TextEditingController();
  bool showAdminLogin = false;
  String validationText = "";
  late String password;

  Future<void> fetchPassword() async {
    await FirebaseFirestore.instance
        .collection("Password")
        .doc("password")
        .get()
        .then((doc) {
      setState(() {
        password = doc["password"];
      });
      print(password);
    });
  }

  @override
  void initState() {
    fetchPassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: CustomDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () => _key.currentState!.openDrawer(),
          child: Icon(Icons.menu)),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/Kokoro_Logo.png",
                  height: 100,
                  width: 100,
                ),
              ],
            ),
            Text('Developed By Connor Dykes',
                style: TextStyle(
                  color: Colors.grey,
                )),
            Text('connormdykes@gmail.com',
                style: TextStyle(
                  color: Colors.grey,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Privacy Policy',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showAdminLogin = true;
                    });
                  },
                  child: Text("Admin Login")),
            ),
            Visibility(
              visible: showAdminLogin,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (passwordCntrl.text == password) {
                          Navigator.pushReplacement<void, void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => Admin(),
                              ));
                        } else {
                          setState(() {
                            validationText = "Incorrect Password, Try Again.";
                          });
                        }
                      },
                      icon: Icon(Icons.login),
                    ),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  controller: passwordCntrl,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
            ),
            Text(
              validationText,
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
      ),
    );
  }
}
