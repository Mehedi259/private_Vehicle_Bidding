class PaymentMethodModel {
  final int id;
  final String stripePaymentMethodId;
  final String cardBrand;
  final String last4;
  final int expMonth;
  final int expYear;
  final bool isDefault;
  final String createdAt;

  PaymentMethodModel({
    required this.id,
    required this.stripePaymentMethodId,
    required this.cardBrand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    required this.isDefault,
    required this.createdAt,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] ?? 0,
      stripePaymentMethodId: json['stripe_payment_method_id'] ?? '',
      cardBrand: json['card_brand'] ?? 'Unknown',
      last4: json['last4'] ?? '****',
      expMonth: json['exp_month'] ?? 1,
      expYear: json['exp_year'] ?? 2000,
      isDefault: json['is_default'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}
