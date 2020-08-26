import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'file:///E:/AndroidStudioProjects/weight_tracker/lib/ui/old/home_screen.dart';
import 'package:weight_tracker/ui/old/register_screen.dart';
import 'package:weight_tracker/utils/Colors.dart';
import 'package:weight_tracker/utils/Constants.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({
    Key key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-3.8, -3.3),
          end: Alignment(0, 0),
          colors: [
            off_yellow,
            midnight,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Login"),
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: const Text(
                              'Sign in with email and password',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            alignment: Alignment.center,
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration:
                                const InputDecoration(labelText: 'Email'),
                            validator: (String value) {
                              if (value.isEmpty)
                                return 'Please enter some text';
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            validator: (String value) {
                              if (value.isEmpty)
                                return 'Please enter some text';
                              return null;
                            },
                            obscureText: true,
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 16.0),
                            alignment: Alignment.center,
                            child: MaterialButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _signInWithEmailAndPassword();
                                }
                              },
                              child: Text("Login"),
                              color: off_yellow,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 24.0),
                  padding: const EdgeInsets.only(top: 16.0),
                  alignment: Alignment.center,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => RegisterScreen()),
                      );
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signInWithEmailAndPassword() async {
    try {
      user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

//      Scaffold.of(context).showSnackBar(SnackBar(
//        content: Text("${user.email} signed in"),
//      ));
      print("${user.email} signed in");
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
