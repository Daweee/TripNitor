import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      appBar: AppBar(
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
      child: Center(
        child: Column(
          children: [
            CircleAvatar(),
            Text('${authState.user?.name}'),
            Text('Billing Details'),
            SizedBox(
              height: 90,
            ),
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
                            MaterialPageRoute(builder: (context) => LoginPage()),
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
                        SnackBar(content: Text('Logout failed: ${e.toString()}')),
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
      ),
    );
  }

  
}
