import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/pages/user/payment_booking_page.dart';
import 'package:tripnitor_mobile_app/widgets/custom_modal_dialogue.dart';
import '../core/constants/constant.dart';
import '../models/package_model.dart';
import '../models/preview_boking_model.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
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
  Widget build(BuildContext context) {
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
                    'Booking Details',
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
                    SizedBox(height: 24),
                    _buildShadowedContainer([
                      Column(
                        children: [
                          Text(
                              'A van holds up to 15 passengers. If you have more, additional vans will be provided.'),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Divider(
                              color: Color(ColorConstants.PRIMARY_COLOR)
                                  .withOpacity(.3),
                              thickness: 1,
                              height: 1,
                            ),
                          ),
                          _buildPassengerSelector(),
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
                          final previewRequest = PreviewBookingRequest(
                            package: widget.package.id,
                            startDate: startDateTime!,
                            endDate: endDateTime!,
                            numberOfPassengers: passengers,
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
                            final requiredDrivers = (passengers + 14) ~/ 15;

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
                        'Book now',
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

  Widget _buildPassengerSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Passengers',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              onPressed: () => setState(() => passengers++),
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
