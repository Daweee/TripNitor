import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/models/driver_model.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/models/_driver_list.dart';


class AddDriver extends ConsumerWidget {
  // stateless
  AddDriver({super.key});

  final titleController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();

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
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Add Driver\'s Name',
              ),
            ),
            TextField(
              controller: ageController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Add Driver\'s Age',
              ),
            ),
            TextField(
              controller: genderController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Add Driver\'s Gender',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                int age; //= int.tryParse(ageController.text);
                try {
                  age = int.parse(ageController.text);
                } catch (e) {
                  // Show an error message if age is not a valid integer
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid age')),
                  );
                  return; // Exit the onPressed callback early
                }
                ref.read(driverSaveTaskProvider.notifier).addDriverTask(
                      DriverTask(
                        title: titleController.text,
                        name: nameController.text,
                        age: age,
                        gender: genderController.text,
                        isCompleted: false,
                      ),
                    );
                titleController.clear();
                nameController.clear();
                ageController.clear();
                genderController.clear();
                Navigator.of(context).pop();
              },
              // ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(content: Text('Please enter a valid Driver\'s credentials')),
              //     );
              child: Text('Add Driver'),
            ),
          ],
        ),
      ),
    );
  }
}
