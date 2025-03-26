import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/providers/booking_leg_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/constant.dart';
import '../../models/auth_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import 'package:intl/intl.dart';
import '../../services/url_launcher_service.dart';
import '../custom_modal_dialogue.dart';
import 'booking_bottom_action.dart';
import 'driver_booking_bottom_action.dart';
import '../../providers/admin_provider.dart';

class BookingItineraryPage extends ConsumerStatefulWidget {
  final String bookingId;
  const BookingItineraryPage({super.key, required this.bookingId});

  @override
  ConsumerState<BookingItineraryPage> createState() =>
      _BookingItineraryPageState();
}

class _BookingItineraryPageState extends ConsumerState<BookingItineraryPage> {
  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingStateProvider);
    final authState = ref.watch(authProvider);
    final userRole = authState.user?.role;

    if (bookingState.isLoading) {
      return Scaffold(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 1),
          child: AppBar(
            title: Text(
              'Booking Itinerary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
            scrolledUnderElevation: 0,
            actions: [
              Container(
                margin: EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                  color: Color(ColorConstants.DISABLED_COLOR),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.headset,
                    color: Colors.grey[500],
                    size: 20.0,
                  ),
                  tooltip: 'Contact Admin',
                  onPressed: null,
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1.0),
              child: Divider(
                color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(.3),
                thickness: 1,
                height: 1,
              ),
            ),
            leading: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.angleLeft,
                color: Colors.black,
                size: 20.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(ColorConstants.PRIMARY_COLOR),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: Text(
            'Booking Itinerary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
          scrolledUnderElevation: 0,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                color: bookingState.booking?.status == "ONGOING"
                    ? Colors.red[100]
                    : Color(ColorConstants.DISABLED_COLOR),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.headset,
                  color: bookingState.booking?.status == "ONGOING"
                      ? Colors.red[700]
                      : Colors.white,
                  size: 20.0,
                ),
                tooltip: 'Contact Admin',
                onPressed: bookingState.booking?.status == "ONGOING"
                    ? () {
                        _showContactAdminDialog();
                      }
                    : null,
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Divider(
              color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(.3),
              thickness: 1,
              height: 1,
            ),
          ),
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.black,
              size: 20.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(bookingStateProvider.notifier)
                    .getBookingDetails(widget.bookingId);
              },
              child: _buildUI(context),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomButtonByRole(userRole!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtonByRole(String userRole) {
    if (userRole == "DRIVER") {
      return DriverBookingBottomAction(
        bookingId: widget.bookingId,
      );
    } else {
      return BookingBottomAction();
    }
  }

  Widget _buildUI(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _itineraryList(context),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _itineraryList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24.0,
        top: 24,
        right: 24,
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 16,
          ),
          _buildItineraryCards(context),
        ],
      ),
    );
  }

  Widget _buildItineraryCards(BuildContext context) {
    final bookingState = ref.watch(bookingStateProvider);
    final locations = bookingState.booking!.bookingLeg;

    if (locations.isEmpty) {
      return Center(child: Text("No itinerary available"));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: locations.length,
      itemBuilder: (context, index) {
        final itinerary = locations[index];
        final bool isAfterCompleted =
            index > 0 && locations[index - 1].isCompleted;

        String? formatDate(DateTime? dateTime) {
          if (dateTime == null) return null;
          return DateFormat('MMMM d, yyyy').format(dateTime);
        }

        String? formatTime(DateTime? dateTime) {
          if (dateTime == null) return null;
          return DateFormat('h:mm a').format(dateTime);
        }

        BoxDecoration getCardDecoration() {
          Color borderColor = Colors.transparent;
          double borderWidth = 0;

          if (itinerary.isActive) {
            borderColor = Color(ColorConstants.PRIMARY_COLOR);
            borderWidth = 2.0;
          } else if (isAfterCompleted && !itinerary.isCompleted) {
            borderColor = Color(ColorConstants.PRIMARY_COLOR);
            borderWidth = 2.0;
          }

          return BoxDecoration(
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
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            decoration: getCardDecoration(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Itinerary ${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      Spacer(),
                      if (itinerary.isActive)
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(ColorConstants.PRIMARY_COLOR),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'ACTIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else if (isAfterCompleted && !itinerary.isCompleted)
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(ColorConstants.PRIMARY_COLOR),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'UP NEXT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else if (itinerary.isCompleted)
                        Row(
                          children: const [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'COMPLETED',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Color(ColorConstants.PRIMARY_COLOR)
                              .withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itinerary.startLocation.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                if (itinerary.departureTime != null) ...[
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 14,
                                    color: Color(ColorConstants.PRIMARY_COLOR),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    formatTime(itinerary.localDepartureTime)!
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color:
                                          Color(ColorConstants.PRIMARY_COLOR),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                ],
                                if (itinerary.departureTime != null) ...[
                                  Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    formatDate(itinerary.localDepartureTime)!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Container(
                      height: 40,
                      child: Column(
                        children: [
                          Expanded(
                            child: VerticalDivider(
                              color: Colors.grey[350],
                              thickness: 1,
                              width: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Color(ColorConstants.PRIMARY_COLOR)
                              .withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itinerary.endLocation.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                if (itinerary.arrivalTime != null) ...[
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 14,
                                    color: Color(ColorConstants.PRIMARY_COLOR),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    formatTime(itinerary.localArrivalTime)!
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color:
                                          Color(ColorConstants.PRIMARY_COLOR),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                ],
                                if (itinerary.arrivalTime != null) ...[
                                  Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    formatDate(itinerary.localArrivalTime)!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (itinerary.departureTime != null &&
                      itinerary.arrivalTime != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timelapse,
                              size: 16,
                              color: Colors.grey[700],
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Duration: ${_getDuration(itinerary.departureTime!, itinerary.arrivalTime!)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getDuration(DateTime departure, DateTime arrival) {
    final duration = arrival.difference(departure);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return '$hours h ${minutes > 0 ? '$minutes min' : ''}';
    } else {
      return '$minutes min';
    }
  }

  void _showContactAdminDialog() async {
    await ref.read(adminDetailsProvider.notifier).fetchAdminDetails();

    final adminState = ref.read(adminDetailsProvider);
    final user = adminState.user;

    String phoneNumber = user?.phoneNumber ?? '+63 9178299481';
    String emailAddress = user?.email ?? 'support@tripnitor.com';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact Admin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.envelope,
                  color: Color(ColorConstants.PRIMARY_COLOR),
                ),
                title: Text('Email'),
                subtitle: Text(emailAddress),
                onTap: () {
                  Navigator.pop(context);

                  UrlLauncherService.launchEmail(
                    emailAddress,
                    subject: 'Support Request for Booking ${widget.bookingId}',
                  );
                },
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.phone,
                  color: Color(ColorConstants.PRIMARY_COLOR),
                ),
                title: Text('Call'),
                subtitle: Text(phoneNumber),
                onTap: () {
                  Navigator.pop(context);
                  _showPhoneContactOptions(phoneNumber);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(
                  color: Color(ColorConstants.PRIMARY_COLOR),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPhoneContactOptions(String phoneNumber) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Contact via Phone',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.phone,
                      color: Color(ColorConstants.PRIMARY_COLOR),
                      size: 20,
                    ),
                  ),
                  title: Text('Make a call'),
                  subtitle: Text('Speak directly with admin'),
                  onTap: () {
                    Navigator.pop(context);
                    UrlLauncherService.makePhoneCall(phoneNumber);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.commentSms,
                      color: Color(ColorConstants.PRIMARY_COLOR),
                      size: 20,
                    ),
                  ),
                  title: Text('Send SMS'),
                  subtitle: Text('Message the admin'),
                  onTap: () {
                    Navigator.pop(context);
                    UrlLauncherService.sendSMS(phoneNumber);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
