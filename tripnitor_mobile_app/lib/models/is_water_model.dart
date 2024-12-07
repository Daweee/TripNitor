class IsWaterState {
  final bool isLoading;
  final bool? isWater;
  final String? error;

  IsWaterState({
    this.isLoading = false,
    this.isWater,
    this.error,
  });

  IsWaterState copyWith({
    bool? isLoading,
    bool? isWater,
    String? error,
  }) {
    return IsWaterState(
      isLoading: isLoading ?? this.isLoading,
      isWater: isWater ?? this.isWater,
      error: error ?? this.error,
    );
  }
}
