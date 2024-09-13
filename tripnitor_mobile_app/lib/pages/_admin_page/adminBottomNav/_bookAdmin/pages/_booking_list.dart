import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_bookAdmin/pages/_booking_add.dart';


class BookingList extends StatefulWidget {
  const BookingList({super.key});

  @override
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
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
          _subHeader(),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: _BookingListBody(),
          ),
        ],
      ),
    );
  }

  Widget _subHeader() {
    return Container(
      padding: EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text(
            'Booking List:',
            style: TextStyle(fontSize: 16),
          ),
          ChipNavCategory(),
        ],
      ),
    );
  }


  Widget _buildChipNavCategory() {
    return Container();
  }

  Widget _buildBookingCard() {
    return Container();
  }

  Widget _BookingListBody() {
    return Container(
      child: Center(
        child: Text('Booking'),
      ),
    );
  }
}


// libog ko if mag seperate class kos chip navigation or widget method lang
class ChipNavCategory extends StatefulWidget {
  const ChipNavCategory({super.key});

  @override
  State<ChipNavCategory> createState() => _ChipNavCategoryState();
}

class _ChipNavCategoryState extends State<ChipNavCategory> {
  String selectedCatergoy = "All";

  List<String> categories = [
    "All",
    "Pending",
    "Ongoing",
    "Finished",
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: SizedBox(
        height: 25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) => _buildCategory(index),
        ),
      ),
    );
  }

  Widget _buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                // use ChoiceChip()
                categories[index],
                style: TextStyle(
                  color: selectedIndex == index ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
