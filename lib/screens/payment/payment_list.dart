import 'package:accountant/models/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaymentListScreen extends StatefulWidget {
  @override
  _PaymentListScreenState createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Odeme'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return _buildList(context, snapshot.data.documents);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> documents) {
    return ListView.separated(
      itemCount: documents.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (BuildContext context, int index) {
        DocumentSnapshot document = documents[index];
        return _buildListItem(context, document);
      },
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    final payment = Payment.fromSnapshot(document);

    return ListTile(
      title: Text(payment.name),
    );
  }
}
