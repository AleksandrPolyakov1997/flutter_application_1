import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

import 'package:http/http.dart' as http;

class ProductList {
  final String title;
  final String productDescription;
  final int price;
  final String imageUrl;

  const ProductList({
    required this.title,
    required this.productDescription,
    required this.price,
    required this.imageUrl,
  });
}

Future<List<ProductList>> productList(categoryId) async {
  final response1 = await http.get(Uri.parse('http://ostest.whitetigersoft.ru/api/common/product/list?categoryId=$categoryId&appKey=phynMLgDkiG06cECKA3LJATNiUZ1ijs-eNhTf0IGq4mSpJF3bD42MjPUjWwj7sqLuPy4_nBCOyX3-fRiUl6rnoCjQ0vYyKb-LR03x9kYGq53IBQ5SrN8G1jSQjUDplXF'));
  final json1 = jsonDecode(response1.body) as Map<String, dynamic>;
  final product1 = json1['data'];
  final productList = product1.map<ProductList>((e) => ProductList(
    title: e['title'], 
    productDescription: (e['productDescription'] == null)? 'пусто' : e['productDescription'], 
    price: e['price'], 
    imageUrl: e['imageUrl']
    )).toList();
    debugPrint('$categoryId');
  return productList;
}



class ProductListPage extends StatefulWidget{

const ProductListPage({super.key, required this.category});

  final Category category;
  

@override
  State<ProductListPage> createState() =>_ProductListPageState();

}

class _ProductListPageState extends State<ProductListPage> {
  late Category _category;
   List<ProductList>? _productList;
 @override
void initState() {
   _category = widget.category;
    super.initState();
  loadProductList();
}

Future<void> loadProductList() async {
   _productList = await productList(_category.categoryId);
  setState(() {});
}


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_category.title),
      ),
      body: ListView.builder(
        itemCount: _productList!.length,
        itemBuilder: (context, index){
          final productList = _productList![index];
          return ListTile(
            title: Text(productList.title),
            subtitle: Text(productList.productDescription),
            leading: Image.network(productList.imageUrl),
          );
        }),
    );
  }
}