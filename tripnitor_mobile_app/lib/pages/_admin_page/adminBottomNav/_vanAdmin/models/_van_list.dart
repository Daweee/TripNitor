import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_vanAdmin/_van_details.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_vanAdmin/models/_van_add.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_vanAdmin/models/_van_save_task.dart';

final vanSaveTaskProvider =
    ChangeNotifierProvider((ref) => VanSaveTask()); // riverpod global variable

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
          Expanded(
            child: Container(
              margin: EdgeInsets.all(15),
              child: _VanListBody(),
            ),
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
            'Van List:',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _VanListBody() {
    return Consumer(
      builder: (context, ref, child) {
        final vanTask = ref.watch(vanSaveTaskProvider);
        return ListView.builder(
          itemCount: vanTask.fromVanTask.length,
          itemBuilder: (BuildContext context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VanDetail(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Model: ${vanTask.fromVanTask[index].title}',
                                  ),
                                  Text('Plate No: '),
                                ],
                              ),
                            ),
                            
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit, color: Colors.green),
                                ),
                                IconButton(
                                  onPressed: () {
                                    ref
                                        .read(vanSaveTaskProvider.notifier)
                                        .removeVanTask(
                                          vanTask.fromVanTask[
                                              index], //  context.read<DriverSaveTask>().removeDriverTask
                                        );
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
