import 'package:flutter/material.dart';
import 'PSAT.dart';

void main() {
  runApp(MaterialApp(
      title: "Problem Solver Assistant Tool",
      home: PSAT(),
      theme: ThemeData(
        // Define the default Brightness and Colors
        brightness: Brightness.dark,
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent,

        // Define the default Font Family
        fontFamily: 'Thasadith'
      )
    )
  );
}



