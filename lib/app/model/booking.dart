class BookingResponse {
  final bool success;
  final String message;
  final List<Booking> data;

  BookingResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List)
          .map((booking) => Booking.fromJson(booking))
          .toList(),
    );
  }
}

class Booking {
  final String id;
  final String guestName;
  final String guestEmail;
  final String status;
  final DateTime createdAt;
  final String packageName;
  final DateTime travelDate;
  final int travelers;
  final String paymentStatus;
  final double totalAmountPaid;
  final String? currency;

  Booking({
    required this.id,
    required this.guestName,
    required this.guestEmail,
    required this.status,
    required this.createdAt,
    required this.packageName,
    required this.travelDate,
    required this.travelers,
    required this.paymentStatus,
    required this.totalAmountPaid,
    this.currency,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      guestName: json['guestName'],
      guestEmail: json['guestEmail'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      packageName: json['packageName'],
      travelDate: DateTime.parse(json['travelDate']),
      travelers: json['travelers'],
      paymentStatus: json['paymentStatus'],
      totalAmountPaid: (json['totalAmountPaid'] as num).toDouble(),
      currency: json['currency'],
    );
  }

  // Helper methods for UI
  String get formattedCreatedDate {
    return "${createdAt.day}/${createdAt.month}/${createdAt.year}";
  }

  String get formattedTravelDate {
    return "${travelDate.day}/${travelDate.month}/${travelDate.year}";
  }

  String get statusColor {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'green';
      case 'pending':
        return 'orange';
      case 'cancelled':
        return 'red';
      default:
        return 'gray';
    }
  }

  String get paymentStatusColor {
    switch (paymentStatus.toLowerCase()) {
      case 'paid':
        return 'green';
      case 'pending':
        return 'orange';
      case 'failed':
        return 'red';
      default:
        return 'gray';
    }
  }

  bool get isPaid => paymentStatus.toLowerCase() == 'paid';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isConfirmed => status.toLowerCase() == 'confirmed';
  bool get isCancelled => status.toLowerCase() == 'cancelled';
}