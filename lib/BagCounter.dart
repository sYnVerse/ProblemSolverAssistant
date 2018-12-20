import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class BagCounter extends StatefulWidget {
  BagCounter({Key key, this.driverNum}) : super(key: key);

  final int driverNum;

  BagCounterState createState() => BagCounterState();
}


class BagCounterState extends State<BagCounter> {

  int _mainCounter = 0;
  int _cartOne = 0;
  int _cartTwo = 0;
  int _cartThree = 0;
  int _cartFour = 0;

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _loadData(widget.driverNum);
    _updateMainCount(widget.driverNum);
  }

  // Loading counter value on start
  _loadData(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _mainCounter = (prefs.getInt('main$id') ?? 0);
      _cartOne = (prefs.getInt('cartOne$id') ?? 0);
      _cartTwo = (prefs.getInt('cartTwo$id') ?? 0);
      _cartThree = (prefs.getInt('cartThree$id') ?? 0);
      _cartFour = (prefs.getInt('cartFour$id') ?? 0);
    });
  }

  _updateMainCount(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _mainCounter = (prefs.getInt('cartOne$id') ?? 0) +
          (prefs.getInt('cartTwo$id') ?? 0) +
          (prefs.getInt('cartThree$id') ?? 0) +
          (prefs.getInt('cartFour$id') ?? 0);
      prefs.setInt('main$id', _mainCounter);
    });
  }

  _incrementCart(String key, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      switch (key) {
        case 'cartOne':
          _cartOne = (prefs.getInt('$key$id') ?? 0) + 1;
          prefs.setInt('$key$id', _cartOne);
          break;
        case 'cartTwo':
          _cartTwo = (prefs.getInt('$key$id') ?? 0) + 1;
          prefs.setInt('$key$id', _cartTwo);
          break;
        case 'cartThree':
          _cartThree = (prefs.getInt('$key$id') ?? 0) + 1;
          prefs.setInt('$key$id', _cartThree);
          break;
        case 'cartFour':
          _cartFour = (prefs.getInt('$key$id') ?? 0) + 1;
          prefs.setInt('$key$id', _cartFour);
          break;
      }
    });
  }

  _decrementCart(String key, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      switch (key) {
        case 'cartOne':
          _cartOne = (prefs.getInt('$key$id') ?? 0) - 1;
          prefs.setInt('$key$id', _cartOne);
          break;
        case 'cartTwo':
          _cartTwo = (prefs.getInt('$key$id') ?? 0) - 1;
          prefs.setInt('$key$id', _cartTwo);
          break;
        case 'cartThree':
          _cartThree = (prefs.getInt('$key$id') ?? 0) - 1;
          prefs.setInt('$key$id', _cartThree);
          break;
        case 'cartFour':
          _cartFour = (prefs.getInt('$key$id') ?? 0) - 1;
          prefs.setInt('$key$id', _cartFour);
          break;
      }
    });
  }

  _clearCart(String key, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      switch(key) {
        case 'cartOne':
          prefs.setInt('$key$id', 0);
          _loadData(id);
          break;
        case 'cartTwo':
          prefs.setInt('$key$id', 0);
          _loadData(id);
          break;
        case 'cartThree':
          prefs.setInt('$key$id', 0);
          _loadData(id);
          break;
        case 'cartFour':
          prefs.setInt('$key$id', 0);
          _loadData(id);
          break;
      }
    });
  }

  _clearAll(int id) async {
    _clearCart('cartOne', id);
    _clearCart('cartTwo', id);
    _clearCart('cartThree', id);
    _clearCart('cartFour', id);
  }

  @override
  Widget build(BuildContext context) {
    int driverNum = widget.driverNum;

    Widget textSection1 = Container (
      child: Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(''),
          Text(
            'Driver $driverNum',
            style: Theme.of(context).textTheme.display1,
          ),
          Text(''),
        ],
      ),
    );

    Widget textSection2 = Container (
      child: Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(''),
          Text(''),
          Text(''),
          Text(
            'Cart 1',
            style: Theme.of(context).textTheme.title,
          ),
          Text(''),
        ],
      ),
    );

    Widget textSection3 = Container (
      child: Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(''),
          Text(''),
          Text(
            'Cart 2',
            style: Theme.of(context).textTheme.title,
          ),
          Text(''),
        ],
      ),
    );

    Widget textSection4 = Container (
      child: Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '',
            style: Theme.of(context).textTheme.title,
          ),
          Text(
            'Cart 3',
            style: Theme.of(context).textTheme.title,
          ),
          Text(''),
        ],
      ),
    );

    Widget textSection5 = Container (
      child: Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '',
            style: Theme.of(context).textTheme.title,
          ),
          Text(
            'Cart 4',
            style: Theme.of(context).textTheme.title,
          ),
          Text(''),
        ],
      ),
    );

    Widget buttonSection1 = Container (
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              setState(() {
                _clearAll(driverNum);
                _updateMainCount(driverNum);
              });
            },
            child: Text(
                '$_mainCounter',
                style: Theme.of(context).textTheme.display4
            ),
          )
        ],
      ),
    );

    Widget buttonSection2 = Container (
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_left),
            iconSize: 100,
            onPressed: () {
              setState(() {
                if (_cartOne > 0) {
                  _decrementCart('cartOne', driverNum);
                  _updateMainCount(driverNum);
                }
              });
            },
          ),
          FlatButton(
            onPressed: () {
              setState(() {
                if (_cartOne != 0) {
                  _clearCart('cartOne', driverNum);
                  _updateMainCount(driverNum);
                }
              });
            },
            child: new Text(
                '$_cartOne',
                style: Theme.of(context).textTheme.display3
            )
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            iconSize: 100,
            onPressed: () {
              setState(() {
                if (_cartOne < 50) {
                  _incrementCart('cartOne', driverNum);
                  _updateMainCount(driverNum);
                }
              });
            },
          ),
        ],
      ),
    );

    Widget buttonSection3 = Container (
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_left),
            iconSize: 100,
            onPressed: () {
              setState(() {
                if (_cartTwo > 0) {
                  _decrementCart('cartTwo', driverNum);
                  _updateMainCount(driverNum);
                }
              });
            },
          ),
          FlatButton(
            onPressed: () {
              setState(() {
                if (_cartTwo != 0) {
                  _clearCart('cartTwo', driverNum);
                  _updateMainCount(driverNum);
                }
              });
            },
            child: new Text(
                '$_cartTwo',
                style: Theme.of(context).textTheme.display3),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            iconSize: 100,
            onPressed: () {
              setState(() {
                if (_cartTwo < 50) {
                  _incrementCart('cartTwo', driverNum);
                  _updateMainCount(driverNum);
                }
              });
            },
          ),
        ],
      ),
    );

    Widget buttonSection4 = Container (
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_left),
            iconSize: 100,
            onPressed: () {
              setState(() {
                if (_cartThree > 0) {
                  _decrementCart('cartThree', driverNum);
                  _updateMainCount(driverNum);
                }
              });
            },
          ),
          FlatButton(
            onPressed: () {
              setState(() {
                if (_cartThree != 0) {
                  _clearCart('cartThree', driverNum);
                  _updateMainCount(driverNum);
                }
              });
            },
            child: new Text(
                '$_cartThree',
                style: Theme.of(context).textTheme.display3),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            iconSize: 100,
            onPressed: () {
              setState(() {
                if (_cartThree < 50) {
                  _incrementCart('cartThree', driverNum);
                  _updateMainCount(driverNum);
                }
              });
            },
          ),
        ],
      ),
    );

    Widget buttonSection5 = Container (
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_left),
            iconSize: 100,
            onPressed: () {
              setState(() {
                if (_cartFour > 0) {
                  _decrementCart('cartFour', driverNum);
                  _updateMainCount(driverNum);
                }
              });
            },
          ),
          FlatButton(
            onPressed: () {
              setState(() {
                if (_cartFour != 0) {
                  _clearCart('cartFour', driverNum);
                  _updateMainCount(driverNum);
                }
              });
            },
            child: new Text(
                '$_cartFour',
                style: Theme.of(context).textTheme.display3),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            iconSize: 100,
            onPressed: () {
              setState(() {
                if (_cartFour < 50) {
                  _incrementCart('cartFour', driverNum);
                  _updateMainCount(driverNum);
                }
              });
            },
          ),
        ],
      ),
    );

    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          textSection1,
          buttonSection1,
          textSection2,
          buttonSection2,
          textSection3,
          buttonSection3,
          textSection4,
          buttonSection4,
          textSection5,
          buttonSection5
        ]
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            int newDriver = driverNum + 1;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BagCounter(driverNum: newDriver)
                )
            );
          },
          tooltip: 'Add another driver',
          child: Icon(Icons.add)
      )
    );
  }
}