import 'dart:convert';
import 'dart:io';
import 'dart:ui';
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
      home: WillPopScope(
        // ignore: missing_return
        onWillPop: (){
          showModalBottomSheet(context: context, builder: (context){
            return Container(
              decoration: BoxDecoration(
                  color: Colors.transparent
              ),
              height: 100,
              width: double.infinity,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5,sigmaY: 5),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)
                      ),
                      color: Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 20, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text("Do you really want to exit?",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              decoration: TextDecoration.none
                          ),
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            SizedBox(width: 5,),
                            FlatButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              color: Colors.black,
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    letterSpacing: 1
                                ),
                              ),
                            ),
                            SizedBox(width: 25,),
                            FlatButton(
                              onPressed: (){
                                exit(0);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              color: Colors.white30,
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 1,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          } );
        },
        child: Scaffold(
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
      )
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
