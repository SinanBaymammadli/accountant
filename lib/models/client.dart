import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  final DocumentReference ref;
  final String name;
  final int balance;

  Client.fromMap(Map<String, dynamic> map, DocumentReference reference)
      : ref = reference,
        assert(map['name'] != null),
        name = map['name'],
        assert(map['balance'] != null),
        balance = map['balance'];

  Client.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, snapshot.reference);

  @override
  String toString() => "Record<$name>";
}
