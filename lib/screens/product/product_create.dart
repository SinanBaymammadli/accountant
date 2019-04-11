import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductCreateScreen extends StatefulWidget {
  @override
  _ProductCreateScreenState createState() => _ProductCreateScreenState();
}

class _ProductCreateScreenState extends State<ProductCreateScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  _createProduct() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });

      try {
        await Firestore.instance.collection('products').add({
          'name': _controller.text,
        });

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
        title: Text('Yeni mal yarat'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Malın adı'),
                validator: (String val) {
                  if (val.isEmpty) {
                    return "Ad yazın.";
                  }
                },
              ),
            ),
            RaisedButton(
              onPressed: _loading ? null : _createProduct,
              child: _loading ? CircularProgressIndicator() : Text('Əlavə et'),
            ),
          ],
        ),
      ),
    );
  }
}
