import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import '../pages/package_detail_page.dart';
import '../providers/package_provider.dart';
import 'shimmer_package_card.dart';
import 'package:flutter_dash/flutter_dash.dart';

class PackageCard extends ConsumerWidget {
  const PackageCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageState = ref.watch(packageProvider);
    final filteredPackages = ref.watch(filteredPackagesProvider);

    if (packageState.isLoading) {
      return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => ShimmerPackageCard(),
      );
    }

    if (filteredPackages.isEmpty) {
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Center(
              child: Text('No packages available'),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      itemCount: filteredPackages.length,
      itemBuilder: (context, index) {
        final package = filteredPackages[index];
        return Container(
          height: 150.0,
          margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xFF000000).withOpacity(0.2),
                offset: Offset(0, 4),
                blurRadius: 4,
              ),
            ],
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(ColorConstants.BACKGROUND_COLOR),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.solidCircleDot,
                            size: 16.0,
                            color: Color(0xFFFB0000),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              package.startLocation.name,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Dash(
                          direction: Axis.vertical,
                          length: 60,
                          dashLength: 5,
                          dashColor: Colors.black.withOpacity(.5),
                          dashGap: 5,
                          dashThickness: 2,
                        ),
                      ),
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.locationDot,
                            size: 19.0,
                            color: Colors.black,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              package.finalDestination.name,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(ColorConstants.SECONDARY_COLOR),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "| ${package.packageType}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "| ${package.visibility}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "₱${package.basePrice}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Prices may vary",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 35.0,
                            decoration: BoxDecoration(
                              color: Color(
                                  ColorConstants.BOTTOM_PACKAGE_CARD_COLOR),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(right: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PackageDetailPage(
                                                  packageId: package.id),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "show more",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  FaIcon(
                                    FontAwesomeIcons.angleRight,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
