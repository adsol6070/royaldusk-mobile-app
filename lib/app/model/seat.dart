import 'package:get/get.dart';

class Seat {
  late String seatNumber;
  bool? bookingStatus;
  RxBool isSelected = false.obs;

  Seat(
      {required this.seatNumber,
      required this.bookingStatus,
      bool isSelected = false})
      : isSelected = isSelected.obs;

  Seat.fromJson(Map<String, dynamic> json) {
    seatNumber = json['seat_number'] ?? 0;
    bookingStatus = json['booking_Status'] ?? false;

  }

  /* factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      seatNumber: json['seat_number'] ?? 0,
      bookingStatus: json['booking_Status'] ?? false,
      isSelected: false,
    );
  }*/

  Map<String, dynamic> toJson() {
    return {
      'seat_number': seatNumber,
      'booking_Status': bookingStatus,
    };
  }
}
