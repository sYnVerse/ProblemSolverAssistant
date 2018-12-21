import 'package:flutter/material.dart';

class Directory extends StatefulWidget {
  DirectoryState createState() => DirectoryState();
}

class DirectoryState extends State<Directory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text('PSAT: Directory'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
             
            },
          )
        ],
      ),
      body: Container(
        width: 0,
        height: 0,
        color: Colors.white,
      ),
    );
  }
}