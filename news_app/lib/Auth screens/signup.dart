import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news_app/Auth%20screens/Login_screen.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String _name = "";
  String _email = "";
  String _password = "";


void singnup () async {
    if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    try {
    // Attempt to create a new user with Firebase
    final userCredential = await _auth.createUserWithEmailAndPassword(
    email: _email, password: _password);

    if (userCredential != null) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account has been suscessfully created'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.push(
        context, // Pass the current context
        MaterialPageRoute(builder: (context) => LoginPage()), // Define the new screen (SecondScreen)
      );
    }
    } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
    print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use')
    {
    print('The user already exists');

    }
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text('Login failed! ${e.message}'),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 2),
    ),
    );
    } catch (e) {
    print(e); // Print any other errors for debugging
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text('Login failed!'),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 2),
    ),
    );
    }
    } else {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text('Please fill all the fields'),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 2),
    ),
    );
    }
  }








  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Light grey background
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // White app bar background
        elevation: 0.0, // Remove app bar shadow
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Add an image above the form (replace with your image asset path)
              Image.asset(
                'assets/6333213.jpg', // Adjust the image path
                height: 150.0,
                width: 150.0,
              ),
              SizedBox(height: 20.0),
              Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0), // Rounded corners
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      onSaved: (value) => _name = value!,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email address';
                        }
                        return null;
                      },
                      onSaved: (value) => _email = value!,
                    ),
                    SizedBox(height: 20.0),
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
                      onSaved: (value) => _password = value!,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
              onPressed: singnup ,

    child: Text('Sign Up',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue, shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ), // White text color
                  padding: EdgeInsets.symmetric(vertical: 15.0), // Button padding
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
      context, // Pass the current context
      MaterialPageRoute(builder: (context) => LoginPage()), // Define the new screen (SecondScreen)
    );
                },
                child: Center(
                  child: Text(
                   "Already have account ? Login",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              
            ]))
            
            ));}
            }