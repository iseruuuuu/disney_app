import 'package:disney_app/core/theme/app_color_style.dart';
import 'package:disney_app/screen/account/account_screen.dart';
import 'package:disney_app/screen/time_line/time_line_screen.dart';
import 'package:flutter/material.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int selectedIndex = 0;
  List<Widget> pageList = [
    const TimeLineScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade400,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.white,
          selectedItemColor: AppColorStyle.appColor,
          unselectedItemColor: Colors.black,
          iconSize: 30,
          selectedFontSize: 13,
          unselectedFontSize: 13,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Icon(Icons.home, size: 30),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Icon(Icons.account_box_sharp, size: 30),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
