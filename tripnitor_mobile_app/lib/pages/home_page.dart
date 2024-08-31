import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/pages/package_page.dart';

final bottomNavIndexProvider = StateProvider((ref) => 0); // riverpod

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    //, WidgetRef ref
    return Scaffold(
      body: _buildPage(currentPage), // pages[currentPage],//_buildUI(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        type: BottomNavigationBarType.fixed, // .fixed; .shifting;
        selectedItemColor: Colors.deepOrange, // backgroundColor: Colors.black,
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
            icon: Icon(Icons.home), // 0
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book), // 1
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded), // 2
            label: "Message",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // 3
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        //return HomePage();
        return MyHomePage();
      case 1:
        return bookingPage();
      case 2:
        return messagePage();
      case 3:
        return profilePage();
      default:
        return bookingPage();
    }
  }
}

// Home Page
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            color: Colors.deepOrange,
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
            builder: (context) => PackageTrips(),
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
                color: Colors.deepOrange,
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

// booking
class bookingPage extends StatefulWidget {
  const bookingPage({super.key});

  @override
  State<bookingPage> createState() => _bookingPageState();
}

class _bookingPageState extends State<bookingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Booking Page'),
    );
  }
}

// message
class messagePage extends StatelessWidget {
  const messagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Message Page'),
    );
  }
}

// profile
class profilePage extends StatefulWidget {
  const profilePage({super.key});

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Profile Page'),
      ),
    );
  }
}
