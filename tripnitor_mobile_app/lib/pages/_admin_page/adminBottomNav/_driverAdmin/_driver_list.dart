import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/models/_driver_save_task.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/models/_driver_task.dart';
import 'package:tripnitor_mobile_app/pages/driver_homepage.dart';

final driverSaveTaskProvider =
    ChangeNotifierProvider((ref) => DriverSaveTask()); // global variable

class DriverList extends StatefulWidget {
  const DriverList({super.key});

  @override
  State<DriverList> createState() => _DriverListState();
}

class _DriverListState extends State<DriverList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Column(
        children: [
          _header(),
          _subHeader(),
          //_DriverListBody(),
          // Expanded(
          //   child: _DriverListBody(), // Updated to render the driver list body
          // ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .065,
      color: Color(ColorConstants.PRIMARY_COLOR),
      child: Center(
        child: Text(
          'Tripnitor Admin',
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
        ),
      ),
    );
  }

  Widget _subHeader() {
    return Container(
      padding: EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Driver List:',
            style: TextStyle(fontSize: 16),
          ),
          GestureDetector(
            onTap: () {},
            child: Image(
              image: AssetImage(
                'assets/icons/carbon_add-filled.png',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // dynamically add list of drivers by admin; to be continued
  Widget _DriverListBody() {
    return Consumer(
      builder: (context, ref, child) {
        final driverTask =
            ref.watch(driverSaveTaskProvider); // watch is depreciated

        return ListView.builder(
          itemCount: driverTask.fromDriverTask.length,
          itemBuilder: (BuildContext context, index) {
            return ListTile(
              title: Text(
                driverTask.fromDriverTask[index].title,
                style: TextStyle(
                  decoration: driverTask.fromDriverTask[index].isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              trailing: Wrap(
                children: [
                  Checkbox(
                    value: driverTask.fromDriverTask[index].isCompleted,
                    onChanged: (_) {
                      ref.read(driverSaveTaskProvider.notifier).checkDriverTask(index); //  context.read<DriverSaveTask>().checkDriverTask(index);
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(driverSaveTaskProvider.notifier).removeDriverTask( 
                            driverTask.fromDriverTask[index], //  context.read<DriverSaveTask>().removeDriverTask
                          );
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
