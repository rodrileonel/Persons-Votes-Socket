import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:votes/src/services/socket.dart';


class StausPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      body: Center(
        child: Text('Hola Mundo'),
     ),
   );
  }
}