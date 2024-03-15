import 'package:flutter/material.dart';
import 'package:news_app/Auth%20screens/signup.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/views/Homepage.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKeys = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String L_email = "";

  String L_password = "";



void _loginUser() async {

  if (_formKeys.currentState!.validate() ) {
    _formKeys.currentState!.save();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Center(child: CircularProgressIndicator()),
    ); // Show progress indicator

    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: L_email,
        password: L_password,
      );
      if(userCredential != null){
      Navigator.pop(context); // Hide progress indicator
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("message"),
          backgroundColor: Colors.green,
        ),
      );

      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Hide progress indicator
      String message = "";
      if (e.code == 'invalid-email') {
        message = 'The email address is invalid.';
      } else if (e.code == 'wrong-password') {
        message = 'The password is incorrect.';
      } else {
        message = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}








  @override
  Widget build(BuildContext context) {

    return Scaffold(
       
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // White app bar background
        elevation: 0.0, // Remove app bar shadow
      ),
      body: SingleChildScrollView( // Allow scrolling if content overflows
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
          child: Form(
            key: _formKeys,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20.0),
                Image.asset(
                  'assets/3071357.jpg', // Adjust the image path
                  height: 170.0,
                  width: 150.0,
                ),
                
                
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
            
                  onSaved: (value) => L_email = value!,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: Icon(Icons.visibility_off), // Password visibility toggle
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) => L_password = value!,
                ),
                SizedBox(height: 20.0),
            
                ElevatedButton(
                onPressed: _loginUser ,

                child: Text('Login',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ), // White text color
                    padding: EdgeInsets.symmetric(vertical: 15.0), // Button padding
                  ),
                ),
            
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    SizedBox(
                      width: 300,
                      height: 50,
                      child: TextButton(

                       style:  ButtonStyle(

                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey, width: 1.0), // Adjust color and width
                              borderRadius: BorderRadius.circular(10.0), // Adjust corner radius
                            ),

                          )),
                        onPressed: () => {
                          Navigator.push(
                                        context, // Pass the current context
                                        MaterialPageRoute(builder: (context) => SignUpPage()), // Define the new screen (SecondScreen)
                                      )
                        }, // Handle "Sign Up" functionality
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
