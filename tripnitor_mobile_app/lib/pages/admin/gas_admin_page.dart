import 'package:flutter/material.dart';

import '../../constants/constant.dart';
import 'admin_drawer.dart';

class GasAdminPage extends StatefulWidget {
  const GasAdminPage({super.key});

  @override
  State<GasAdminPage> createState() => _GasAdminPageState();
}

class _GasAdminPageState extends State<GasAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: Text(
            'Gas',
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
