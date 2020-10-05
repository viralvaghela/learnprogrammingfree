import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Search extends SearchDelegate {
  final List dataList;

  Search(this.dataList);

  @override
  ThemeData appBarTheme(BuildContext context) {
    var td = ThemeData(primaryColor: Colors.blue, hintColor: Colors.white,indicatorColor: Colors.white);
    // return super.appBarTheme(context);
    return td;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
            //Navigator.pop(context);
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var tempList;
    if (query.isEmpty) {
      tempList = dataList;
    } else {
      var instructorList = dataList
          .where((element) =>
              element['instructor'].toString().toLowerCase().contains(query))
          .toList();
      var tag_List = dataList
          .where((element) =>
              element['tags'].toString().toLowerCase().contains(query))
          .toList();

      if (tempList == null) tempList = new List();
      if (instructorList != null && instructorList.length >= 1) {
        for (int i = 0; i < instructorList.length; i++) {
          tempList.add(instructorList[i]);
        }
      }
      if (tag_List != null && tag_List.length >= 1) {
        for (int i = 0; i < tag_List.length; i++) {
          tempList.add(tag_List[i]);
        }
      }
    }

    final suggestionList =
        (tempList != null && tempList.length > 0) ? tempList : dataList;

    // print("\n\n ===> found " +
    //     suggestionList.length.toString() +
    //     suggestionList.toString());

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: suggestionList.map<Widget>((item) {
          return Container(
              padding: EdgeInsets.all(10),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0),),
                child: Column(
                  children: [
                    Wrap(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Container(
                                width:
                                    (MediaQuery.of(context).size.width - 20) *
                                        0.80,
                                child: Text(
                                  "${item['name']}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            )
                          ],
                        ),
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
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0)),
                              color: Colors.blueAccent.withOpacity(0.2)
                          ),
                          child: IconButton(
                              icon: Icon(Icons.link),
                              onPressed: () {
                                launchUrl(item['url']);
                              }),
                          width: 120,
                        )
                      ],
                    )
                  ],
                ),
              ));
        }).toList(),
      ),
    );
  }


  Widget getTags(list) {
    print(list);
    List tagsList = list;
    print(tagsList[0]);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: tagsList.map(
              (i) {
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: Chip(
                backgroundColor: Colors.deepPurpleAccent,labelPadding: EdgeInsets.symmetric(horizontal: 15),
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
