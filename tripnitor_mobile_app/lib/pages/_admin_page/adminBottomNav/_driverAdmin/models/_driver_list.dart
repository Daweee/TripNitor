import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/models/_driver_add.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/models/_driver_details.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/models/_driver_save_task.dart';

import 'package:tripnitor_mobile_app/pages/driver_homepage.dart';

final driverSaveTaskProvider = ChangeNotifierProvider(
    (ref) => DriverSaveTask()); // riverpodglobal variable

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
      floatingActionButton: FloatingActionButton(
        //backgroundColor: Color(Colors.white),
        onPressed: () {
          // Navigator.of(context).pushNamed(AddDriver());
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddDriver()));
        },
        child: const Icon(Icons.add, color: Color(ColorConstants.ACCENT_COLOR),),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Column(
        children: [
          _subHeader(),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(15),
              child: _DriverListBody(),
            ), // Updated to render the driver list body
          ),
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
            'Driver List:',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  // dynamically add list of drivers by admin; to be continued
  // Widget _DriverListBody() {
  //   return Consumer(
  //     builder: (context, ref, child) {
  //       final driverTask =
  //           ref.watch(driverSaveTaskProvider); // watch is depreciated

  //       return ListView.builder(
  //         itemCount: driverTask.fromDriverTask.length,
  //         itemBuilder: (BuildContext context, index) {
  //           return ListTile(

  //             title: Text(
  //               driverTask.fromDriverTask[index].title,
  //               style: TextStyle(
  //                 decoration: driverTask.fromDriverTask[index].isCompleted
  //                     ? TextDecoration.lineThrough
  //                     : TextDecoration.none,
  //               ),
  //             ),
  //             trailing: Wrap(
  //               children: [
  //                 Checkbox(
  //                   value: driverTask.fromDriverTask[index].isCompleted,
  //                   onChanged: (_) {
  //                     ref.read(driverSaveTaskProvider.notifier).checkDriverTask(
  //                         index); //  context.read<DriverSaveTask>().checkDriverTask(index);
  //                   },
  //                 ),
  //                 IconButton(
  //                   onPressed: () {
  //                     ref
  //                         .read(driverSaveTaskProvider.notifier)
  //                         .removeDriverTask(
  //                           driverTask.fromDriverTask[
  //                               index], //  context.read<DriverSaveTask>().removeDriverTask
  //                         );
  //                   },
  //                   icon: const Icon(
  //                     Icons.delete,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Widget _DriverListBody() {
    return Consumer(
      builder: (context, ref, child) {
        final driverTask =
            ref.watch(driverSaveTaskProvider); // watch is depreciated

        return ListView.builder(
          itemCount: driverTask.fromDriverTask.length,
          itemBuilder: (BuildContext context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DriverDetails(),
                      ),
                    );
                  },
                  child: Container(
                    // decoration: BoxDecoration(boxShadow: ),
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    Text(
                                      'Name: ${driverTask.fromDriverTask[index].name}',
                                      // style: TextStyle(
                                      //   decoration: driverTask
                                      //           .fromDriverTask[index]
                                      //           .isCompleted
                                      //       ? TextDecoration.lineThrough
                                      //       : TextDecoration.none,
                                      // ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Age: ${driverTask.fromDriverTask[index].age}',
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Gender: ${driverTask.fromDriverTask[index].gender}',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: 30,
                        // ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // ...
                                },
                                icon: Icon(
                                  Icons.edit_square,
                                  color: Colors.green,
                                ),
                              ),
                              IconButton( 
                                onPressed: () {
                                  ref
                                      .read(driverSaveTaskProvider.notifier)
                                      .removeDriverTask(
                                        driverTask.fromDriverTask[
                                            index], //  context.read<DriverSaveTask>().removeDriverTask
                                      );
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // trailing: Wrap(
                //   children: [
                //     Checkbox(
                //       value: driverTask.fromDriverTask[index].isCompleted,
                //       onChanged: (_) {
                //         ref.read(driverSaveTaskProvider.notifier).checkDriverTask(
                //             index); //  context.read<DriverSaveTask>().checkDriverTask(index);
                //       },
                //     ),
                //     IconButton(
                //       onPressed: () {
                //         ref
                //             .read(driverSaveTaskProvider.notifier)
                //             .removeDriverTask(
                //               driverTask.fromDriverTask[
                //                   index], //  context.read<DriverSaveTask>().removeDriverTask
                //             );
                //       },
                //       icon: const Icon(
                //         Icons.delete,
                //       ),
                //     ),
                //   ],
                // ),
              ),
            );
          },
        );
      },
    );
  }
}
