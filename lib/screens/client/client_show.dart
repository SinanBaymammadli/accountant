import 'package:accountant/helpers/dateFormatter.dart';
import 'package:accountant/models/client.dart';
import 'package:accountant/models/order.dart';
import 'package:accountant/models/payment.dart';
import 'package:accountant/models/product.dart';
import 'package:accountant/screens/order/order_show.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClientShowScreen extends StatefulWidget {
  final Client client;

  ClientShowScreen({@required this.client});

  @override
  _ClientShowScreenState createState() => _ClientShowScreenState();
}

class _ClientShowScreenState extends State<ClientShowScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.client.name} (${widget.client.balance} AZN)'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Ödəmələr',
              ),
              Tab(
                text: 'Alqi',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('payments')
                  .where('client_ref', isEqualTo: widget.client.ref)
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                return _buildPaymentList(context, snapshot.data.documents);
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('orders')
                  .where('client_ref', isEqualTo: widget.client.ref)
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                return _buildOrderList(context, snapshot.data.documents);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentList(
      BuildContext context, List<DocumentSnapshot> documents) {
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

        return _buildPaymentListItem(context, document);
      },
    );
  }

  Widget _buildPaymentListItem(
      BuildContext context, DocumentSnapshot document) {
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

  Widget _buildOrderList(
      BuildContext context, List<DocumentSnapshot> documents) {
    if (documents.length == 0) {
      return Center(
        child: Text('Alqi-satgi yoxdur'),
      );
    }

    return ListView.separated(
      itemCount: documents.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (BuildContext context, int index) {
        DocumentSnapshot document = documents[index];
        return _buildOrderListItem(context, document);
      },
    );
  }

  Widget _buildOrderListItem(BuildContext context, DocumentSnapshot document) {
    final order = Order.fromSnapshot(document);

    print('here: ${order.productRef.toString()}');

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
