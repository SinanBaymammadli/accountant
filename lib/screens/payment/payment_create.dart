import 'package:accountant/models/client.dart';
import 'package:accountant/services/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class PaymentCreateScreen extends StatefulWidget {
  @override
  _PaymentCreateScreenState createState() => _PaymentCreateScreenState();
}

class _PaymentCreateScreenState extends State<PaymentCreateScreen> {
  List<Client> _clients = [];
  final _amountController = TextEditingController();
  bool _toUs;
  Client _selectedClient;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _getClients();
  }

  _getClients() async {
    QuerySnapshot snap =
        await Firestore.instance.collection('clients').getDocuments();
    List<Client> clients = [];
    List<DocumentSnapshot> documents = snap.documents;

    if (documents != null) {
      documents.forEach((val) {
        clients.add(Client.fromSnapshot(val));
      });
    }

    setState(() {
      _clients = clients;
    });
  }

  _createPayment() async {
    if (_selectedClient == null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Müştəri seçin"),
        ),
      );
      return null;
    }

    if (_toUs == null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Odenisin novunu teyin edin"),
        ),
      );
      return null;
    }

    if (_formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });

      try {
        PaymentService ps = PaymentService();

        await ps.create(
          amount: int.parse(_amountController.text),
          clientRef: _selectedClient.ref,
          toUs: _toUs,
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

  _onToUsChanged(bool val) {
    setState(() {
      _toUs = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Yeni ödəmə yarat'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                height: 60,
                child: DropdownButton<Client>(
                  hint: Text("Müştəri seçin"),
                  isExpanded: true,
                  value: _selectedClient,
                  onChanged: (Client newClient) {
                    setState(() {
                      _selectedClient = newClient;
                    });
                  },
                  items: _clients.map((Client client) {
                    return DropdownMenuItem(
                      value: client,
                      child: Text(client.name),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Odenis alinir"),
                      Radio(
                        value: true,
                        groupValue: _toUs,
                        onChanged: _onToUsChanged,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("Odenis edilir"),
                      Radio(
                        value: false,
                        groupValue: _toUs,
                        onChanged: _onToUsChanged,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                decoration: InputDecoration(hintText: 'Məbləğ (AZN)'),
                keyboardType: TextInputType.number,
                controller: _amountController,
                validator: (val) {
                  if (val.isEmpty) {
                    return "Məbləğ yazın";
                  }

                  if (!isInt(val)) {
                    return "Məbləğ düzgün deyil.";
                  }
                },
              ),
            ),
            RaisedButton(
              onPressed: _loading ? null : _createPayment,
              child: _loading ? CircularProgressIndicator() : Text('Əlavə et'),
            ),
          ],
        ),
      ),
    );
  }
}
