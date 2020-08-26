import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/utils/Colors.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment(0.4, 0.4),
          colors: [
            midnight,
            off_yellow,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                          ),
                          onPressed: () {
                            _signOut();
                          },
                        ),
                        Center(
                          child: Container(
                            child: Text(
                              "WEIGHT",
                              style: TextStyle(
                                color: light_grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.power_settings_new,
                          ),
                          onPressed: () {
                            _signOut();
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            child: Text(
                              "82.7",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 34.0,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            margin: EdgeInsets.only(left: 2.0),
                            child: Text(
                              "kg",
                              style: TextStyle(
                                  color: light_grey,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 18.0,
            vertical: 18.0,
          ),
          child: FloatingActionButton(
            backgroundColor: midnight,
            onPressed: () {
              _showWeightInput(context);
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  void _showWeightInput(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          child: Form(
            key: _formKey,
            child: Wrap(
              children: <Widget>[
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (String value) {
                    if (value.isEmpty) return 'Please enter some text';
                    return null;
                  },
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  alignment: Alignment.center,
                  child: MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {}
                    },
                    child: Text("Add"),
                    color: off_yellow,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
