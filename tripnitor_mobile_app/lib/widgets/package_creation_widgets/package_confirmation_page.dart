import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../constants/constant.dart';
import '../../pages/user/package_detail_page.dart';
import '../../providers/package_fare_calculation_provider.dart';
import '../../models/package_model.dart';
import '../../models/leg_model.dart';
import '../../models/location_model.dart';
import '../../providers/package_provider.dart';
import '../../widgets/custom_modal_dialogue.dart';

class PackageConfirmationPage extends ConsumerStatefulWidget {
  final PackageCreate package;

  const PackageConfirmationPage({
    Key? key,
    required this.package,
  }) : super(key: key);

  @override
  _PackageConfirmationPageState createState() =>
      _PackageConfirmationPageState();
}

class _PackageConfirmationPageState
    extends ConsumerState<PackageConfirmationPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(packageFareCalculationProvider.notifier).calculatePackageFare(
            widget.package.totalDistance.toDouble(),
            widget.package,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: AppBar(
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.angleLeft,
            color: Colors.black,
            size: 20.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Package Summary',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(.3),
            height: 1.0,
          ),
        ),
      ),
      body: Stack(
        children: [
          _buildScrollableContent(widget.package),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomBar(widget.package),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableContent(PackageCreate package) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 80.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            package.packageName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              _buildPackageInfo(package.packageType),
              SizedBox(width: 5),
              _buildPackageInfo(package.visibility),
            ],
          ),
          SizedBox(height: 20),
          _buildSection('Description', [
            Text(package.description),
          ]),
          SizedBox(height: 20),
          _buildSection(
              'Locations',
              [
                _buildLocationStartInfo(package.startLocation),
                Padding(
                  padding: const EdgeInsets.only(left: 6, top: 4, bottom: 8),
                  child: Dash(
                    direction: Axis.vertical,
                    length: 35,
                    dashLength: 2,
                    dashColor: Colors.black.withOpacity(.5),
                    dashGap: 5,
                    dashThickness: 2,
                  ),
                ),
                _buildLocationEndInfo(package.finalDestination),
              ],
              totalDistance: '${package.totalDistance.toStringAsFixed(2)}km'),
          SizedBox(height: 20),
          _buildSection('Itinerary', [_buildItineraryList(package)]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children,
      {String? totalDistance}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
                Text(title,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            if (totalDistance != null)
              Text(
                'Total distance: $totalDistance',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        SizedBox(height: 10),
        ...children,
      ],
    );
  }

  Widget _buildLegInfo(LegCreate leg) {
    return Column(
      children: [
        _locationPoint(
          name: leg.startLocation.name,
          address: leg.startLocation.address ?? 'No address',
          isMiniStop: true,
          iconData: FontAwesomeIcons.solidCircleDot,
          iconColor: Color(ColorConstants.PRIMARY_COLOR),
          iconSize: 15.0,
          index: leg.legNumber,
        ),
        _verticalDashLines(),
        _locationPoint(
          name: leg.endLocation.name,
          address: leg.endLocation.address ?? 'No address',
          isMiniStop: true,
          iconData: FontAwesomeIcons.solidCircleDot,
          iconColor: Color(ColorConstants.PRIMARY_COLOR),
          iconSize: 15.0,
          index: leg.legNumber + 1,
        ),
      ],
    );
  }

  Widget _locationPoint({
    required String name,
    required String address,
    required IconData iconData,
    required Color iconColor,
    required double iconSize,
    required bool isMiniStop,
    required int index,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isMiniStop ? 30.0 : 40.0,
            height: isMiniStop ? 30.0 : 40.0,
            decoration: BoxDecoration(
              color: isMiniStop
                  ? const Color(ColorConstants.PRIMARY_COLOR)
                  : (index == 0
                      ? const Color(ColorConstants.PRIMARY_COLOR)
                      : Colors.red),
              shape: BoxShape.circle,
              border: Border.all(
                color: isMiniStop
                    ? Colors.white
                    : (index == 0
                        ? const Color(0xFFB38428)
                        : Colors.red.shade900),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: isMiniStop
                  ? Text(
                      '$index',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    )
                  : const FaIcon(
                      FontAwesomeIcons.locationDot,
                      color: Colors.white,
                      size: 16,
                    ),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.trim().isNotEmpty ? name : address,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isMiniStop ? null : FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  name.trim().isNotEmpty ? address : '',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDashLines() {
    return Row(
      children: [
        Container(
          width: 23,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24.0, left: 8.0),
            child: Dash(
              direction: Axis.vertical,
              length: 15,
              dashLength: 5,
              dashColor: Colors.black.withOpacity(.5),
              dashGap: 5,
              dashThickness: 2,
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  Widget _buildItineraryList(PackageCreate package) {
    List<Widget> itineraryWidgets = [];

    itineraryWidgets.add(
      _locationPoint(
        name: package.startLocation.name,
        address: package.startLocation.address ?? 'No address',
        isMiniStop: false,
        iconData: FontAwesomeIcons.solidCircleDot,
        iconColor: const Color(0xFFFB0000),
        iconSize: 25.0,
        index: 0,
      ),
    );

    itineraryWidgets.add(_verticalDashLines());

    if (package.legs.length == 1) {
      itineraryWidgets.add(
        _locationPoint(
          name: package.finalDestination.name,
          address: package.finalDestination.address ?? 'No address',
          isMiniStop: false,
          iconData: FontAwesomeIcons.locationDot,
          iconColor: Colors.black,
          iconSize: 28.0,
          index: 1,
        ),
      );
      return Column(children: itineraryWidgets);
    }

    for (int i = 0; i < package.legs.length - 1; i++) {
      itineraryWidgets.add(
        _locationPoint(
          name: package.legs[i].endLocation.name,
          address: package.legs[i].endLocation.address ?? 'No address',
          isMiniStop: true,
          iconData: FontAwesomeIcons.solidCircleDot,
          iconColor: const Color(ColorConstants.PRIMARY_COLOR),
          iconSize: 15.0,
          index: i + 1,
        ),
      );
      itineraryWidgets.add(_verticalDashLines());
    }

    itineraryWidgets.add(
      _locationPoint(
        name: package.finalDestination.name,
        address: package.finalDestination.address ?? 'No address',
        isMiniStop: false,
        iconData: FontAwesomeIcons.locationDot,
        iconColor: Colors.black,
        iconSize: 28.0,
        index: package.legs.length + 1,
      ),
    );

    return Column(children: itineraryWidgets);
  }

  Widget _buildLocationStartInfo(LocationCreate location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.solidCircleDot,
              size: 16.0,
              color: Color(0xFFFB0000),
            ),
            SizedBox(width: 15),
            Text(
              location.name.trim().isNotEmpty
                  ? location.name
                  : location.address ?? 'No address',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        if (location.name.trim().isNotEmpty &&
            location.address!.isNotEmpty) ...[
          SizedBox(width: 15),
          Padding(
            padding: const EdgeInsets.only(left: 31),
            child: Text(
              location.address ?? 'No address',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLocationEndInfo(LocationCreate location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.locationDot,
              size: 19.0,
              color: Colors.black,
            ),
            SizedBox(width: 15),
            Text(
              location.name.trim().isNotEmpty
                  ? location.name
                  : location.address ?? 'No address',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        if (location.name.trim().isNotEmpty &&
            location.address!.isNotEmpty) ...[
          SizedBox(width: 15),
          Padding(
            padding: const EdgeInsets.only(left: 31),
            child: Text(
              location.address ?? 'No address',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPackageInfo(String info) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.2),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Text(
            info,
            style: TextStyle(
              color: Colors.black.withOpacity(.4),
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(PackageCreate package) {
    return Container(
      height: 75.0,
      decoration: BoxDecoration(
        color: Color(ColorConstants.BACKGROUND_COLOR),
        border: Border(
          top: BorderSide(
            color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(.3),
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
              Row(
                children: [
                  Text(
                    "Package fare:",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      _showFareInfoDialog(context);
                    },
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black.withOpacity(.5),
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.info,
                          color: Colors.black.withOpacity(.5),
                          size: 6.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Consumer(
                builder: (context, ref, child) {
                  final fareState = ref.watch(packageFareCalculationProvider);

                  if (fareState.isLoading) {
                    return Shimmer.fromColors(
                      baseColor:
                          Color(ColorConstants.SECONDARY_COLOR).withOpacity(.3),
                      highlightColor: Color(ColorConstants.BACKGROUND_COLOR)
                          .withOpacity(.3),
                      child: Container(
                        width: 120,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }

                  if (fareState.error != null) {
                    return Text(
                      'Error calculating fare',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    );
                  }

                  return Text(
                    '₱${fareState.calculatedPackageFare?.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  );
                },
              )
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            onPressed: () {
              final fareState = ref.read(packageFareCalculationProvider);
              if (fareState.updatedPackage != null) {
                _createPackage(fareState.updatedPackage!);
              }
            },
            child: Text(
              'Create Package',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFareInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomModalDialog(
          title: 'Package Fare Information',
          content:
              'The package fare includes transportation costs and may increase based on the number of vans, the trip\'s distance, and other factors.',
          onConfirm: () {},
          color: Color(ColorConstants.PRIMARY_COLOR),
        );
      },
    );
  }

  void _createPackage(PackageCreate package) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(ColorConstants.PRIMARY_COLOR),
            ),
          );
        },
      );

      await ref.read(packageProvider.notifier).createPackage(package);

      final packageState = ref.read(packageProvider);

      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (packageState.error != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create package: ${packageState.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      if (mounted && packageState.selectedPackage != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PackageDetailPage(
              packageId: packageState.selectedPackage!.id,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create package: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
