class Hotel {
  final String name;
  final DateTime checkInTime;
  final DateTime checkOutTime;
  final List<String> paymentMethods;
  final String description;
  final String locationMapUrl;
  final String requirements;
  final String fiscalDetails;
  final List<String> reviews;
  final List<String> mediaFiles;

  Hotel({
    required this.name,
    required this.checkInTime,
    required this.checkOutTime,
    required this.paymentMethods,
    required this.description,
    required this.locationMapUrl,
    required this.requirements,
    required this.fiscalDetails,
    required this.reviews,
    required this.mediaFiles,
  });
}
