class Token {
  String access;
  String refresh;

  Token({
    required this.access,
    required this.refresh,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        access: json["access"],
        refresh: json["refresh"],
      );

  Map<String, dynamic> toJson() => {
        "access": access,
        "refresh": refresh,
      };
}
