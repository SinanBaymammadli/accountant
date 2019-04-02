import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  final String name;
  final int balance;
  final DocumentReference reference;

  Client.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['balance'] != null),
        name = map['name'],
        balance = map['balance'];

  Client.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name>";
}
