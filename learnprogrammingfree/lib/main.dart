import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
    // print(data);
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: data.map((item) {
                      return Container(
                          padding: EdgeInsets.all(10),
                          child: Card(
                            elevation: 2,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text("${item['name']}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                                Image.network(
                                  item['image'],
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text(
                                    "${item['description']}",
                                    style: TextStyle(),
                                  ),
                                ),
                                getTags(item['tags']),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.link),
                                        onPressed: () {
                                          launchUrl(item['url']);
                                        })
                                  ],
                                )
                              ],
                            ),
                          ));
                    }).toList(),
                  ),
                )
              : Center(child: CircularProgressIndicator())),
    );
  }

  Widget getTags(list) {
    print(list);
    List tagsList = list;
    print(tagsList[0]);
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: tagsList.map(
          (i) {
            return Chip(
              backgroundColor: Colors.blue,
              label: Text(i, style: TextStyle(color: Colors.white)),
              padding: EdgeInsets.all(5),
            );
          },
        ).toList(),
      ),
    );
  }

  void launchUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
