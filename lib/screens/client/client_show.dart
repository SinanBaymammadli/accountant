import 'package:accountant/models/client.dart';
import 'package:flutter/material.dart';

class ClientShowScreen extends StatefulWidget {
  final Client client;

  ClientShowScreen({@required this.client});

  @override
  _ClientShowScreenState createState() => _ClientShowScreenState();
}

class _ClientShowScreenState extends State<ClientShowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.client.name),
      ),
      body: Center(
        child: Text(
          '${widget.client.balance} AZN',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
