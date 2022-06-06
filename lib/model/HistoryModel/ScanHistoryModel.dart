import 'dart:convert';

List<ScanModelHistory> scanModelHistoryFromJson(String str) => List<ScanModelHistory>.from(json.decode(str).map((x) => ScanModelHistory.fromJson(x)));

String scanModelHistoryToJson(List<ScanModelHistory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ScanModelHistory {
  ScanModelHistory({
    required this.id,
    required this.qrNumber,
    required this.date,
    required this.points,
    required this.time,
  });

  int id;
  String qrNumber;
  String date;
  int points;
  String time;

  factory ScanModelHistory.fromJson(Map<String, dynamic> json) => ScanModelHistory(
    id: json["id"],
    qrNumber: json["QrNumber"],
    date: json["date"],
    points: json["Points"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "QrNumber": qrNumber,
    "date": date,
    "Points":points,
    "time": time,
  };
}
