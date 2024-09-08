import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/constant.dart';

class PackageDetailShimmer extends StatelessWidget {
  const PackageDetailShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color(ColorConstants.SECONDARY_COLOR).withOpacity(.3),
      highlightColor: Color(ColorConstants.BACKGROUND_COLOR).withOpacity(.3),
      child: Column(
        children: [
          Expanded(child: _buildShimmerContent()),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildShimmerContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 24,
            color: Colors.white,
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Container(width: 60, height: 16, color: Colors.white),
              SizedBox(width: 8),
              Container(width: 60, height: 16, color: Colors.white),
            ],
          ),
          SizedBox(height: 20),
          _buildShimmerSection('Description'),
          SizedBox(height: 20),
          _buildShimmerSection('Locations'),
          SizedBox(height: 20),
          _buildShimmerSection('Itinerary'),
        ],
      ),
    );
  }

  Widget _buildShimmerSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 5, height: 20, color: Colors.white),
            SizedBox(width: 10),
            Container(width: 100, height: 20, color: Colors.white),
          ],
        ),
        SizedBox(height: 10),
        Container(width: double.infinity, height: 60, color: Colors.white),
        SizedBox(height: 8),
        Container(width: double.infinity, height: 60, color: Colors.white),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 75.0,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(.3),
            width: 1.0,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 60, height: 12, color: Colors.white),
              SizedBox(height: 4),
              Container(width: 80, height: 18, color: Colors.white),
            ],
          ),
          Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ],
      ),
    );
  }
}