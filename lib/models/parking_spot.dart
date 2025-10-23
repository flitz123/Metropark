class ParkingSpot {
  final int id;
  bool occupied;
  String carReg;
  String phone;
  int startTime;

  ParkingSpot({
    required this.id,
    required this.occupied,
    required this.carReg,
    required this.phone,
    required this.startTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'occupied': occupied,
      'carReg': carReg,
      'phone': phone,
      'startTime': startTime,
    };
  }

  factory ParkingSpot.fromJson(Map<String, dynamic> json) {
    return ParkingSpot(
      id: json['id'],
      occupied: json['occupied'],
      carReg: json['carReg'],
      phone: json['phone'],
      startTime: json['startTime'],
    );
  }
}