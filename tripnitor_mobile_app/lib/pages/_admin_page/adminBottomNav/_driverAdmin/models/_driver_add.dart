import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/_driver_list.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/models/_driver_task.dart';

class AddDriver extends ConsumerWidget {
  // stateless
  AddDriver({super.key});

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Driver'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Add Driver',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(driverSaveTaskProvider.notifier).addDriverTask(
                      DriverTask(
                        title: controller.text,
                        isCompleted: false,
                      ),
                    );
                controller.clear();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
