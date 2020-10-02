import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  List data;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var res = await http
        .get("http://learnprogrammingfree.codingboy.in/resources/data.json");
    data = jsonDecode(res.body);
    // print(jsonData);
    isLoading = false;
    print(data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text("Learn Programming Free"),
          ),
          body: isLoading != true
              ? SingleChildScrollView(
                  child: Column(
                    children: data.map((item) {
                      return Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          
                          child: Column(
                            children: [
                              Text(
                                "${item['name']}",
                                style: TextStyle(fontSize: 24),
                                textAlign: TextAlign.start,
                              ),
                              Padding(padding: EdgeInsets.all(10)),
                              Image.network(item['image']),
                              Text("${item['description']}"),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        ));
  }
}
