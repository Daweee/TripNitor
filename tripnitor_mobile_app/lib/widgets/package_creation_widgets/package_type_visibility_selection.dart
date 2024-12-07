import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants/constant.dart';
import 'package_details_creation_page.dart';
import 'package_start_final_location.dart';

class PackageTypeVisibilitySelection extends StatefulWidget {
  const PackageTypeVisibilitySelection({super.key});

  @override
  State<PackageTypeVisibilitySelection> createState() =>
      _PackageTypeVisibilitySelectionState();
}

class _PackageTypeVisibilitySelectionState
    extends State<PackageTypeVisibilitySelection> {
  String selectedType = "NORTH";
  String selectedVisibility = "PRIVATE";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      child: _selectionBox(),
    );
  }

  Widget _selectionBox() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color(ColorConstants.BACKGROUND_COLOR),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Create Package',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          Divider(
            color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(.3),
            thickness: 1,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _titleRow('Type'),
                SizedBox(height: 10),
                _packageTypeChoices(),
                SizedBox(height: 25),
                _titleRow('Visibility'),
                SizedBox(height: 10),
                _visibilityChoices(),
                SizedBox(height: 10),
                _visibilityInfo(),
                SizedBox(height: 40),
                _confirmButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _visibilityInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 18,
            color: Colors.grey[600],
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              selectedVisibility == "PRIVATE"
                  ? "Private packages are only visible to you."
                  : "Public packages can be viewed by all users of the platform and can be joined by them.",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _visibilityChoices() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _choiceBox("PRIVATE", selectedVisibility),
          SizedBox(width: 10),
          _choiceBox("PUBLIC", selectedVisibility),
        ],
      ),
    );
  }

  Widget _packageTypeChoices() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _choiceBox("NORTH", selectedType),
          SizedBox(width: 10),
          _choiceBox("SOUTH", selectedType),
          SizedBox(width: 10),
          _choiceBox("CITY", selectedType),
        ],
      ),
    );
  }

  Widget _choiceBox(String value, String selectedValue) {
    bool isSelected = selectedValue == value;

    return InkWell(
      onTap: () {
        setState(() {
          if (selectedValue == selectedType) {
            selectedType = value;
          } else {
            selectedVisibility = value;
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? Color(ColorConstants.PRIMARY_COLOR) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Color(ColorConstants.PRIMARY_COLOR),
            width: 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          value,
          style: TextStyle(
            color:
                isSelected ? Colors.white : Color(ColorConstants.PRIMARY_COLOR),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _confirmButton() {
    return Container(
      height: 45,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PackageDetailsCreationPage(
                packageType: selectedType,
                packageVisibility: selectedVisibility,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Confirm',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _titleRow(String title) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(ColorConstants.PRIMARY_COLOR),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          height: 20,
          width: 5,
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
