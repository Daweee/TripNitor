import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/login_page.dart';

import '../../../providers/auth_provider.dart';
import '../../../services/token_service.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: AppBar(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text('Profile'),
          ),
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    final authState = ref.watch(authProvider);

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF000000).withOpacity(.1),
                        offset: Offset(0, 4),
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/Unknown_person.jpg'),
                    minRadius: 15,
                    maxRadius: 55,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '${authState.user?.name}',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
              children: const [
                Icon(Icons.person_2_rounded),
                SizedBox(width: 8.0),
                Text('My Profile'),
                Spacer(),
                Row(
                  children: [
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
              children: [
                Icon(Icons.settings),
                SizedBox(width: 8.0),
                Text('Settings'),
                Spacer(),
                Row(
                  children: [
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Icon(Icons.logout_rounded),
              SizedBox(width: 8.0),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final authNotifier = ref.read(authProvider.notifier);

                    try {
                      final refreshToken = await tokenService.getRefreshToken();
                      if (refreshToken != null) {
                        await authNotifier.logout(refreshToken);
                        await tokenService.deleteTokens();
                        if (mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        }
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No refresh token found.')),
                          );
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Logout failed: ${e.toString()}')),
                        );
                      }
                    }
                  },
                  child: authState.isLoading
                      ? Center(
                          child: SizedBox(
                            width: 25.0,
                            height: 25.0,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3.0,
                            ),
                          ),
                        )
                      : Text('Log Out'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
