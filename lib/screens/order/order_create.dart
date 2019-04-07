import 'package:accountant/models/client.dart';
import 'package:accountant/models/product.dart';
import 'package:accountant/services/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderCreateScreen extends StatefulWidget {
  @override
  _OrderCreateScreenState createState() => _OrderCreateScreenState();
}

class _OrderCreateScreenState extends State<OrderCreateScreen> {
  List<Client> _clients = [];
  List<Product> _products = [];
  Client _selectedClient;
  Product _selectedProduct;
  final _amountController = TextEditingController();
  final _priceController = TextEditingController();
  final _paymentController = TextEditingController();
  bool _isBuy = true;
  bool _hasPayment = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _getClients();

    _getProducts();
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

  _getProducts() async {
    QuerySnapshot snap =
        await Firestore.instance.collection('products').getDocuments();
    List<Product> products = [];
    List<DocumentSnapshot> documents = snap.documents;

    if (documents != null) {
      documents.forEach((val) {
        products.add(Product.fromSnapshot(val));
      });
    }

    setState(() {
      _products = products;
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
          DropdownButton<Product>(
            isExpanded: true,
            value: _selectedProduct,
            onChanged: (Product newProduct) {
              setState(() {
                _selectedProduct = newProduct;
              });
            },
            items: _products.map((Product product) {
              return DropdownMenuItem(
                value: product,
                child: Text(product.name),
              );
            }).toList(),
          ),
          Row(
            children: <Widget>[
              Text("Mal alinir?"),
              Switch(
                value: _isBuy,
                onChanged: (v) {
                  setState(() {
                    _isBuy = v;
                  });
                },
              ),
            ],
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Miqdar kq'),
            keyboardType: TextInputType.number,
            controller: _amountController,
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Mebleg AZN'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _priceController,
          ),
          Row(
            children: <Widget>[
              Text("Odenis var?"),
              Switch(
                value: _hasPayment,
                onChanged: (v) {
                  setState(() {
                    _hasPayment = v;
                  });
                },
              ),
            ],
          ),
          _hasPayment
              ? Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Mebleg AZN'),
                      keyboardType: TextInputType.number,
                      controller: _paymentController,
                    ),
                  ],
                )
              : Container(),
          RaisedButton(
            onPressed: _loading
                ? null
                : () async {
                    setState(() {
                      _loading = true;
                    });

                    try {
                      OrderService os = OrderService();

                      await os.create(
                        clientRef: _selectedClient.ref,
                        productRef: _selectedProduct.ref,
                        productAmount: int.parse(_amountController.text),
                        productPrice: double.parse(_priceController.text),
                        isBuy: _isBuy,
                        hasPayment: _hasPayment,
                        paymentAmount: _hasPayment
                            ? int.parse(_paymentController.text)
                            : null,
                      );

                      Navigator.pop(context);
                    } catch (e) {
                      print("errror: $e");
                    }
                  },
            child: _loading ? CircularProgressIndicator() : Text('Elave et'),
          ),
        ],
      ),
    );
  }
}
