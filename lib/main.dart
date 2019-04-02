import 'package:accountant/screens/tab_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabView(),
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: Text('Hello'),
      //   ),
      //   body: Center(
      //     child: StreamBuilder<QuerySnapshot>(
      //       stream: Firestore.instance.collection('products').snapshots(),
      //       builder: (context, snapshot) {
      //         if (!snapshot.hasData) return LinearProgressIndicator();

      //         return _buildList(context, snapshot.data.documents);
      //       },
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          // onTap: () => Firestore.instance.runTransaction(
          //       (transaction) async {
          //         final freshSnapshot = await transaction.get(record.reference);
          //         final fresh = Record.fromSnapshot(freshSnapshot);

          //         await transaction
          //             .update(record.reference, {'votes': fresh.votes + 1});
          //       },
          //     ),
        ),
      ),
    );
  }
}

class Record {
  final String name;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name>";
}
