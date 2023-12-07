import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/product.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Category {
  final String title;
  final String imgUrl;
  final int categoryId;

  const Category({
    required this.title,
    required this.imgUrl,
    required this.categoryId,
  });
  }

Future<List<Category>> categor() async {
  final response = await http.get(Uri.parse(
    'http://ostest.whitetigersoft.ru/api/common/category/list?appKey=phynMLgDkiG06cECKA3LJATNiUZ1ijs-eNhTf0IGq4mSpJF3bD42MjPUjWwj7sqLuPy4_nBCOyX3-fRiUl6rnoCjQ0vYyKb-LR03x9kYGq53IBQ5SrN8G1jSQjUDplXF'));

  final json = jsonDecode(response.body) as Map<String, dynamic>;
  final catergory = json['data']['categories'];
  final categoryList = catergory.map<Category>((e) => Category(
    title: e['title'], 
    imgUrl: e['imageUrl'],
    categoryId: e['categoryId'],
    )).toList();
  return categoryList;
 }


class _MyHomePageState extends State<MyHomePage> {

List<Category>? _categorList;

 @override
void initState() {
  loadCategory();
  super.initState();
}

Future<void> loadCategory() async {
   _categorList = await categor();
  setState(() {});
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: (_categorList == null) 
      ? const Center(child: CircularProgressIndicator())
      : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          ), 
          itemCount: _categorList!.length,
          itemBuilder: (context, index) {
            final category = _categorList![index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) =>  ProductListPage(category: category)
                    )
                  );

              },
              child: GridTile(
              header: Text(category.title),
              child: Image.network(
                category.imgUrl,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                ),
              ),
            );
        }),
    );
  }
}


