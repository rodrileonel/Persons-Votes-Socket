import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:votes/src/services/socket.dart';


class StatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server Status: ${socketService.serverStatus}')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: (){
          socketService.socket.emit('flutter-message',{
            'name':'rodrigo',
            'message':'Hola desde flutter'
          });
        },
      ),
    );
  }
}