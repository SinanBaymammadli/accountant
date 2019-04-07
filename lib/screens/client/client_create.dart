import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClientCreateScreen extends StatefulWidget {
  @override
  _ClientCreateScreenState createState() => _ClientCreateScreenState();
}

class _ClientCreateScreenState extends State<ClientCreateScreen> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yeni klient yarat'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(hintText: 'Adi'),
            controller: _nameController,
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Balans'),
            keyboardType: TextInputType.numberWithOptions(signed: true),
            controller: _balanceController,
          ),
          RaisedButton(
            onPressed: () async {
              try {
                await Firestore.instance.collection('clients').add(
                  {
                    'name': _nameController.text,
                    'balance': int.parse(_balanceController.text),
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
