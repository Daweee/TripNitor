import 'package:flutter/material.dart';

import '../../core/constants/constant.dart';
import 'admin_drawer.dart';

class PackageAdminPage extends StatefulWidget {
  const PackageAdminPage({super.key});

  @override
  State<PackageAdminPage> createState() => _PackageAdminPageState();
}

class _PackageAdminPageState extends State<PackageAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: Text(
            'Packages',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
          scrolledUnderElevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Divider(
              color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(.3),
              thickness: 1,
              height: 1,
            ),
          ),
        ),
      ),
      drawer: const AdminDrawer(),
      body: Center(
        child: Text('Admin Homepage Content'),
      ),
    );
  }
}
