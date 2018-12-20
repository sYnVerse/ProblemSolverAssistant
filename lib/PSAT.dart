import 'package:flutter/material.dart';
import 'BagCounter.dart';
import 'Dialer.dart';

class PSAT extends StatefulWidget {
  @override
  PSATState createState() => new PSATState();
}

// SingleTickerProviderStateMixin is used for animation
class PSATState extends State<PSAT> with SingleTickerProviderStateMixin {

  // Setup controller for AppBar
  TabController controller;

  @override
  void initState() {
    super.initState();

    // Initialize the Tab Controller
    controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  TabBar getTabBar() {
    return TabBar(
      tabs: <Tab>[
        Tab(
          icon: Icon(Icons.call),
        ),
        Tab(
          icon: Icon(Icons.airport_shuttle),
        ),
        Tab(
          icon: Icon(Icons.airport_shuttle),
        )
      ],
      // setup the controller
      controller: controller,
      indicatorColor: Colors.white,
    );
  }

  TabBarView getTabBarView(var tabs) {
    return TabBarView(
      children: tabs,
      controller: controller,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
        appBar: AppBar(
          // Title
            title: Text("Problem Solver Assistant Tool"),
            // Set the background color of the App Bar
            backgroundColor: Colors.blue,
            // Set the bottom property of the Appbar to include a Tab Bar
            bottom: getTabBar()),
        // Set the TabBar view as the body of the Scaffold
        body: getTabBarView(<Widget>[
          Dialer(),
          BagCounter(driverNum: 1),
          BagCounter(driverNum: 2)]
        )
    );
  }
}