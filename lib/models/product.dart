import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final DocumentReference ref;
  final String name;

  Product.fromMap(Map<String, dynamic> map, DocumentReference reference)
      : ref = reference,
        assert(map['name'] != null),
        name = map['name'];

  Product.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, snapshot.reference);

  @override
  String toString() => "Record<$name>";
}
