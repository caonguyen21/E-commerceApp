import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/appstyle.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Profile page",
            style: appstyle(36, Colors.black, FontWeight.bold)),
      ),
    );
  }
}
