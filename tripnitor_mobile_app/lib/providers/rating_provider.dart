import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/models/rating_model.dart';

import '../services/rating_service.dart';

class RatingStateNotifier extends StateNotifier<RatingState> {
  RatingService _ratingService;

  RatingStateNotifier(this._ratingService) : super(RatingState());

  Future<Rating> submitRating(
      String bookingId, String userId, int rating, String? comment) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final submittedRating =
          await _ratingService.submitRating(bookingId, userId, rating, comment);
      state = state.copyWith(
        isLoading: false,
        rating: submittedRating,
        error: null,
        message: 'Rating submitted successfully',
      );
      return submittedRating;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to submit rating: $e',
      );
      rethrow;
    }
  }
}

final ratingServiceProvider = Provider<RatingService>((ref) {
  return RatingService();
});

final ratingStateProvider =
    StateNotifierProvider<RatingStateNotifier, RatingState>((ref) {
  final ratingService = ref.watch(ratingServiceProvider);
  return RatingStateNotifier(ratingService);
});
