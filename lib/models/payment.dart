import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final DocumentReference ref;
  final int amount;
  final Timestamp date;
  final bool toUs;
  final DocumentReference clientRef;

  Payment.fromMap(Map<String, dynamic> map, DocumentReference reference)
      : ref = reference,
        assert(map['amount'] != null),
        amount = map['amount'],
        assert(map['date'] != null),
        date = map['date'],
        assert(map['to_us'] != null),
        toUs = map['to_us'],
        assert(map['client_ref'] != null),
        clientRef = map['client_ref'];

  Payment.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, snapshot.reference);

  @override
  String toString() => "Record<$amount>";
}
