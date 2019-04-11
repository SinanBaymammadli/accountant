import 'package:accountant/helpers/dateFormatter.dart';
import 'package:accountant/models/client.dart';
import 'package:accountant/models/payment.dart';
import 'package:accountant/screens/payment/payment_create.dart';
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
        title: Text('Ödəmələr'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('payments')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return _buildList(context, snapshot.data.documents);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return PaymentCreateScreen();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> documents) {
    if (documents.length == 0) {
      return Center(
        child: Text('Ödəmə yoxdur'),
      );
    }

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
      leading: payment.toUs
          ? Icon(
              Icons.arrow_downward,
              color: Colors.green,
            )
          : Icon(
              Icons.arrow_upward,
              color: Colors.red,
            ),
      title: Text('${payment.amount} AZN'),
      subtitle: Text(formatDate(payment.date)),
      trailing: StreamBuilder<DocumentSnapshot>(
        stream: payment.clientRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data.exists) {
            return Text('');
          }

          Client client = Client.fromSnapshot(snapshot.data);

          return Text(client.name);
        },
      ),
    );
  }
}
