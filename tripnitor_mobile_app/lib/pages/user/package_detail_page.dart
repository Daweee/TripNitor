import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tripnitor_mobile_app/providers/booking_provider.dart';
import 'package:tripnitor_mobile_app/widgets/joiner_package_users_list.dart';
import '../../core/constants/constant.dart';
import '../../helpers/location_transformation_help.dart';
import '../../models/driver_model.dart';
import '../../providers/package_provider.dart';
import '../../models/package_model.dart';
import '../../models/leg_model.dart';
import '../../models/location_model.dart';
import '../../widgets/booking_bottom_sheet.dart';
import '../../widgets/custom_modal_dialogue.dart';
import '../../widgets/package_creation_widgets/package_start_final_location.dart';
import '../../widgets/shimmer_package_detail_page.dart';

class PackageDetailPage extends ConsumerStatefulWidget {
  final String packageId;

  const PackageDetailPage({Key? key, required this.packageId})
      : super(key: key);

  @override
  _PackageDetailPageState createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends ConsumerState<PackageDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref
          .read(packageProvider.notifier)
          .getPackageDetails(widget.packageId);

      final packageState = ref.read(packageProvider);
      final package = packageState.selectedPackage;

      if (package != null &&
          package.visibility.toUpperCase() == "JOINER" &&
          (packageState.packageJoiners == null ||
              packageState.packageJoiners!.isEmpty) &&
          !packageState.isLoadingJoiners) {
        ref.read(packageProvider.notifier).getJoinerUsers(widget.packageId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final packageState = ref.watch(packageProvider);

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: AppBar(
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.angleLeft,
            color: Colors.black,
            size: 20.0,
          ),
          onPressed: () {
            ref.read(packageProvider.notifier).clearPackageJoiners();
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Package Details',
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
      body: packageState.isLoading
          ? PackageDetailShimmer()
          : Stack(
              children: [
                _buildScrollableContent(packageState),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildBottomBar(packageState),
                ),
              ],
            ),
    );
  }

  Widget _buildScrollableContent(PackageState packageState) {
    if (packageState.isLoading) {
      return PackageDetailShimmer();
    } else if (packageState.selectedPackage == null) {
      return Center(child: Text('No package data available'));
    }

    final package = packageState.selectedPackage!;

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
              if (package.visibility.toUpperCase() == "JOINER" &&
                  package.maxParticipants != null) ...[
                SizedBox(width: 5),
                _buildParticipantsTag(
                    "${package.currentParticipants ?? 0}/${package.maxParticipants}"),
              ],
            ],
          ),
          SizedBox(
            height: 5,
          ),
          if (package.startDate != null && package.endDate != null) ...[
            SizedBox(width: 5),
            _buildDateRangeTag(package.localStartDate!, package.localEndDate!),
          ],
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
              totalDistance: '${package.totalDistance}km'),
          SizedBox(height: 20),
          if (package.visibility.toUpperCase() == "JOINER" &&
              package.assignedDriver != null) ...[
            _buildDriverSection('Assigned Driver', package.assignedDriver!),
            SizedBox(height: 20),
          ],
          _buildItinerarySection(
            'Itinerary',
            [
              for (var leg in package.legs) _buildLegInfo(leg),
            ],
            package,
          ),
          if (package.visibility.toUpperCase() == "JOINER") ...[
            SizedBox(height: 20),
            JoinerPackageUsersList(
              joiners: packageState.packageJoiners ?? [],
              isLoading: packageState.isLoadingJoiners,
            ),
          ],
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

  Widget _buildItinerarySection(
      String title, List<Widget> children, Package package) {
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
            if (package.visibility.toUpperCase() == "PRIVATE")
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PackageStartFinalLocation(
                        packageId: package.id,
                        packageName: package.packageName,
                        packageType: package.packageType,
                        packageDescription: package.description,
                        packageVisibility: package.visibility,
                        isEditing: true,
                        initialStartLocation: LocationTransformations
                            .locationToLocationServiceData(
                                package.startLocation),
                        initialEndLocation: LocationTransformations
                            .locationToLocationServiceData(
                                package.finalDestination),
                        initialLegs: package.legs,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Change',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 10),
        ...children,
      ],
    );
  }

  Widget _buildLocationStartInfo(Location location) {
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
            Expanded(
              child: Text(
                location.name.trim().isNotEmpty
                    ? location.name
                    : location.address ?? 'No address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        if (location.name.trim().isNotEmpty &&
            location.address != null &&
            location.address!.isNotEmpty) ...[
          SizedBox(width: 15),
          Padding(
            padding: const EdgeInsets.only(left: 31),
            child: Text(
              location.address!,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLocationEndInfo(Location location) {
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
            Expanded(
              child: Text(
                location.name.trim().isNotEmpty
                    ? location.name
                    : location.address ?? 'No address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        if (location.name.trim().isNotEmpty &&
            location.address != null &&
            location.address!.isNotEmpty) ...[
          SizedBox(width: 15),
          Padding(
            padding: const EdgeInsets.only(left: 31),
            child: Text(
              location.address!,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildLegInfo(Leg leg) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Itinerary ${leg.legNumber}',
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            _buildLocationStartInfo(leg.startLocation),
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
            _buildLocationEndInfo(leg.endLocation),
          ],
        ),
      ),
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

  Widget _buildParticipantsTag(String participantsInfo) {
    return Container(
      decoration: BoxDecoration(
        color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.15),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.userGroup,
              color: Color(ColorConstants.PRIMARY_COLOR),
              size: 8.0,
            ),
            SizedBox(width: 3),
            Text(
              participantsInfo,
              style: TextStyle(
                color: Color(ColorConstants.PRIMARY_COLOR),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverSection(String title, Driver driver) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            margin: EdgeInsets.only(bottom: 16),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Driver Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${driver.van.model} | ${driver.van.plateNumber}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(.5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _buildDriverInfoRow("Name", driver.user.name),
                  _buildDriverInfoRow("Phone Number", driver.user.phoneNumber)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDriverInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeTag(DateTime startDate, DateTime endDate) {
    final DateFormat dateFormat = DateFormat('d MMM yyyy, h:mm a');
    final String formattedStartDate = dateFormat.format(startDate);
    final String formattedEndDate = dateFormat.format(endDate);

    return Container(
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.15),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.calendar,
              color: Color(ColorConstants.PRIMARY_COLOR),
              size: 8.0,
            ),
            SizedBox(width: 3),
            Text(
              "$formattedStartDate - $formattedEndDate",
              style: TextStyle(
                color: Color(ColorConstants.PRIMARY_COLOR),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(PackageState packageState) {
    final package = packageState.selectedPackage;
    if (package == null) return SizedBox.shrink();

    final bool isFullyBooked = package.visibility.toUpperCase() == "JOINER" &&
        package.maxParticipants != null &&
        package.currentParticipants != null &&
        package.currentParticipants! >= package.maxParticipants!;

    final String buttonText = package.visibility.toUpperCase() == "JOINER"
        ? "Join and book now"
        : "Book now";

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
              Text(
                '₱${package.basePrice ?? ''}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isFullyBooked
                  ? Colors.grey
                  : Color(ColorConstants.PRIMARY_COLOR),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            onPressed: isFullyBooked
                ? null
                : () {
                    _showBookingBottomSheet(context, package);
                  },
            child: Text(
              buttonText,
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

  void _showBookingBottomSheet(BuildContext context, Package? package) {
    if (package == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BookingBottomSheet(package: package);
      },
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
}
