import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/constant.dart';

class ShimmerReverseGeocodingLocation extends StatelessWidget {
  const ShimmerReverseGeocodingLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 500),
      baseColor: Color(ColorConstants.SECONDARY_COLOR).withOpacity(.3),
      highlightColor: Color(ColorConstants.BACKGROUND_COLOR).withOpacity(.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
