class Gas {
  final String id;
  final String gasName;
  final String gasPrice;

  Gas({
    required this.id,
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