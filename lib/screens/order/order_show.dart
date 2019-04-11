import 'package:accountant/helpers/dateFormatter.dart';
import 'package:accountant/models/order.dart';
import 'package:accountant/models/payment.dart';
import 'package:accountant/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderShowScreen extends StatefulWidget {
  final Order order;

  OrderShowScreen({@required this.order});

  @override
  _OrderShowScreenState createState() => _OrderShowScreenState();
}

class _OrderShowScreenState extends State<OrderShowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          StreamBuilder<DocumentSnapshot>(
            stream: widget.order.productRef.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || !snapshot.data.exists) {
                return Text('');
              }

              Product product = Product.fromSnapshot(snapshot.data);

              return Text(
                  '${product.name} => ${widget.order.productAmount} kq * ${widget.order.productPrice} AZN = ${widget.order.productAmount * widget.order.productPrice} AZN');
            },
          ),
          widget.order.paymentRef == null
              ? Text('Odenis olmayib')
              : StreamBuilder<DocumentSnapshot>(
                  stream: widget.order.paymentRef.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || !snapshot.data.exists) {
                      return Text('');
                    }

                    Payment payment = Payment.fromSnapshot(snapshot.data);

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
                    );
                  },
                ),
        ],
      ),
    );
  }
}
