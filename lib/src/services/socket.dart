import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{ Online, Offline, Connecting }

class SocketService with ChangeNotifier{
  ServerStatus _serverStatus = ServerStatus.Connecting;

  SocketService(){
    this._initConfig();
  }

  void _initConfig(){
    IO.Socket socket = IO.io('https://127.0.0.1:3000',{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    socket.on('connect', (_) {
      print('Connected');
    });
    socket.on('disconnect', (_) {
      print('Disconnected');
    });
  }
}