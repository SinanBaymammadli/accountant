import 'package:accountant/models/client.dart';
import 'package:accountant/services/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaymentCreateScreen extends StatefulWidget {
  @override
  _PaymentCreateScreenState createState() => _PaymentCreateScreenState();
}

class _PaymentCreateScreenState extends State<PaymentCreateScreen> {
  List<Client> _clients = [];
  final _amountController = TextEditingController();
  bool _toUs = true;
  Client _selectedClient;
  bool _loading = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yeni odenis yarat'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
        children: <Widget>[
          DropdownButton<Client>(
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
          Row(
            children: <Widget>[
              Text("Odenis alinir?"),
              Switch(
                value: _toUs,
                onChanged: (v) {
                  setState(() {
                    _toUs = v;
                  });
                },
              ),
            ],
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Mebleg AZN'),
            keyboardType: TextInputType.number,
            controller: _amountController,
          ),
          RaisedButton(
            onPressed: _loading
                ? null
                : () async {
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

                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }
                  },
            child: _loading ? CircularProgressIndicator() : Text('Elave et'),
          ),
        ],
      ),
    );
  }
}
