import 'package:accountant/models/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClientListScreen extends StatefulWidget {
  @override
  _ClientListScreenState createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Klientler'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('clients').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return _buildList(context, snapshot.data.documents);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> documents) {
    return ListView.separated(
      itemCount: documents.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (BuildContext context, int index) {
        DocumentSnapshot document = documents[index];
        return _buildListItem(context, document);
      },
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    final client = Client.fromSnapshot(document);

    return ListTile(
      title: Text(client.name),
      trailing: Text('${client.balance} AZN'),
    );
  }
}
