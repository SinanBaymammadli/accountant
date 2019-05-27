import 'package:accountant/helpers/dateFormatter.dart';
import 'package:accountant/models/client.dart';
import 'package:accountant/models/order.dart';
import 'package:accountant/models/product.dart';
import 'package:accountant/screens/order/order_create.dart';
import 'package:accountant/screens/order/order_show.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alqı-Satqı'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('orders')
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
                return OrderCreateScreen();
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
        child: Text('Alqı-satqı yoxdur'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: documents.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (BuildContext context, int index) {
        DocumentSnapshot document = documents[index];
        return _buildListItem(context, document);
      },
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    final order = Order.fromSnapshot(document);

    return ListTile(
      leading: order.isBuy
          ? Icon(
              Icons.arrow_downward,
              color: Colors.green,
            )
          : Icon(
              Icons.arrow_upward,
              color: Colors.red,
            ),
      title: StreamBuilder<DocumentSnapshot>(
        stream: order.clientRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data.exists) {
            return Text('');
          }

          Client client = Client.fromSnapshot(snapshot.data);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(client.name),
              Text(formatDate(order.date)),
            ],
          );
        },
      ),
      subtitle: StreamBuilder<DocumentSnapshot>(
        stream: order.productRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data.exists) {
            return Text('');
          }

          Product product = Product.fromSnapshot(snapshot.data);

          return Text(
              '${product.name} => ${order.productAmount} kq * ${order.productPrice} AZN = ${(order.productAmount * order.productPrice).round()} AZN');
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return OrderShowScreen(
                order: order,
              );
            },
          ),
        );
      },
    );
  }
}
