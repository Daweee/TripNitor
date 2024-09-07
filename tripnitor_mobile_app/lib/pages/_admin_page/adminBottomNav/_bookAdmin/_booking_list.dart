import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_bookAdmin/_booking_add.dart';

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
      floatingActionButton: FloatingActionButton(
        //backgroundColor: Color(Colors.white),
        onPressed: () {
          // Navigator.of(context).pushNamed(AddDriver());
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddBooking()));
        },
        child: const Icon(Icons.add, color: Color(ColorConstants.ACCENT_COLOR)),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //_header(),
          // _subHeader(),
          // Expanded(
          //   child: Container(
          //     margin: EdgeInsets.all(15),
          //     child: _BookingListBody(),
          //   ),
          // ),
          Center(
            child: Text('Booking List'),
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
        children: [
          Text(
            'Booking List:',
            style: TextStyle(fontSize: 16),
          ),
          _BookingNavStatus(),
        ],
      ),
    );
  }

  Widget _BookingNavStatus() {
    return Center();
  }

  Widget _BookingListBody() {
    return Center();
  }
}
