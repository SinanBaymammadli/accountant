import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductCreateScreen extends StatefulWidget {
  @override
  _ProductCreateScreenState createState() => _ProductCreateScreenState();
}

class _ProductCreateScreenState extends State<ProductCreateScreen> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yeni mal yarat'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
        children: <Widget>[
          TextFormField(
            controller: _controller,
          ),
          RaisedButton(
            onPressed: () async {
              try {
                await Firestore.instance.collection('products').add(
                  {
                    'name': _controller.text,
                  },
                );

                Navigator.pop(context);
              } catch (e) {
                print(e);
              }
            },
            child: Text('Elave et'),
          ),
        ],
      ),
    );
  }
}
