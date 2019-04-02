import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String name;
  final DocumentReference reference;

  Order.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'];

  Order.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name>";
}
