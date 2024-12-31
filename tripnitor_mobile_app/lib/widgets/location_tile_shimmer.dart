import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../core/constants/constant.dart';

class LocationTileShimmer extends StatelessWidget {
  final int count;

  const LocationTileShimmer({
    super.key,
    this.count = 5,
  });

  Widget _buildShimmerTile() {
    return ListTile(
      leading: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      title: Container(
        width: double.infinity,
        height: 16,
        margin: const EdgeInsets.only(right: 48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      subtitle: Container(
        width: double.infinity,
        height: 12,
        margin: const EdgeInsets.only(right: 80, top: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1500),
      baseColor: Color(ColorConstants.SECONDARY_COLOR).withOpacity(0.3),
      highlightColor: Color(ColorConstants.BACKGROUND_COLOR).withOpacity(0.3),
      child: Column(
        children: List.generate(
          count,
          (index) => _buildShimmerTile(),
        ),
      ),
    );
  }
}
