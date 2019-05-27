import 'package:accountant/models/client.dart';
import 'package:accountant/models/product.dart';
import 'package:accountant/services/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

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

  _createOrder() async {
    if (_selectedClient == null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Müştəri seçin"),
        ),
      );
      return null;
    }

    if (_selectedProduct == null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Mali seçin"),
        ),
      );
      return null;
    }

    if (_isBuy == null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Mal alinir?"),
        ),
      );
      return null;
    }

    if (_formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });

      try {
        OrderService os = OrderService();

        await os.create(
          clientRef: _selectedClient.ref,
          productRef: _selectedProduct.ref,
          productAmount: double.parse(_amountController.text),
          productPrice: double.parse(_priceController.text),
          isBuy: _isBuy,
          hasPayment: _hasPayment,
          paymentAmount:
              _hasPayment ? int.parse(_paymentController.text) : null,
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
      _isBuy = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Yeni alqi-satgi yarat'),
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
                  hint: Text('Musteri secin'),
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
                      Text("Mal alinir"),
                      Radio(
                        value: true,
                        groupValue: _isBuy,
                        onChanged: _onToUsChanged,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("Mal satilir"),
                      Radio(
                        value: false,
                        groupValue: _isBuy,
                        onChanged: _onToUsChanged,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                height: 60,
                child: DropdownButton<Product>(
                  hint: Text('Mali secin'),
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                decoration: InputDecoration(hintText: 'Miqdar kq'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _amountController,
                validator: (val) {
                  if (val.isEmpty) {
                    return "Miqdar yazın";
                  }

                  if (!isFloat(val)) {
                    return "Miqdar düzgün deyil.";
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                decoration: InputDecoration(hintText: '1kq ucun qiymet AZN'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _priceController,
                validator: (val) {
                  if (val.isEmpty) {
                    return "Mebleg yazın";
                  }

                  if (!isFloat(val)) {
                    return "Mebleg düzgün deyil.";
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
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
            ),
            _hasPayment
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Odenis meblegi AZN'),
                          keyboardType: TextInputType.number,
                          controller: _paymentController,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Mebleg yazın";
                            }

                            if (!isInt(val)) {
                              return "Mebleg düzgün deyil.";
                            }
                          },
                        ),
                      ],
                    ),
                  )
                : Container(),
            RaisedButton(
              onPressed: _loading ? null : _createOrder,
              child: _loading ? CircularProgressIndicator() : Text('Əlavə et'),
            ),
          ],
        ),
      ),
    );
  }
}
