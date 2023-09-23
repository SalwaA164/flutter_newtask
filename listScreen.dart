// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_newtask/data/models/product_model.dart';
// ignore: unused_import
import 'package:flutter_newtask/screens/product_Screen.dart';
import "package:http/http.dart" as http;

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  Future<List<ProductData>> getData() async {
    List<ProductData> dataA = [];

    try {
      final res = await http.get(Uri.parse('https://dummyjson.com/products'));

      if (res.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(res.body);
        for (var item in responseData['products']) {
          dataA.add(ProductData.fromJson(item));
        }
      }
      return dataA;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return dataA;
    }
  }

  List<ProductData> myList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () async {
        var data = await getData();
        setState(() {
          myList = data;
          isLoading = false;
        });
      },
    );
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: myList.isEmpty
            ? const CircularProgressIndicator()
            : GridView.builder(
                itemCount: myList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductScreen(
                              datax: myList[index],
                            ),
                          ));
                    },
                    child: GridTile(
                      footer: Container(
                        color: Colors.white70,
                        child: ListTile(
                          leading: Text(
                            myList[index].name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          title: Text(
                            '\$${myList[index].price.toString()}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      child: Image.network(myList[index].image ?? ''),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
              ),
      ),
    );
  }
}
