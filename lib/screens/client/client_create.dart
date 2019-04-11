import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class ClientCreateScreen extends StatefulWidget {
  @override
  _ClientCreateScreenState createState() => _ClientCreateScreenState();
}

class _ClientCreateScreenState extends State<ClientCreateScreen> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  _createClient() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });

      try {
        await Firestore.instance.collection('clients').add(
          {
            'name': _nameController.text,
            'balance': int.parse(_balanceController.text),
          },
        );

        setState(() {
          _loading = false;
        });

        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _loading = false;
        });

        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yeni müştəri yarat'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                decoration: InputDecoration(hintText: 'Müştəri adı'),
                controller: _nameController,
                validator: (val) {
                  if (val.isEmpty) {
                    return "Ad yazin.";
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                decoration: InputDecoration(hintText: 'İlkin balans (AZN)'),
                keyboardType: TextInputType.numberWithOptions(signed: true),
                controller: _balanceController,
                validator: (val) {
                  if (val.isEmpty) {
                    return "Balans yazin. (AZN)";
                  }

                  if (!isFloat(val)) {
                    return "Duzgun reqem yazin.";
                  }
                },
              ),
            ),
            RaisedButton(
              onPressed: _loading ? null : _createClient,
              child: _loading ? CircularProgressIndicator() : Text('Əlavə et'),
            ),
          ],
        ),
      ),
    );
  }
}
