import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{ Online, Offline, Connecting }

class SocketService with ChangeNotifier{
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  SocketService(){
    this._initConfig();
  }

  void _initConfig(){
    print('Inicializando...');
    this._socket = IO.io('https://server-flutter.herokuapp.com/',{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    this._socket.on('connect', (_) {
      print('Connected');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.on('disconnect', (_) {
      print('Disconnected');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    this._socket.on('web-message', ( response ) {
      print('nuevo-mensajito: '+ response['name']);
      print(response.containsKey('name2') ? response['name2']:'');
    });
  }
}