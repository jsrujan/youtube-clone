// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube_clone/backend/auth_service.dart';
import 'package:youtube_clone/pages/home_screen.dart';
import 'package:youtube_clone/pages/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();


  final AuthService _authService = AuthService();

 
  void _signUp() async {
    try {
      await _authService.signUp(
          _emailController.text, _passwordController.text);
      final supabase = Supabase.instance.client;
      final response = await supabase.from("users").insert({
        "name" : _nameController.text,
        "email" : _emailController.text,
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sign up successful!')));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sign up failed: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              child: Icon(
                Icons.play_arrow_rounded,
                size: 60,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "SIGN UP TO YOUTUBE",
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 23,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  labelText: 'Email'),
            ),
            SizedBox(
              height: 12,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(
              height: 12,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  labelText: 'Name'),
            ),
      
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Sign Up'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
