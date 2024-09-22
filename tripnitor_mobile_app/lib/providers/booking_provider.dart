import 'package:riverpod/riverpod.dart';
import '../models/booking_model.dart';
import '../models/preview_boking_model.dart';
import '../services/booking_service.dart';

class BookingStateNotifier extends StateNotifier<BookingState> {
  final BookingService _bookingService;

  BookingStateNotifier(this._bookingService) : super(BookingState());

  Future<void> previewBooking(PreviewBookingRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final preview = await _bookingService.previewBooking(request);
      state = state.copyWith(
        isLoading: false,
        previewBooking: preview.bookingPreview,
        status: preview.status,
        message: preview.message,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createBooking(BookingCreationRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final createdBooking = await _bookingService.createBooking(request);
      state = state.copyWith(
        booking: createdBooking,
        isLoading: false,
        status: 201,
        message: "Booking created successfully",
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create booking: $e',
      );
    }
  }

  Future<void> getUserBookings(String status) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final userBookingsData = await _bookingService.getUserBookings(status);
      state = state.copyWith(
        isLoading: false,
        bookingList: userBookingsData,
        status: 200,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getAllBookings() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final bookingList = await _bookingService.getAllBookings();
      state = state.copyWith(
        isLoading: false,
        bookingList: bookingList,
        status: 200,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load list of bookings: $e',
      );
    }
  }

  Future<void> getBookingDetails(String bookingId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final bookingDetail = await _bookingService.getBookingDetails(bookingId);
      state = state.copyWith(
        isLoading: false,
        booking: bookingDetail,
        status: 200,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final bookingServiceProvider = Provider<BookingService>((ref) {
  return BookingService();
});

final bookingStateProvider =
    StateNotifierProvider<BookingStateNotifier, BookingState>((ref) {
  final bookingService = ref.watch(bookingServiceProvider);
  return BookingStateNotifier(bookingService);
});
