class Rating {
  final int id;
  final String booking;
  final String user;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  Rating({
    required this.id,
    required this.booking,
    required this.user,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  DateTime? get localCreatedAt => createdAt.toLocal();
  DateTime? get localUpdatedAt => updatedAt.toLocal();

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json["id"],
      booking: json["booking"],
      user: json["user"],
      rating: json["rating"],
      comment: json["comment"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }
}

class RatingCreate {
  final String booking;
  final String user;
  final int rating;
  final String? comment;

  RatingCreate({
    required this.booking,
    required this.user,
    required this.rating,
    this.comment,
  });

  factory RatingCreate.fromJson(Map<String, dynamic> json) {
    return RatingCreate(
      booking: json["booking"],
      user: json["user"],
      rating: json["rating"],
      comment: json["comment"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "booking": booking,
      "user": user,
      "rating": rating,
      if (comment != null) "comment": comment,
    };
  }
}

class RatingState {
  final bool isLoading;
  final Rating? rating;
  final String? error;
  final String? message;

  RatingState({
    this.isLoading = false,
    this.rating,
    this.error,
    this.message,
  });

  RatingState copyWith({
    bool? isLoading,
    Rating? rating,
    String? error,
    String? message,
  }) {
    return RatingState(
      isLoading: isLoading ?? this.isLoading,
      rating: rating ?? this.rating,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }
}
