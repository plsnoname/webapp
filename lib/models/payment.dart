class Payment {
  final bool isPartial;
  final bool isRefundable;
  final String paymentMethod;
  final bool beforeService;

  Payment({
    required this.isPartial,
    required this.isRefundable,
    required this.paymentMethod,
    required this.beforeService,
  });
}
