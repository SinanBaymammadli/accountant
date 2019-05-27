import 'package:accountant/models/product.dart';
import 'package:accountant/screens/product/product_create.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mallar'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return _buildList(context, snapshot.data.documents);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return ProductCreateScreen();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> documents) {
    if (documents.length == 0) {
      return Center(
        child: Text('Mal yoxdur'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: documents.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (BuildContext context, int index) {
        DocumentSnapshot document = documents[index];
        return _buildListItem(context, document);
      },
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    final product = Product.fromSnapshot(document);

    return ListTile(
      title: Text(product.name),
    );
  }
}
