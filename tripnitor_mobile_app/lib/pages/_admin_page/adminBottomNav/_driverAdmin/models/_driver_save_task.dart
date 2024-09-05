import 'package:flutter/material.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/models/_driver_task.dart';

class DriverSaveTask extends ChangeNotifier {
  List<DriverTask> _driverTaskList = [];

  // get
  List<DriverTask> get fromDriverTask => _driverTaskList;


  // add driver
  void addDriverTask(DriverTask addDriver) {
    fromDriverTask.add(addDriver);
    notifyListeners();
  }

  // remove driver
  void removeDriverTask(DriverTask removeDriver) {
    fromDriverTask.remove(removeDriver);
    notifyListeners();
  }

  // edit driver
  // void editDriverTask() {}

  void checkDriverTask(int index) {
    fromDriverTask[index].isDone();
    notifyListeners();
  }

}