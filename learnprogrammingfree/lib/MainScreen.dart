import 'dart:convert';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:learnprogrammingfree/Models/Materials_Data.dart';
import 'package:learnprogrammingfree/utils/searchHelper.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List data;

  Future<List<MaterialData>> fetchRecord() async {
    var response = await http
        .get("http://learnprogrammingfree.codingboy.in/resources/data.json");
    data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<MaterialData> records = items.map<MaterialData>((json) {
        return MaterialData.fromJson(json);
      }).toList();
      return records;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height * 1.05,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://img.rawpixel.com/s3fs-private/rawpixel_images/website_content/v311-ning-03-christmaspatterns_2.jpg?bg=transparent&con=3&cs=srgb&dpr=1&fm=jpg&ixlib=php-3.1.0&q=80&usm=15&vib=3&w=1300&s=c2bd81818b67372ded46e12811b15d9c"),
              fit: BoxFit.cover,
              alignment: AlignmentDirectional.topCenter,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
                gradient: new LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.blueGrey.withOpacity(0.3)],
            )),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  height: height * 0.4,
                  padding: EdgeInsets.only(top: 40, right: 10, left: 10),
                  //color: Colors.greenAccent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome to",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "Learn\nProgramming",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 38,
                              fontWeight: FontWeight.w900),
                        ),
                        GestureDetector(
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                  color: Colors.white),
                              alignment: Alignment.center,
                              height: 50,
                              margin: EdgeInsets.only(top: 25),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Search",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black54),
                                    ),
                                    Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              )
                              // FlatButton.icon(onPressed: () => showSearch(context: context, delegate: Search(data)),
                              //     icon: Icon(Icons.search), label: Text("Search"))
                              ),
                          onTap: () => showSearch(
                              context: context, delegate: Search(data)),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  "Free Courses for you:",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.deepPurpleAccent),
                ),
                Container(
                  width: double.infinity,
                  height: height * 0.6 - 20,
                  child: FutureBuilder<List<MaterialData>>(
                      future: fetchRecord(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                              child: Center(
                            child:CircularProgressIndicator()
                          ));

                        return snapshot.data.length > 0
                            ? ListView(
                                scrollDirection: Axis.horizontal,
                                children: snapshot.data.map((item) {
                                  return Container(
                                      padding: EdgeInsets.only(
                                          top: 05, left: 25, right: 25),
                                      width: width,
                                      child: Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Wrap(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10, bottom: 10),
                                                  child: Text(
                                                    "${item.name}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Image.network(
                                                item.image,
                                                fit: BoxFit.contain,
                                                height: height * 0.2,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  20, 10, 20, 10),
                                              child: Text("${item.description}",
                                                  style: TextStyle(),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            getTags(item.tags),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      25.0),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                      25.0)),
                                                      color: Colors.blueAccent
                                                          .withOpacity(0.2)),
                                                  child: IconButton(
                                                      icon: Icon(Icons.link),
                                                      onPressed: () {
                                                        launchUrl(item.url);
                                                      }),
                                                  width: 120,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ));
                                }).toList(),
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getTags(list) {
    //print(list);
    List tagsList = list;
    //print(tagsList[0]);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: tagsList.map(
          (i) {
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: Chip(
                backgroundColor: Colors.deepPurpleAccent,
                labelPadding: EdgeInsets.symmetric(horizontal: 15),
                label: Text(i, style: TextStyle(color: Colors.white)),
                padding: EdgeInsets.all(5),
              ),
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
