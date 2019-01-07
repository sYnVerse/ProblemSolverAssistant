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
    return CardItem(
      animation: animation,
      item: _list[index],
      selected: _selectedItem == _list[index],
      onTap: () {
        setState(() {
          _selectedItem = _selectedItem == _list[index] ? null : _list[index];
        });
      },
    );
  }

  // Used to build an item after it has been removed from the list. This method is
  // needed because a removed item remains  visible until its animation has
  // completed (even though it's gone as far this ListModel is concerned).
  // The widget will be used by the [AnimatedListState.removeItem] method's
  // [AnimatedListRemovedItemBuilder] parameter.
  Widget _buildRemovedItem(
      Shopper item, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: item,
      selected: false,
      // No gesture detector here: we don't want removed items to be interactive.
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text('PSAT: Directory'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
              icon: Icon(Icons.clear),
              onPressed: _remove,
              tooltip: 'Remove shopper'
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
          itemBuilder: _buildItem,
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _addShopper,
          tooltip: 'Add a new shopper',
          child: Icon(Icons.person_add, color: Colors.white)
      )
    );
  }

  _addShopper() {
    if (_selectedItem == null) {
      _getShopperData();
      FocusScope.of(context).requestFocus(nameFocusNode);
    }
    else if (_selectedItem != null) {
      DialerState caller = DialerState();
      caller.initCall(_selectedItem._id);
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
              _insertUserData();
              _dismissView();
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
                _insertUserData();
                _dismissView();
              }
            )
          ],
        );
      },
    );

    // make first field focus
    FocusScope.of(context).requestFocus(nameFocusNode);
  }

  /// helper function for _getShopperData()
  // insert user data and clear fields
  _insertUserData() {
    int deviceNum = int.tryParse(_numController.text.toString());
    _insert(_nameController.text, deviceNum);
    _nameController.clear();
    _numController.clear();
  }

  /// helper function for dismissing view
  _dismissView() {
    Navigator.pop(context);
    _nameController.clear();
    _numController.clear();
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

/// Displays its integer item as 'item N' on a Card whose color is based on
/// the item's value. The text is displayed in bright green if selected is true.
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
    if (selected)
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
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
                  ]
                )
              )
            )
          )
        )
      )
    );
  }
}

class Shopper {
  String _name;
  int _id;
  int _key;

  // default constructor
  Shopper(int key, String name, int id) {
    _name = name;
    _id = id;
    _key = key;
  }


  Shopper.fromJson(Map<String, dynamic> m) {
    _key = m['key'];
    _name = m['name'];
    _id = m['id'];
  }

  int get id => _id;

  String get name => _name;

  int get key => _key;

  Map<String, dynamic> toJson() => {
    'key': _key,
    'name': _name,
    'id': _id,
  };
}