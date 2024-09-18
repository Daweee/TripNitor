import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/admin/admin_homepage.dart';
import 'package:tripnitor_mobile_app/pages/admin/gas_admin_page.dart';
import 'package:tripnitor_mobile_app/pages/admin/booking_admin_page.dart';
import 'package:tripnitor_mobile_app/pages/admin/driver_admin_page.dart';
import 'package:tripnitor_mobile_app/pages/admin/package_admin_page.dart';
import 'package:tripnitor_mobile_app/pages/admin/van_admin_page.dart';
import 'package:tripnitor_mobile_app/pages/login_page.dart';
import 'package:tripnitor_mobile_app/providers/auth_provider.dart';
import 'package:tripnitor_mobile_app/services/token_service.dart';

class AdminDrawer extends ConsumerWidget {
  const AdminDrawer({Key? key}) : super(key: key);  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(ColorConstants.PRIMARY_COLOR),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Color(ColorConstants.PRIMARY_COLOR),
                    ),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      children: [
                        TextSpan(text: 'Welcome, '),
                        TextSpan(
                          text: '${authState.user?.username}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '!'),
                      ],
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              leading: SizedBox(
                width: 8.0,
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.gaugeHigh,
                    color: Color(ColorConstants.PRIMARY_COLOR),
                    size: 20.0,
                  ),
                  onPressed: () {},
                ),
              ),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AdminDashboard()),
                );
              },
            ),
            ListTile(
              leading: SizedBox(
                width: 8.0,
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.ticketSimple,
                    color: Color(ColorConstants.PRIMARY_COLOR),
                    size: 20.0,
                  ),
                  onPressed: () {},
                ),
              ),
              title: const Text('Bookings'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BookingAdminPage()),
                );
              },
            ),
            ListTile(
              leading: SizedBox(
                width: 8.0,
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.boxOpen,
                    color: Color(ColorConstants.PRIMARY_COLOR),
                    size: 20.0,
                  ),
                  onPressed: () {},
                ),
              ),
              title: const Text('Packages'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PackageAdminPage()),
                );
              },
            ),
            ListTile(
              leading: SizedBox(
                width: 8.0,
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.userTie,
                    color: Color(ColorConstants.PRIMARY_COLOR),
                    size: 20.0,
                  ),
                  onPressed: () {},
                ),
              ),
              title: const Text('Drivers'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DriverAdminPage()),
                );
              },
            ),
            ListTile(
              leading: SizedBox(
                width: 8.0,
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.vanShuttle,
                    color: Color(ColorConstants.PRIMARY_COLOR),
                    size: 20.0,
                  ),
                  onPressed: () {},
                ),
              ),
              title: const Text('Vans'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => VanAdminPage()),
                );
              },
            ),
            ListTile(
              leading: SizedBox(
                width: 8.0,
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.gasPump,
                    color: Color(ColorConstants.PRIMARY_COLOR),
                    size: 20.0,
                  ),
                  onPressed: () {},
                ),
              ),
              title: const Text('Gas'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GasAdminPage()),
                );
              },
            ),
            ListTile(
              leading: SizedBox(
                width: 8.0,
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.arrowRightFromBracket,
                    color: Color(ColorConstants.PRIMARY_COLOR),
                    size: 20.0,
                  ),
                  onPressed: () {},
                ),
              ),
              title: const Text('Logout'),
              onTap: () => _handleLogout(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final authNotifier = ref.read(authProvider.notifier);

    try {
      final refreshToken = await tokenService.getRefreshToken();
      if (refreshToken != null) {
        await authNotifier.logout(refreshToken);
        await tokenService.deleteTokens();

        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        _showErrorSnackBar(context, 'No refresh token found.');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Logout failed: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}
