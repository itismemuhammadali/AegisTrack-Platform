class TrackedPaymentCardEntity {
  const TrackedPaymentCardEntity({
    required this.brand,
    required this.last4,
    required this.expiry,
    this.isDefault = false,
  });

  final String brand;
  final String last4;
  final String expiry;
  final bool isDefault;

  String get maskedNumber => '$brand ···· $last4';

  TrackedPaymentCardEntity copyWith({bool? isDefault}) =>
      TrackedPaymentCardEntity(
        brand: brand,
        last4: last4,
        expiry: expiry,
        isDefault: isDefault ?? this.isDefault,
      );
}
