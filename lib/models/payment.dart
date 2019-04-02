import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String name;
  final DocumentReference reference;

  Payment.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'];

  Payment.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name>";
}
