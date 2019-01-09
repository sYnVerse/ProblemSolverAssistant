import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'Directory.dart';

class Dialer extends StatefulWidget {
  DialerState createState() => DialerState();
}

class DialerState extends State<Dialer> {

  final _formKey = GlobalKey<FormState>();
  final tfController = TextEditingController();
  final phonePrefix = 'tel:*671425395';


  @override
  void dispose() {
    super.dispose();
    tfController.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    tfController.clear();
  }

  List<String> directory = [
    null,
    null,
    '0606',
    '0109',
    '0094',
    '0410',
    '0100',
    '0077',
    '0909',
    '0112',
    '0813',
    '0323',
    '0372',
    '0087',
    '0435',
    '0384',
    '0476',
    '0890',
    '0860',
    '0439',
    '0655',
    '0622',
    '0887',
    '0426',
    '0076',
    '0541',
    '0906',
    '0370',
    '0083',
    '0085',
    '0421',
    '0383',
    '0358',
    '0089',
    '0106',
    '0516',
    '0867',
    '0832',
    '0397',
    '0103',
    '0075',
    '0334',
    '0893',
    '0345',
    '0595',
    '0072'
  ];

  initCall(int directoryIndex) async {
    final finalURL = phonePrefix + directory[directoryIndex];
    if (await canLaunch(finalURL)) {
      await launch(Uri.encodeFull(finalURL));
    } else {
      throw 'Could not launch $finalURL';
    }
  }

  @override
  Widget build(BuildContext context) {

    _call() async {
        int userInput = int.parse(tfController.text);
        initCall(userInput);
        tfController.clear();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
    }

    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Scaffold (
        appBar: AppBar (
          title: Text('Dialer'),
          backgroundColor: Colors.indigo,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.important_devices),
              tooltip: 'Opens directory of shoppers',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Directory())
                );
              }
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.number,
                controller: tfController,
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.go,
                validator: (value) {
                  int num = int.tryParse(value);
                  if (num == null || num < 2 || num > 45) {
                    return ' Enter a number between 2 and 45!!!';
                  }
                },
                onFieldSubmitted: (value) {
                  if (_formKey.currentState.validate()) {
                    _call();
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Enter device number',
                  prefixText: '        ',
                  suffixIcon: IconButton (
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      tfController.clear();
                    }
                  )
                ),
              ),
              MaterialButton(
                padding: EdgeInsets.symmetric(vertical: 24),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _call();
                  }
                },
                child: Icon(Icons.phone, color: Colors.green, size: 48),
                highlightColor: Colors.indigo,
              )
            ],
          ),
        )
      )
    );
  }
}