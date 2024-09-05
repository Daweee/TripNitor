import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_vanAdmin/_van_add.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_vanAdmin/models/_van_save_task.dart';


final vanSaveTaskProvider = ChangeNotifierProvider(
    (ref) => VanSaveTask()); // riverpod global variable


class VanList extends StatefulWidget {
  const VanList({super.key});

  @override
  State<VanList> createState() => _VanListState();
}

class _VanListState extends State<VanList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        //backgroundColor: Color(Colors.white),
        onPressed: () {
          // Navigator.of(context).pushNamed(AddDriver());
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddVan()));
        },
        child: const Icon(Icons.add, color: Color(ColorConstants.ACCENT_COLOR)),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Column(
        children: [
          //_header(),
          _subHeader(),
          
          
        ],
      ),
    );
  }

  Widget _subHeader() {
    return Container(
      padding: EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'Van List:',
            style: TextStyle(fontSize: 16),
          ),
          
        ],
      ),
    );
  }

}