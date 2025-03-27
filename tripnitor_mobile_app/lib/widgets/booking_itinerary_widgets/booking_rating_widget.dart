import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/constant.dart';
import 'rating_submission_page.dart';

class BookingRatingWidget extends ConsumerWidget {
  final String bookingId;

  const BookingRatingWidget({Key? key, required this.bookingId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rate Your Trip Experience',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: RatingBar.builder(
              initialRating: 5,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Color(ColorConstants.PRIMARY_COLOR),
              ),
              onRatingUpdate: (rating) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RatingSubmissionPage(
                      bookingId: bookingId,
                      initialRating: rating,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
