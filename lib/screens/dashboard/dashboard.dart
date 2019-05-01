import 'package:accountant/components/datetime_picker.dart';
import 'package:accountant/models/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Firestore firestore = Firestore();
  DateTime _fromDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    0,
    0,
    0,
  );
  DateTime _toDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    23,
    59,
    59,
  );

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
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DateTimePicker(
                    labelText: 'From',
                    selectedDate: _fromDate,
                    selectDate: (DateTime date) {
                      print(date);
                      setState(() {
                        _fromDate = date;
                      });
                    },
                  ),
                ),
                SizedBox(width: 24),
                Expanded(
                  child: DateTimePicker(
                    labelText: 'To',
                    selectedDate: _toDate,
                    selectDate: (DateTime date) {
                      setState(() {
                        _toDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          23,
                          59,
                          59,
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('payments')
                .where('date', isGreaterThanOrEqualTo: _fromDate)
                .where('date', isLessThanOrEqualTo: _toDate)
                .snapshots(),
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

                if (payment.toUs) {
                  income += payment.amount;
                } else {
                  expense += payment.amount;
                }
              });

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Gelir:',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Text(
                      '$income AZN',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Xerc:',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Text(
                      '$expense AZN',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Xalis gelir:',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Text(
                      '${income - expense} AZN',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
