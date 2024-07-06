import 'package:flutter/material.dart';
import 'package:flutter_audiobook/core/data/local/constant.dart';
import 'package:flutter_audiobook/core/data/local/shared_pref.dart';
import 'package:iconsax/iconsax.dart';

import '../../dialog/custom_logot_dialog.dart';
import '../sign_up/sign_up.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SharedPreferencesHelper shared = SharedPreferencesHelper();


  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomLogOutDialog(
          onLogout: () {
            shared.setBool(Constants.isVerified, false);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) =>  LoginScreen()),
                  (Route<dynamic> route) => false,
            );
            Navigator.of(context).pop();
          },
          onUnregister: () {
            shared.setBool(Constants.isVerified, false);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) =>  LoginScreen()),
                  (Route<dynamic> route) => false,
            );
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF26B6C),
        title: const Center(
            child: Text(
          'Profile',
          style: TextStyle(
              fontFamily: 'PaynetB',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF)),
        )),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.logout, color: Color(0xFFFFFFFF)),
            onPressed: () {
              _showLogoutDialog();
              // Handle more button press
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color(0xFFF26B6C),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16))),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(
                          'https://img.freepik.com/premium-photo/young-handsome-man-with-beard-isolated-keeping-arms-crossed-frontal-position_1368-132662.jpg'),
                    ),
                    Text(
                      'Marea Akter dipi',
                      style: TextStyle(
                          fontFamily: 'PaynetB',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF)),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          Text(
                            'Username',
                            style: TextStyle(
                                fontFamily: 'PaynetB',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF26B6C)),
                          ),
                          Spacer(),
                          Text(
                            'abu_006',
                            style: TextStyle(
                                fontFamily: 'PaynetB',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 2,
                      color: Color(0xffdcd9dc),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(
                                fontFamily: 'PaynetB',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF26B6C)),
                          ),
                          Spacer(),
                          Text(
                            'abu@gmail.com',
                            style: TextStyle(
                                fontFamily: 'PaynetB',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 2,
                      color: Color(0xffd7d5d7),
                    ) ,
                    Row(
                      children: [
                        const Text(
                          'Change Password',
                          style: TextStyle(
                              fontFamily: 'PaynetB',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF26B6C)),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.chevron_right_rounded))
                      ],
                    ),
                    const Divider(
                      height: 2,
                      color: Color(0xffdcd9dc),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Notification',
                          style: TextStyle(
                              fontFamily: 'PaynetB',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF26B6C)),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Iconsax.notification))
                      ],
                    ),
                    const Divider(
                      height: 2,
                      color: Color(0xffdcd9dc),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Enable dark mode',
                          style: TextStyle(
                              fontFamily: 'PaynetB',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF26B6C)),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.dark_mode_outlined))
                      ],
                    ),
                    const Divider(
                      height: 2,
                      color: Color(0xffdcd9dc),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Settings',
                          style: TextStyle(
                              fontFamily: 'PaynetB',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF26B6C)),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.settings_outlined))
                      ],
                    ),
                    const Divider(
                      height: 2,
                      color: Color(0xffdcd9dc),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
