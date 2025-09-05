// lib/widgets/card_list_tile.dart
import 'package:ansvel/homeandregistratiodesign/models/tokenized_card.dart';
import 'package:flutter/material.dart';
// import '../models/tokenized_card.dart';

class CardListTile extends StatelessWidget {
  final TokenizedCard card;
  final bool selected;
  final VoidCallback onTap;

  const CardListTile({Key? key, required this.card, required this.selected, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brand = (card.cardType ?? 'Card').toUpperCase();
    return ListTile(
      leading: Icon(Icons.credit_card),
      title: Text('$brand •••• ${card.last4}'),
      subtitle: Text('${card.bank ?? ''}  ${card.expMonth != null && card.expYear != null ? '${card.expMonth}/${card.expYear}' : ''}'),
      trailing: selected ? Icon(Icons.check_circle, color: Colors.green) : null,
      onTap: onTap,
    );
  }
}
