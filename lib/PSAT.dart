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
        Tab(icon: Icon(Icons.shopping_cart)),
        Tab(icon: Icon(Icons.phone_android))
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
          BagCounter(driverNum: 1),
          Dialer()]
        ),
        bottomNavigationBar: Material(
          child: getTabBar(),
          color: Colors.indigo
        )
    );
  }
}