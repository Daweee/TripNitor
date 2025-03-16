import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/user/user_bottom_nav/booking_page.dart';
import 'package:tripnitor_mobile_app/pages/user/user_bottom_nav/message_page.dart';
import 'package:tripnitor_mobile_app/pages/user/user_bottom_nav/profile_page.dart';
import 'package:tripnitor_mobile_app/pages/user/package_page.dart';

final bottomNavIndexProvider = StateProvider((ref) => 0);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(currentPage),
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(1),
            offset: Offset(0, -4),
            blurRadius: 5,
          ),
        ]),
        child: BottomNavigationBar(
          backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
          currentIndex: currentPage,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          onTap: (value) {
            setState(
              () {
                currentPage = value;
              },
            );
          },
          items: const [
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.book),
              icon: Icon(Icons.book_outlined),
              label: "Bookings",
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.chat_bubble),
              icon: Icon(Icons.chat_bubble_outline_rounded),
              label: "Message",
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return MyHomePage();
      case 1:
        return BookingPage();
      case 2:
        return MessagePage();
      case 3:
        return ProfilePage();
      default:
        return MyHomePage();
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Column(
      // SafeArea()
      children: [
        _header(),
        _vanCard(),
      ],
    );
  }

  Widget _header() {
    return Container(
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .20,
            color: Color(ColorConstants.PRIMARY_COLOR),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: Text(
                          'Welcome to Tripnitor',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 25,
                        ),
                        child: Text(
                          'For affordable, convenient, and safe trips',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Image(
                    image: AssetImage(
                      'assets/images/homepage_images.png',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vanCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PackagePage(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(
          30,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 10,
              ),
              width: 150,
              height: 80,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(1),
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
                color: Color(ColorConstants.TERTIARY_COLOR),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: const [
                  Expanded(
                    child: Image(
                      image: AssetImage('assets/images/ph_van-fill.png'),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Van'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
