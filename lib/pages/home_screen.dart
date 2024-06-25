// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:youtube_clone/pages/profile_page.dart';
import 'package:youtube_clone/pages/videos_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 6),
              Text(
                "YouTube",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.cast),
              onPressed: () {
                
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications_outlined),
              onPressed: () {
               
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                
              },
            ),
            SizedBox(width: 5),
          ],
        ),
        bottomNavigationBar: Material(
          elevation: 8,
          color: Colors.white,
          child: TabBar(
            indicatorColor: Colors.transparent,
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: 'Home',
              ),
              Tab(
                icon: Icon(Icons.video_collection_rounded),
                text: 'Shorts',
              ),
              Tab(
                icon: Icon(Icons.add_circle_outline_rounded, size: 45),
              ),
              Tab(
                icon: Icon(Icons.subscriptions),
                text: 'Subscriptions',
              ),
              Tab(
                icon: Icon(Icons.account_circle),
                text: 'You',
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            VideoListPage(), 
            Center(child: Text('Explore Page')),
            Center(child: Text('Upload Video')),
            Center(child: Text('Subscriptions Page')),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}
