import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'Dialer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class Directory extends StatefulWidget {
  DirectoryState createState() => DirectoryState();
}

class DirectoryState extends State<Directory> {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  ListModel<Shopper> _list;
  Shopper _selectedItem;
  int _listCounter;
  List<Shopper> _cachedData = [];
  final String dataStoreKey = 'wJHBJmJaQTvPYjA3FT2';

  // controllers for TextFields
  final _nameController = TextEditingController();
  final _numController = TextEditingController();
  final nameFocusNode = FocusNode();
  final numFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    
    // load data from cache
    _loadCounter();
    _loadList();
  }

  @override
  void deactivate() {
    super.deactivate();

    // save data to cache
    _saveCounter();
    _saveList();
  }

  // load data from cache
  _loadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // decode data from cache
    List<Shopper> tempList = [];
    json
        .decode((prefs.getString('cachedData$dataStoreKey')) ?? [])
        .forEach((map) => tempList.add(new Shopper.fromJson(map)));

    setState(() {
      // assign tempList to global list
      if(_cachedData.isEmpty) {
        _cachedData = tempList;
      }

      // initialize list
      _list = ListModel<Shopper>(
        listKey: _listKey,
        initialItems: _cachedData,
        removedItemBuilder: _buildRemovedItem
      );
    });
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _listCounter = (prefs.getInt('listCounter$dataStoreKey') ?? 0);
    });
  }

  // save data to cache
  _saveCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('listCounter$dataStoreKey', _listCounter);
  }

  // save list to cache
  _saveList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cachedData$dataStoreKey', jsonEncode(_list._items));
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return Dismissible(
        key: Key(_list[index].toString()),
        onDismissed: (direction) {
          _selectedItem = _list[index];
          _showSnackBar(_selectedItem.name, _selectedItem.id.toString(), 'remove');
          _remove();
        },
        child: CardItem(
          animation: animation,
          item: _list[index],
          selected: _selectedItem == _list[index],
          onTap: () {
            setState(() {
              _selectedItem = _selectedItem == _list[index] ? null : _list[index];
            });
          },
        )
    );
  }

  // Used to build an item after it has been removed from the list. This method is
  // needed because a removed item remains visible until its animation has
  // completed (even though it's gone as far as this ListModel is concerned).
  // The widget will be used by the [AnimatedListState.removeItem] method's
  // [AnimatedListRemovedItemBuilder] parameter.
  Widget _buildRemovedItem(
      Shopper item, BuildContext context, Animation<double> animation) {
//    return CardItem(
//      animation: animation,
//      item: item,
//      selected: false
//      // No gesture detector here: we don't want removed items to be interactive.
//    );
  }

  // Insert the "next item" into the list model.
  _insert(String name, int id) {

    // create new Shopper object
    Shopper newShopper = Shopper(_listCounter, name, id);

    // insert into list
    _list.insert(_listCounter, newShopper);

    // increment counter
    setState(() {
      _listCounter++;
    });
  }

  // Remove the selected item from the list model.
  _remove() {
    if (_selectedItem != null && _listCounter > 0) {
      _list.removeAt(_list.indexOf(_selectedItem));
      setState(() {
        _selectedItem = null;
        _listCounter--;
      });
    }

    // if nothing is selected, remove the last entry
    else if (_selectedItem == null && _listCounter > 0) {
      _list.removeAt(_listCounter - 1);
      setState((){
        _listCounter--;
      });
    }
  }

  _addShopper() {
    _getShopperData();
  }

  _callShopper() {
    if (_selectedItem != null) {

      // show SnackBar notification
      String name = _selectedItem.name;
      String num = _selectedItem.id.toString();
      _showSnackBar(_selectedItem.name, _selectedItem.id.toString(), 'call');

      // create a caller object and init call
      DialerState caller = DialerState();
      caller.initCall(_selectedItem._id);

      // reset selectedItem
      setState(() {
        _selectedItem = null;
      });
    }
  }

  // removes all entries from the list model
  _clearAll() {

    // dismisses confirm dialog alert view
    Navigator.of(context).pop();

    // loop through list and removes entries
    final tempLength = _list.length;
    for (int i = 0; i < tempLength; i++) {
      _remove();
    }

    // clears items list from list model; sets length to 0
    _list._items.clear();

    // resets nextItem counter back to 0
    _listCounter = 0;
  }

  // confirms with user before clearing entire list
  _confirmClear() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('WARNING !!'),
          content: Text('Are you sure you want to delete ALL entries from the list?'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text('No'),
              onPressed: _dismissView
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: _clearAll
            )
          ],
        );
      },
    );
  }

  // Prompt user for shopper data (name and device id)
  _getShopperData() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: TextFormField(
            decoration: InputDecoration(hintText: 'Name'),
            controller: _nameController,
            focusNode: nameFocusNode,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(numFocusNode);
            },
          ),
          content: TextFormField(
            decoration: InputDecoration(hintText: 'Device Number'),
            controller: _numController,
            focusNode: numFocusNode,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.number,
            onFieldSubmitted: (value) {
              if (_insertUserData()) {
                _showSnackBar(_nameController.text, _numController.text, 'add');
                _dismissView();
              }
              else {
                _dismissView();
                _showSnackBar(null, null, null);
              }
            },
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text('Close'),
              onPressed: _dismissView
            ),
            FlatButton(
              child: Text('Add'),
              onPressed: () {
                if (_insertUserData()) {
                  _showSnackBar(_nameController.text, _numController.text, 'add');
                  _dismissView();
                }
                else {
                  _dismissView();
                  _showSnackBar(null, null, null);
                }
              }
            )
          ],
        );
      },
    );

    // make first field focus
    FocusScope.of(context).requestFocus(nameFocusNode);
  }

  /// helper function to show SnackBar notification
  _showSnackBar(String name, String num, String type) {
    SnackBar snackBar;

    switch (type) {
      case 'call':
        snackBar = SnackBar(
          content: Text('Calling $name #$num ....'),
          duration: Duration(seconds: 1, milliseconds: 500)
        );
        break;
      case 'add':
        snackBar = SnackBar(
          content: Text('$name #$num added'),
          duration: Duration(seconds: 2, milliseconds: 500)
        );
        break;
      case 'remove':
        snackBar = SnackBar(
          content: Text('$name #$num removed'),
          duration: Duration(seconds: 2, milliseconds: 500)
        );
        break;
      default:
        snackBar = SnackBar(
          content: Text('An error had occured. Try again.'),
          duration: Duration(seconds: 1, milliseconds: 500)
        );
    }

    scaffoldState.currentState.showSnackBar(snackBar);
  }

  /// helper function for _getShopperData()
  // insert user data and clear fields
  bool _insertUserData() {
    int deviceNum = int.tryParse(_numController.text.toString());
    if (deviceNum == null) {
      return false;
    }
    else if (deviceNum > 1 && deviceNum < 46) {
      _insert(_nameController.text, deviceNum);
      return true;
    }
    return false;
  }

  /// helper function for dismissing view
  _dismissView() {
    Navigator.pop(context);
    _nameController.clear();
    _numController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      key: scaffoldState,
        appBar: AppBar(
          title: Text('Directory'),
          backgroundColor: Colors.indigo,
          actions: [
            IconButton(
                icon: Icon(Icons.person_add),
                onPressed: _addShopper,
                tooltip: 'Add a new shopper'
            ),
            IconButton(
                icon: Icon(Icons.clear_all),
                onPressed: () {
                  if (_list.length != 0) {
                    _confirmClear();
                  }
                },
                tooltip: 'Clear all shoppers'
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AnimatedList(
              key: _listKey,
              initialItemCount: _list.length,
              itemBuilder: _buildItem
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: _callShopper,
            tooltip: 'Call shopper',
            child: Icon(Icons.call)
        )
    );
  }
}


/// The following code is from flutter.io/docs/catalog/samples/animated-list

/* Copyright 2017 The Chromium Authors. All rights reserved.

 Keeps a Dart List in sync with an AnimatedList.

 The [insert] and [removeAt] methods apply to both the internal list and the
 animated list that belongs to [listKey].

 This class only exposes as much of the Dart List API as is needed by the
 sample app. More list methods are easily added, however methods that mutate the
 list must make the same changes to the animated list in terms of
 [AnimatedListState.insertItem] and [AnimatedList.removeItem].        */
class ListModel<E> {
  ListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    Iterable<E> initialItems,
  })  : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final dynamic removedItemBuilder;
  final List<E> _items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(index,
              (BuildContext context, Animation<double> animation) {
            return removedItemBuilder(removedItem, context, animation);
          });
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

