import 'package:bebeautyapp/repo/providers/category_provider.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/repo/services/chat_services.dart';

import 'package:bebeautyapp/ui/home/chat/chat.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:bebeautyapp/ui/home/homes/home.dart';
import 'package:bebeautyapp/ui/profile/profile_screen.dart';
import 'package:bebeautyapp/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'model/user/MUser.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 0;
  String userID = "";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MUser_IsNotLogout?>(context);
    final userProvider = Provider.of<UserProvider>(context);

    if (user!.uid != null) userID = user.uid.toString();
    if (userID == "") userProvider.getUser(user.uid.toString());
    userID = user.uid.toString();
    ChatServices database = ChatServices();
    String chatRoomId = userID;
    database.seen(chatRoomId);
    List<Widget> _body = [
      HomeScreens(),
      // const Chat(),
      Chat(
          chatRoomId: chatRoomId,
          user_id: userID,
          user_name: userProvider.user.getName()),
      ProfileScreens(),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: _body.elementAt(_page),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kBgColor,
        unselectedItemColor: kUnselectedColor,
        selectedItemColor: Colors.black87,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(
            () {
              _page = index;
            },
          );
        },
        currentIndex: _page,
      ),
    );
  }
}
