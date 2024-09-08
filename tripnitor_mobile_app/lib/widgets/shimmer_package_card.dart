import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/constant.dart';

class ShimmerPackageCard extends StatelessWidget {
  const ShimmerPackageCard({Key? key}) : super(key: key);

  @override
    Widget build(BuildContext context) {
        return Shimmer.fromColors(
            period: const Duration(milliseconds: 500),
            baseColor: Color(ColorConstants.SECONDARY_COLOR).withOpacity(.3),
            highlightColor: Color(ColorConstants.BACKGROUND_COLOR).withOpacity(.3),
            child: Container(
                height: 150.0,
                margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                ),
            ),
        );
    }
}