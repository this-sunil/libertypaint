class Amount {
  final int points;
  final double cash;
  Amount({required this.points, required this.cash});
  factory Amount.fromJson(Map<String,dynamic> map){
    return Amount(points:map["Points"], cash:map["Money"]);
  }
}
