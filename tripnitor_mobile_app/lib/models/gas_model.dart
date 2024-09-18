class Gas {
  final String? id;
  final String gasName;
  final String gasPrice;

  Gas({
    this.id,
    required this.gasName,
    required this.gasPrice,
  });

  factory Gas.fromJson(Map<String, dynamic> json) {
    return Gas(
      id: json['id'],
      gasName: json['gas_name'],
      gasPrice: json['gas_price'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'gas_name': gasName,
        'gas_price': gasPrice,
      };
}

class GasState {
  final int? status;
  final Gas? gas;
  final List<Gas>? gasList;
  final String? message;
  final bool isLoading;
  final String? error;

  GasState({
    this.status,
    this.gas,
    this.gasList,
    this.message,
    this.isLoading = false,
    this.error,
  });

  GasState copyWith({
    int? status,
    Gas? gas,
    List<Gas>? gasList,
    String? message,
    bool? isLoading,
    String? error,
  }) {
    return GasState(
      status: status ?? this.status,
      gas: gas ?? this.gas,
      gasList: gasList ?? this.gasList,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