/// Displays its Shopper item on a Card whose color is based on the item's
/// value. The text is displayed in boldface if an item is selected.
/// This widget's height is based on the animation parameter, it varies
/// from 0 to 128 as the animation varies from 0.0 to 1.0.
class CardItem extends StatelessWidget {
  const CardItem(
      {Key key,
        @required this.animation,
        this.onTap,
        @required this.item,
        this.selected: false})
      : assert(animation != null),
        assert(selected != null),
        super(key: key);

  final Animation<double> animation;
  final VoidCallback onTap;
  final Shopper item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.display1;

    if (selected) {
      textStyle = textStyle.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold
      );
    }
    else if (!selected) {
      textStyle = textStyle.copyWith(color: Colors.black);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            height: 72.0,
            child: Card(
              color: Colors.primaries[item.id % Colors.primaries.length],
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(item.name, style: textStyle)
                  ] // <Widget>
                ) // Row
              ) // Center
            ) // Card
          ) // SizedBox
        ) // GestureDetector
      ) // SizeTransition
    ); // Padding
  } // build(BuildContext context)
} // class CardItem

class Shopper {
  final int _key;
  final String _name;
  final int _id;


  /// constructor
  Shopper(this._key, this._name, this._id);


  /// getters
  int get key => _key;

  String get name => _name;

  int get id => _id;


  /// JSON serialization
  Shopper.fromJson(Map<String, dynamic> json)
    : _key = json['key'],
      _name = json['name'],
      _id = json['id'];

  Map<String, dynamic> toJson() => {
    'key': _key,
    'name': _name,
    'id': _id,
  };
}