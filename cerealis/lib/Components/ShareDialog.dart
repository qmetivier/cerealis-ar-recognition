import 'dart:convert';

import '../main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShareDialog extends State<ImageRecognitionApp>{

  ShareDialog(this._pageController);

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();

  final PageController _pageController;


  /// Rendu de la la PopUp d'authentification
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _name,
                decoration: const InputDecoration(hintText: 'Nom'),
              ),
              TextField(
                controller: _email,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              FlatButton(
                child: const Text('Share'),
                onPressed: () {
                  _ShareApi(context).then((bool hasShared) => {
                    _pageController.jumpToPage(0)
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// @return Future<String> success or null si l'authentification est bonne ou non
  Future<String> ShareDialogShow(BuildContext context) async {

    final String value = await showDialog(
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
      print('azeaze');
      http.Response response = await http.post(
          Uri(path: 'http://192.168.43.2:8008/api/customer/'),
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
