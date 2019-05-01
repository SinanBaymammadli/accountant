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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.client.name} (${widget.client.balance} AZN)'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Ödəmələr',
              ),
              Tab(
                text: 'Alqi',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Text('odenisler'),
            Text('alqi'),
          ],
        ),
      ),
    );
  }
}
