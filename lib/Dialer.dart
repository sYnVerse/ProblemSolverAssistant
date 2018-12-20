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

  @override
  void dispose() {
    tfController.dispose();
    super.dispose();
  }

  List<String> directory = [
    null,
    null,
    "0606",
    "0109",
    "0094",
    "0410",
    "0100",
    "0077",
    "0909",
    "0112",
    "0813",
    "0323",
    "0372",
    "0087",
    "0435",
    "0384",
    "0476",
    "0890",
    "0860",
    "0439",
    "0655",
    "0622",
    "0887",
    "0426",
    "0076",
    "0541",
    "0906",
    "0370",
    "0083",
    "0085",
    "0421",
    "0383",
    "0358",
    "0089",
    "0106",
    "0516",
    "0867",
    "0832",
    "0398",
    "0103",
    "0075",
    "0334",
    "0893",
    "0345",
    "0595",
    "0072"
  ];


  @override
  Widget build(BuildContext context) {

    return Scaffold (
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            tfController.clear();
          },
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Enter device number', textScaleFactor: 2.48),
              Text('(Located on back of iPhone)'),
              Text(''),
              TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    int num = int.tryParse(value);
                    if (num == null || num < 2 || num > 45) {
                      return ' Enter a number between 2 and 45.';
                    }
                  },
                  controller: tfController,
                  textAlign: TextAlign.center
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 36.0),
                child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        String phonePrefix = "tel://*67425395";
                        int directoryIndex = int.parse(tfController.text);
                        String finalAddress = phonePrefix + directory[directoryIndex];
                        launch(finalAddress);
                      }
                      tfController.clear();
                    },
                    child: Text('Call', textScaleFactor: 1.5),
                    highlightColor: Colors.blue
                ),
              ),
            ],
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Directory()
                )
            );
          },
          tooltip: 'Opens list of active shoppers',
          child: Icon(Icons.list)
      )
    );
  }
}