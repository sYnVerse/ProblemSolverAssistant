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
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
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
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: IconButton(icon: Icon(Icons.person_add, color: Colors.white), onPressed: null),
      )
    );
  }
}