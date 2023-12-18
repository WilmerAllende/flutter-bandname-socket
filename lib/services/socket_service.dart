import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client
    /*IO.Socket socket = IO.io('http://localhost:3000/', {
      "transports": ["websockets"],
    });*/
    _socket = IO.io(
        'http://192.168.101.17:3000',
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            //.disableAutoConnect()  // disable auto-connection
            .enableAutoConnect()
            //.setExtraHeaders({'foo': 'bar'}) // optional
            .build());

    _socket.onConnect((_) {
      print('connect a sockets');
      _serverStatus = ServerStatus.online;
      notifyListeners();
      // socket.emit('msg', 'test');
    });
    //socket.on('event', (data) => print(data));
    _socket.onDisconnect((_) {
      print('disconnect');
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
    //socket.on('fromServer', (_) => print(_));

    /*
    socket.on('nuevo-mensaje', (data) {
      print(data.containsKey("mensaje222") ? data["mensaje222"] : "no hay");
      print('nuevo-mensaje: $data');
      //notifyListeners();
    });
    */
  }
}
