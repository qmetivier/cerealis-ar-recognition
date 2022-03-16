import 'dart:convert';

import '../main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginDialog extends State<ImageRecognitionApp>{

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();

  /// Rendu de la la PopUp d'authentification
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Partage'),
      content: ListView(
        children: <Widget>[
          TextField(
            controller: _name,
            decoration: const InputDecoration(hintText: 'Nom'),
          ),
          TextField(
            obscureText: true,
            controller: _email,
            decoration: const InputDecoration(hintText: 'Email'),
          ),
        ],
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: const Text('Login'),
          onPressed: () {
            _ShareApi(context).then((bool isConnected) => {
              if(isConnected) Navigator.pop(context, 'success')
            });
          },
        ),
      ],
    );
  }

  /// @return Future<String> success or null si l'authentification est bonne ou non
  Future<String> ShareDialogShow(BuildContext context) async {

    String value = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: build,
    );

    return value;

  }

  /// @return Future<bool> si l'utlisateur existe ou pas dans l'API
  ///
  /// Initialise le token si l'authentification est correct
  Future<bool> _ShareApi(BuildContext context) async {
    try {
      http.Response response = await http.post(
          Uri(path: 'http://192.168.43.2:8008/api/token-auth/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(
              {'name': _name.text, 'email': _email.text})
      ).timeout(Duration(seconds: 5));

      return (response.statusCode == 200);
    }
    catch(exception){
      return false;
    }
  }
}
