import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widget/new_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList>
    with SingleTickerProviderStateMixin {
  List<GroceryItem> _groceryItems = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _loadItems();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadItems() async {
    final url = Uri.https(
        'backend1-ef89c-default-rtdb.firebaseio.com', 'shopping_list.json');

    final response = await http.get(url);
    final Map<String,dynamic> listData =
        json.decode(response.body);
    final List<GroceryItem> _loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries.firstWhere(
          (catItem) => catItem.value.title == item.value['category']).value;
      _loadedItems.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category));
    }
    setState(() {
      _groceryItems=_loadedItems;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.push<GroceryItem>(
      context,
      MaterialPageRoute(builder: (ctx) => const NewItem()),
    );

    _loadItems();
  }

  void _removeItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_groceryItems.isEmpty) {
      content = SizedBox(
        width: 400,
        height: 30,
        child: AlignTransition(
          alignment: Tween<Alignment>(
            begin: Alignment.centerRight,
            end: Alignment.center,
          ).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Curves.bounceIn,
            ),
          ),
          child: Text(
            'NO ITEMS HERE YET',
          ),
        ),
      );
    } else {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10),
              color: Colors.black45,
            ),
            child: Dismissible(
              onDismissed: (direction) => _removeItem(_groceryItems[index]),
              key: ValueKey(_groceryItems[index].id),
              child: ListTile(
                title: Center(child: Text(_groceryItems[index].name)),
                leading: Container(
                  height: 24,
                  width: 24,
                  color: _groceryItems[index].category.color,
                ),
                trailing: Text(
                  _groceryItems[index].quantity.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 540,
            width: 280,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 7, 37, 0),
                  Color.fromARGB(255, 2, 66, 2),
                  Color.fromARGB(255, 3, 80, 10),
                  Color.fromARGB(255, 15, 102, 7),
                  Color.fromARGB(255, 58, 134, 14),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                AppBar(
                  title: const Text('YOUR GROCERIES'),
                  backgroundColor: const Color.fromARGB(255, 56, 2, 2),
                  actions: [
                    Hero(
                      tag: "1",
                      child: IconButton(
                        onPressed: _addItem,
                        icon: const Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
                Expanded(child: content),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
