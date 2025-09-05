// lib/models/tokenized_card.dart
class TokenizedCard {
  final String id;
  final String userId;
  final String authCode;
  final String cardType;
  final String last4;
  final int? expMonth;
  final int? expYear;
  final String? bank;

  TokenizedCard({
    required this.id,
    required this.userId,
    required this.authCode,
    required this.cardType,
    required this.last4,
    this.expMonth,
    this.expYear,
    this.bank,
  });

  factory TokenizedCard.fromJson(Map<String, dynamic> json) {
    return TokenizedCard(
      id: json['_id']?['\$oid']?.toString() ?? (json['id']?.toString() ?? ''),
      userId: json['userId'] ?? '',
      authCode: json['authCode'] ?? '',
      cardType: json['cardType'] ?? '',
      last4: json['last4'] ?? '',
      expMonth: json['expMonth'] != null ? int.tryParse(json['expMonth'].toString()) : null,
      expYear: json['expYear'] != null ? int.tryParse(json['expYear'].toString()) : null,
      bank: json['bank'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'authCode': authCode,
        'cardType': cardType,
        'last4': last4,
        'expMonth': expMonth,
        'expYear': expYear,
        'bank': bank,
      };
}
