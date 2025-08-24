import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widget/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}



class _GroceryListState extends State<GroceryList> {

  final List<GroceryItem> _groceryItems=[];







  void _addItem() async{
   final newItem= await Navigator.push<GroceryItem>(
        context, MaterialPageRoute(builder: (ctx) => const NewItem()));
         if(newItem==null)
                 { return;}

        setState(() {
          _groceryItems.add(newItem);
        });
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 540,
            width: 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 7, 37, 0),
                Color.fromARGB(255, 2, 66, 2),
                Color.fromARGB(255, 3, 80, 10),
                Color.fromARGB(255, 15, 102, 7),
                Color.fromARGB(255, 58, 134, 14),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            child: Column(
              children: [
                AppBar(
                  title: const Text('YOUR GROCERIES'),
                  backgroundColor: const Color.fromARGB(255, 56, 2, 2),
                  actions: [
                    IconButton(
                      onPressed: () {
                        _addItem();
                      },
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        
                        Expanded(
                            child: ListView.builder(
                          itemCount: _groceryItems.length,
                          itemBuilder: (ctx, index) => 
                          
                          Padding(
                            padding: EdgeInsetsGeometry.all(3),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black45
                              ),
                              child:
                               ListTile(
                                title: Text(_groceryItems[index].name),
                                leading: Container(
                                  height: 24,
                                  width: 24,
                                  color: _groceryItems[index].category.color,
                                ),
                                trailing:
                                    Text(_groceryItems[index].quantity.toString()),
                              ),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
