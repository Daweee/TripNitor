import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/models/_driver_list.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_vanAdmin/models/_van_list.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_vanAdmin/models/_van_task.dart';

class AddVan extends ConsumerWidget {
  // stateless
  AddVan({super.key});

  final controller = TextEditingController();
  //
  final modelController = TextEditingController();
  final plateNumController = TextEditingController();
  final dateStartController = TextEditingController();
  final dateExpiryController = TextEditingController();
  final maxController = TextEditingController();
  final gasIdController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Van'),
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
                hintText: 'Add Van Brand',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: modelController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Add Van\'s Model',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: plateNumController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Add Van\'s Plate Number',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: dateStartController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Add Date Bought',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: dateExpiryController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Registration Expiry Date',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: maxController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Add Max Passenger',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: gasIdController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Add Gas Id',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(vanSaveTaskProvider.notifier).addVanTask(
                      VanTask(
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
