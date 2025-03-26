import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/services/booking_leg_service.dart';
import '../models/booking_leg_model.dart';
import '../models/booking_model.dart';
import 'booking_provider.dart';

class BookingLegStateNotifier extends StateNotifier<BookingLegState> {
  BookingLegService _bookingLegService;
  final Ref _ref;

  BookingLegStateNotifier(this._bookingLegService, this._ref)
      : super(BookingLegState());

  Future<void> activateBookingLeg(int bookingLegId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedLeg =
          await _bookingLegService.activateBookingLeg(bookingLegId);
      state = state.copyWith(
          isLoading: false,
          bookingLeg: updatedLeg,
          error: null,
          message: 'Booking leg set to active successfully.');

      _updateBookingWithUpdatedLeg(bookingLegId, updatedLeg);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to set booking leg to active: $e',
      );
    }
  }

  Future<void> completeBookingLeg(int bookingLegId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedLeg =
          await _bookingLegService.completeBookingLeg(bookingLegId);
      state = state.copyWith(
          isLoading: false,
          bookingLeg: updatedLeg,
          error: null,
          message: 'Booking leg set to complete successfully.');

      _updateBookingWithUpdatedLeg(bookingLegId, updatedLeg);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to set booking leg to complete: $e',
      );
    }
  }

  void _updateBookingWithUpdatedLeg(int bookingLegId, BookingLeg updatedLeg) {
    final bookingState = _ref.read(bookingStateProvider);
    if (bookingState.booking != null) {
      final currentBooking = bookingState.booking!;

      final updatedBookingLegs = currentBooking.bookingLeg.map((leg) {
        if (leg.id == bookingLegId) {
          return updatedLeg;
        }
        return leg;
      }).toList();

      final updatedBooking = Booking(
        id: currentBooking.id,
        user: currentBooking.user,
        package: currentBooking.package,
        bookingLeg: updatedBookingLegs,
        startLocation: currentBooking.startLocation,
        finalDestination: currentBooking.finalDestination,
        drivers: currentBooking.drivers,
        status: currentBooking.status,
        baseFare: currentBooking.baseFare,
        updatedPackageFare: currentBooking.updatedPackageFare,
        numberOfNights: currentBooking.numberOfNights,
        totalPrice: currentBooking.totalPrice,
        numberOfPassengers: currentBooking.numberOfPassengers,
        modeOfPayment: currentBooking.modeOfPayment,
        createdAt: currentBooking.createdAt,
        updatedAt: currentBooking.updatedAt,
        startDate: currentBooking.startDate,
        endDate: currentBooking.endDate,
      );

      _ref.read(bookingStateProvider.notifier).updateBooking(updatedBooking);
    }
  }

  void clearState() {
    state = BookingLegState();
  }
}

final bookingLegServiceProvider = Provider<BookingLegService>((ref) {
  return BookingLegService();
});

final bookingLegStateProvider =
    StateNotifierProvider<BookingLegStateNotifier, BookingLegState>((ref) {
  final bookingLegService = ref.watch(bookingLegServiceProvider);
  return BookingLegStateNotifier(bookingLegService, ref);
});
