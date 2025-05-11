import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/providers/booking_leg_provider.dart';
import 'package:tripnitor_mobile_app/providers/booking_provider.dart';
import '../../core/constants/constant.dart';
import '../custom_modal_dialogue.dart';

class DriverBookingBottomAction extends ConsumerWidget {
  final String bookingId;

  const DriverBookingBottomAction({
    Key? key,
    required this.bookingId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingStateProvider);
    final booking = bookingState.booking!;

    if (booking.status == "COMPLETED") {
      return SizedBox.shrink();
    }

    final locations = booking.bookingLeg;
    bool hasActiveItinerary = locations.any((leg) => leg.isActive);
    int activeIndex = locations.indexWhere((leg) => leg.isActive);
    bool isLastItinerary =
        activeIndex == locations.length - 1 && hasActiveItinerary;

    bool isOngoing = booking.status == "ONGOING";

    return Container(
      decoration: BoxDecoration(
        color: Color(ColorConstants.BACKGROUND_COLOR),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed: isOngoing
              ? () {
                  if (hasActiveItinerary) {
                    _showArrivedModal(
                        context,
                        ref,
                        locations,
                        activeIndex,
                        isLastItinerary,
                        booking.package.visibility == "JOINER");
                  } else {
                    _showStartItineraryModal(context, ref, locations,
                        booking.package.visibility == "JOINER");
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isLastItinerary
                ? Colors.green
                : Color(ColorConstants.PRIMARY_COLOR),
            foregroundColor: Colors.white,
            disabledBackgroundColor: Color(ColorConstants.DISABLED_COLOR),
            disabledForegroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            hasActiveItinerary
                ? (isLastItinerary
                    ? 'Confirm Arrival and Complete Booking'
                    : 'Arrived')
                : 'Start Itinerary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _showStartItineraryModal(BuildContext context, WidgetRef ref,
      List<dynamic> locations, bool isJoinerPackage) {
    int nextIndex = locations.indexWhere((leg) => !leg.isCompleted);
    final nextBookingLegId = nextIndex >= 0 ? locations[nextIndex].id : null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomModalDialog(
          title: "Start Itinerary",
          content: isJoinerPackage
              ? "Are you ready to begin your journey? This will mark the itinerary as active.\n\nNote: Starting this JOINER booking will also start other bookings related to it."
              : "Are you ready to begin your journey? This will mark the itinerary as active.",
          buttonText: "Start",
          color: Color(ColorConstants.PRIMARY_COLOR),
          onConfirm: () async {
            if (nextBookingLegId != null) {
              await ref
                  .read(bookingLegStateProvider.notifier)
                  .activateBookingLeg(nextBookingLegId);
            }
          },
        );
      },
    );
  }

  void _showArrivedModal(
      BuildContext context,
      WidgetRef ref,
      List<dynamic> locations,
      int activeIndex,
      bool isLastItinerary,
      bool isJoinerPackage) {
    final activeBookingLegId =
        activeIndex >= 0 ? locations[activeIndex].id : null;

    String content;
    if (isLastItinerary) {
      content = isJoinerPackage
          ? "Have you completed your final destination? This will mark your booking as complete.\n\nNote: Completing this JOINER booking will also complete other bookings related to it."
          : "Have you completed your final destination? This will mark your booking as complete.";
    } else {
      content = isJoinerPackage
          ? "Have you arrived at this location? This will ready up the next itinerary.\n\nNote: Updating this JOINER booking will also update other bookings related to it."
          : "Have you arrived at this location? This will ready up the next itinerary.";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomModalDialog(
          title: "Confirm Arrival",
          content: content,
          buttonText: isLastItinerary ? "Complete Booking" : "Confirm",
          color: isLastItinerary
              ? Colors.green
              : Color(ColorConstants.PRIMARY_COLOR),
          onConfirm: () async {
            if (activeBookingLegId != null) {
              await ref
                  .read(bookingLegStateProvider.notifier)
                  .completeBookingLeg(activeBookingLegId);
            }
          },
        );
      },
    );
  }
}
