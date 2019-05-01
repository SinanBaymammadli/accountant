import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final DocumentReference ref;
  final DocumentReference productRef;
  final DocumentReference clientRef;
  final double productAmount;
  final double productPrice;
  final bool isBuy;
  final DateTime date;
  final DocumentReference paymentRef;

  Order.fromMap(Map<String, dynamic> map, DocumentReference reference)
      : ref = reference,
        assert(map['product_ref'] != null),
        productRef = map['product_ref'],
        assert(map['client_ref'] != null),
        clientRef = map['client_ref'],
        assert(map['product_amount'] != null),
        productAmount = double.parse(map['product_amount'].toString()),
        assert(map['product_price'] != null),
        productPrice = double.parse(map['product_price'].toString()),
        assert(map['is_buy'] != null),
        isBuy = map['is_buy'],
        assert(map['date'] != null),
        date = map['date'].toDate(),
        paymentRef = map['payment_ref'];

  Order.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, snapshot.reference);

  @override
  String toString() => "Record<$productRef>";
}
