import 'package:flutter/material.dart';

//Laboratory exercise 2
//Name and surname: Teodor Petrovski
//Index: 201128

void main() {
  runApp(const MyApp());
}

class Clothes {
  String name;
  String imageUrl;

  Clothes(this.name, this.imageUrl);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clothes List App',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xffc9eafc),
          useMaterial3: true),
      home: const MyHomePage(title: "Clothes List App"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Clothes> clothesList = [];
  List<Clothes> userBasket = [];

  TextEditingController _nameController = TextEditingController();
  TextEditingController _urlController = TextEditingController();

  // Function to add clothes
  void _addClothes() {
    setState(() {
      String newClothesName = _nameController.text;
      String imageUrl = _urlController.text;

      if (newClothesName.isNotEmpty && imageUrl.isNotEmpty) {
        clothesList.add(Clothes(newClothesName, imageUrl));
        _nameController.clear();
        _urlController.clear();
      }
    });
  }

  // Function to delete clothes
  void _deleteClothes(int index) {
    setState(() {
      clothesList.removeAt(index);
    });
  }

  // Function to edit clothes
  void _editClothes(int index) {
    _nameController.text = clothesList[index].name;
    _urlController.text = clothesList[index].imageUrl;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Clothes'),
          content: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Enter new name'),
              ),
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(hintText: 'Enter new image URL'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  String newName = _nameController.text;
                  String newImageUrl = _urlController.text;

                  if (newName.isNotEmpty && newImageUrl.isNotEmpty) {
                    clothesList[index].name = newName;
                    clothesList[index].imageUrl = newImageUrl;
                  }
                  Navigator.pop(context);
                });
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  // Function to add clothes to the user basket
  void _addToBasket(int index) {
    setState(() {
      userBasket.add(clothesList[index]);
    });
  }

  // Function to delete clothes from the user basket
  void _deleteFromBasket(int index) {
    setState(() {
      userBasket.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff4fb2ec),
        title: const Text(
          'Clothes List',
          style: TextStyle(
              color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_basket),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BasketPage(userBasket, _deleteFromBasket),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Text(
            'Select clothes to add to basket:',
            style: TextStyle(
                color: Colors.blue, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: clothesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    clothesList[index].name,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  leading: Image.network(
                    clothesList[index].imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.green),
                        onPressed: () => _editClothes(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.green),
                        onPressed: () => _deleteClothes(index),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.add_shopping_cart, color: Colors.green),
                        onPressed: () => _addToBasket(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add Clothes'),
                content: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(hintText: 'Enter name'),
                    ),
                    TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(hintText: 'Enter image URL'),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _addClothes();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.green,
        ),
      ),
    );
  }
}

class BasketPage extends StatelessWidget {
  final List<Clothes> userBasket;
  final Function(int) onDelete;

  BasketPage(this.userBasket, this.onDelete);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff4fb2ec),
        title: const Text(
          'My Shopping Basket',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: userBasket.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(userBasket[index].name),
            leading: Image.network(
              userBasket[index].imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                onDelete(index);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('${userBasket[index].name} removed from basket'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
