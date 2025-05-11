import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/pages/user/payment_booking_page.dart';
import 'package:tripnitor_mobile_app/widgets/custom_modal_dialogue.dart';
import 'package:intl/intl.dart';
import '../core/constants/constant.dart';
import '../models/package_model.dart';
import '../models/preview_boking_model.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../services/booking_service.dart';
import '../services/token_service.dart';

class BookingBottomSheet extends ConsumerStatefulWidget {
  final Package package;

  const BookingBottomSheet({Key? key, required this.package}) : super(key: key);

  @override
  ConsumerState<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends ConsumerState<BookingBottomSheet> {
  DateTime? startDateTime;
  DateTime? endDateTime;
  int passengers = 1;

  @override
  void initState() {
    super.initState();
    if (widget.package.visibility.toUpperCase() == "JOINER") {
      startDateTime = widget.package.startDate;
      endDateTime = widget.package.endDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isJoiner = widget.package.visibility.toUpperCase() == "JOINER";
    final int? maxParticipants = widget.package.maxParticipants;
    final int currentParticipants = widget.package.currentParticipants ?? 0;

    final int remainingSlots = isJoiner && maxParticipants != null
        ? maxParticipants - currentParticipants
        : 0;

    return DraggableScrollableSheet(
      initialChildSize: .95,
      minChildSize: 0.3,
      maxChildSize: .95,
      snap: true,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Color(ColorConstants.BACKGROUND_COLOR),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(ColorConstants.BACKGROUND_COLOR),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    isJoiner ? 'Join Package' : 'Booking Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: true,
                ),
              ),
              Divider(
                color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(.3),
                thickness: 1,
                height: 1,
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: EdgeInsets.all(16),
                  children: [
                    _buildSection(
                        'Package',
                        [
                          Text(widget.package.packageName,
                              style: TextStyle(fontSize: 16)),
                        ],
                        showColorBar: true),
                    SizedBox(height: 24),
                    if (isJoiner) ...[
                      _buildShadowedContainer([
                        _buildSection('Trip Schedule', [
                          _buildFixedDateInfo(
                              widget.package.startDate, widget.package.endDate),
                          if (maxParticipants != null) ...[
                            SizedBox(height: 12),
                            _buildJoinerParticipantsInfo(
                                currentParticipants, maxParticipants),
                          ],
                        ]),
                      ]),
                    ] else ...[
                      _buildShadowedContainer([
                        _buildSection('Start Date and Time', [
                          _buildDateTimeRow(startDateTime, (dateTime) {
                            setState(() => startDateTime = dateTime);
                          }),
                        ]),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Divider(
                            color: Color(ColorConstants.PRIMARY_COLOR)
                                .withOpacity(.3),
                            thickness: 1,
                            height: 1,
                          ),
                        ),
                        _buildSection('End Date and Time', [
                          _buildDateTimeRow(endDateTime, (dateTime) {
                            setState(() => endDateTime = dateTime);
                          }),
                        ]),
                      ]),
                    ],
                    SizedBox(height: 24),
                    _buildShadowedContainer([
                      Column(
                        children: [
                          Text(isJoiner
                              ? 'Joiner tour packages hold a maximum of 15 passengers'
                              : 'A van holds up to 15 passengers. If you have more, additional vans will be provided.'),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Divider(
                              color: Color(ColorConstants.PRIMARY_COLOR)
                                  .withOpacity(.3),
                              thickness: 1,
                              height: 1,
                            ),
                          ),
                          _buildPassengerSelector(isJoiner, remainingSlots),
                        ],
                      ),
                    ]),
                    SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (startDateTime != null && endDateTime != null) {
                          try {
                            final bookingService = BookingService();

                            final hasConflict =
                                await bookingService.hasDateConflict(
                              startDate: startDateTime!,
                              endDate: endDateTime!,
                            );

                            if (hasConflict) {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomModalDialog(
                                    title: 'Booking Conflict',
                                    content:
                                        'You already have a booking that conflicts with these dates. Please select different dates.',
                                    onConfirm: () {},
                                    color: Color(ColorConstants.ERROR_COLOR),
                                    buttonText: 'OK',
                                  );
                                },
                              );
                              return;
                            }
                          } catch (error) {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return CustomModalDialog(
                                  title: 'Date Check Error',
                                  content:
                                      'Unable to check date availability: ${error.toString()}',
                                  onConfirm: () {},
                                  color: Color(ColorConstants.ERROR_COLOR),
                                  buttonText: 'OK',
                                );
                              },
                            );
                            return;
                          }

                          final previewRequest = PreviewBookingRequest(
                            package: widget.package.id,
                            startDate: startDateTime!,
                            endDate: endDateTime!,
                            numberOfPassengers: passengers,
                            assignedDriver: widget.package.assignedDriver?.id,
                          );

                          final userId = await tokenService.getUserId();
                          if (userId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('User details failed')),
                            );
                            return;
                          }
                          final userDetailsFuture = ref
                              .read(authProvider.notifier)
                              .getUserDetails(userId);
                          final previewBookingFuture = ref
                              .read(bookingStateProvider.notifier)
                              .previewBooking(previewRequest);

                          try {
                            await Future.wait(
                                [userDetailsFuture, previewBookingFuture]);

                            final bookingState = ref.read(bookingStateProvider);
                            final assignedDrivers =
                                bookingState.previewBooking?.assignedDrivers ??
                                    [];
                            final requiredDrivers =
                                isJoiner ? 1 : (passengers + 14) ~/ 15;

                            if (assignedDrivers.length < requiredDrivers) {
                              throw 'Our drivers are busy. Please adjust booking date or number of passengers.';
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentBookingPage(
                                    packageId: widget.package.id),
                              ),
                            );
                          } catch (error) {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return CustomModalDialog(
                                  title: 'Booking Error!',
                                  content: error.toString(),
                                  onConfirm: () {},
                                  color: Color(ColorConstants.ERROR_COLOR),
                                  buttonText: 'OK',
                                );
                              },
                            );
                          }
                        } else {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return CustomModalDialog(
                                title: 'Booking Error!',
                                content:
                                    'Please select both start and end dates.',
                                onConfirm: () {},
                                color: Color(ColorConstants.ERROR_COLOR),
                                buttonText: 'OK',
                              );
                            },
                          );
                        }
                      },
                      child: Text(
                        isJoiner ? 'Join now' : 'Book now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFixedDateInfo(DateTime? startDate, DateTime? endDate) {
    final DateFormat dateFormat = DateFormat('d MMM yyyy, h:mm a');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: Color(ColorConstants.ACCENT_COLOR),
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              'Start:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 26.0),
          child: Text(
            startDate != null ? dateFormat.format(startDate) : 'Not specified',
            style: TextStyle(fontSize: 14),
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: Color(ColorConstants.ACCENT_COLOR),
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              'End:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 26.0),
          child: Text(
            endDate != null ? dateFormat.format(endDate) : 'Not specified',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildJoinerParticipantsInfo(
      int currentParticipants, int maxParticipants) {
    final int remainingSlots = maxParticipants - currentParticipants;

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.people,
                color: Color(ColorConstants.PRIMARY_COLOR),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Current passengers:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            '$currentParticipants/$maxParticipants',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: remainingSlots < 3
                  ? Colors.red
                  : Color(ColorConstants.PRIMARY_COLOR),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShadowedContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildDateTimeRow(DateTime? dateTime, Function(DateTime) onPick) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          dateTime != null ? '${dateTime.toLocal()}'.split('.')[0] : 'Not set',
          style: TextStyle(fontSize: 14),
        ),
        IconButton(
          icon: Icon(Icons.calendar_today,
              color: Color(ColorConstants.ACCENT_COLOR)),
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: dateTime ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 365)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Color(ColorConstants.PRIMARY_COLOR),
                      onPrimary: Color(ColorConstants.TERTIARY_COLOR),
                      surface: Color(ColorConstants.BACKGROUND_COLOR),
                      onSurface:
                          Color(ColorConstants.BOTTOM_PACKAGE_CARD_COLOR),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Color(ColorConstants.PRIMARY_COLOR),
                        onPrimary: Color(ColorConstants.TERTIARY_COLOR),
                        surface: Color(ColorConstants.BACKGROUND_COLOR),
                        onSurface:
                            Color(ColorConstants.BOTTOM_PACKAGE_CARD_COLOR),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (time != null) {
                onPick(DateTime(
                    date.year, date.month, date.day, time.hour, time.minute));
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildPassengerSelector(bool isJoiner, int remainingSlots) {
    final int maxAllowedPassengers = isJoiner ? remainingSlots : 999;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Passengers',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            if (isJoiner)
              Text(
                'Remaining slots: $remainingSlots',
                style: TextStyle(
                  fontSize: 12,
                  color: remainingSlots < 3 ? Colors.red : Colors.grey[600],
                  fontWeight:
                      remainingSlots < 3 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed:
                  passengers > 1 ? () => setState(() => passengers--) : null,
            ),
            Text(
              '$passengers',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: passengers < maxAllowedPassengers
                  ? () => setState(() => passengers++)
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children,
      {bool showColorBar = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (showColorBar)
                  Container(
                    decoration: BoxDecoration(
                      color: Color(ColorConstants.PRIMARY_COLOR),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    height: 20,
                    width: 5,
                  ),
                if (showColorBar) SizedBox(width: 10),
                Text(title,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        ...children,
      ],
    );
  }
}
