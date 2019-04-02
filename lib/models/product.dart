import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final DocumentReference reference;

  Product.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'];

  Product.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name>";
}
