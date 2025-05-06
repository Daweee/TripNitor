import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/user/user_bottom_nav/booking_page.dart';
import 'package:tripnitor_mobile_app/pages/user/user_bottom_nav/profile_page.dart';
import 'package:tripnitor_mobile_app/pages/user/package_page.dart';

final bottomNavIndexProvider = StateProvider((ref) => 0);

void resetToHomePage(WidgetRef ref) {
  ref.read(bottomNavIndexProvider.notifier).state = 0;
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      resetToHomePage(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      body: _buildPage(currentPage),
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: const Offset(0, -4),
              blurRadius: 5,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
          currentIndex: currentPage,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          onTap: (value) {
            ref.read(bottomNavIndexProvider.notifier).state = value;
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
        return const MyHomePage();
      case 1:
        return const BookingPage();
      case 2:
        return const ProfilePage();
      default:
        return const MyHomePage();
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
      children: [
        _buildHeader(context),
        _buildVanCard(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight * 0.2,
      color: Color(ColorConstants.PRIMARY_COLOR),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: const Text(
                    'Welcome to Tripnitor',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 25,
                  ),
                  child: const Text(
                    'For affordable, convenient, and safe trips',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Image.asset(
              'assets/images/homepage_images.png',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVanCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(30),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PackagePage(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              width: 150,
              height: 80,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(1),
                    offset: const Offset(0, 4),
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
          ),
        ],
      ),
    );
  }
}
