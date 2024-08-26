import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripnitor_mobile_app/pages/package_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting, // .fixed
        selectedItemColor: Colors.deepOrange, // backgroundColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: (value) {
          // setState(() {

          // });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded),
            label: "Message",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildUI() {
    return Column( // SafeArea()
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
          // Container(
          //   // width: MediaQuery.of(context).size.width,
          //   // height: MediaQuery.of(context).size.height * .40,
          //   //color: Colors.deepOrange,
          //   child: Center(
          //     child: Image(
          //       image: AssetImage(
          //         'assets/images/homepage_images.png',
          //       ),
          //     ),
          //   ),
          // ),
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
                children: [
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
