import 'package:flutter/material.dart';
import 'package:tripnitor_mobile_app/models/van_model.dart';

class VanSaveTask extends ChangeNotifier {
  List<VanTask> _vanTaskList = [];

  // get
  List<VanTask> get fromVanTask => _vanTaskList;


  // add van
  void addVanTask(VanTask addDriver) {
    fromVanTask.add(addDriver);
    notifyListeners();
  }

  // remove van
  void removeVanTask(VanTask removeDriver) {
    fromVanTask.remove(removeDriver);
    notifyListeners();
  }

  // check van
  void checkVanTask(int index) {
    fromVanTask[index].isDone();
    notifyListeners();
  }

}