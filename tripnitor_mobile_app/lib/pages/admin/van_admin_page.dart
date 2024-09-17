import 'package:flutter/material.dart';
import 'package:tripnitor_mobile_app/pages/admin/forms/van_form.dart';

import '../../constants/constant.dart';
import 'admin_drawer.dart';

class VanAdminPage extends StatefulWidget {
  const VanAdminPage({super.key});

  @override
  State<VanAdminPage> createState() => _VanAdminPageState();
}

class _VanAdminPageState extends State<VanAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: Text(
            'Vans',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VanForm(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      ),
    );
  }
}
