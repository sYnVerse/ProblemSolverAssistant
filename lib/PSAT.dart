import 'package:flutter/material.dart';
import 'BagCounter.dart';
import 'Dialer.dart';

class PSAT extends StatefulWidget {
  PSATState createState() => PSATState();
}

class PSATState extends State<PSAT> with SingleTickerProviderStateMixin {

  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  TabBar getTabBar() {
    return TabBar(
      tabs: <Tab>[
        Tab(icon: Icon(Icons.call)),
        Tab(icon: Icon(Icons.airport_shuttle))
      ],

      // setup the controller
      controller: controller
    );
  }

  TabBarView getTabBarView(var tabs) {
    return TabBarView(
      children: tabs,
      controller: controller,
      //physics: NeverScrollableScrollPhysics()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: getTabBarView(<Widget>[
          Dialer(),
          BagCounter(driverNum: 1)]
        ),
        bottomNavigationBar: Material(
          child: getTabBar(),
          color: Colors.blue,
        )
    );
  }
}