import 'package:accountant/helpers/isToday.dart';
import 'package:accountant/models/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Firestore firestore = Firestore();

  @override
  void initState() {
    super.initState();
    firestore.settings(timestampsInSnapshotsEnabled: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistika'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('payments').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          int expense = 0;
          int income = 0;

          snapshot.data.documents.forEach((doc) {
            final payment = Payment.fromSnapshot(doc);

            if (isToday(payment.date)) {
              if (payment.toUs) {
                income += payment.amount;
              } else {
                expense += payment.amount;
              }
            }
          });

          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Gelir:'),
                  Text('$income AZN'),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('Xerc:'),
                  Text('$expense AZN'),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('Xalis gelir:'),
                  Text('${income - expense} AZN'),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
