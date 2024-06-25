// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final supabaseClient = Supabase.instance.client;

    final currentUser = supabaseClient.auth.currentUser?.email;

    if (currentUser == null) {
      print('Current user is null. Authentication issue.');
      return;
    }

    final response = await supabaseClient
        .from('users')
        .select()
        .eq('email', currentUser)
        .single();

    setState(() {
      userData = response as Map<String, dynamic>?;

      print(userData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          userData == null
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      child: Icon(
                        Icons.account_circle,
                        size: 100,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      '${userData!['name']}',
                      style:
                          TextStyle(fontSize: 34, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Center(
                        child: Text(
                      '${userData!['email']}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                    )),
                  ],
                ),
        ],
      ),
    );
  }
}
