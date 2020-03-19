import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sid_hymnal/main.dart';
import 'package:sid_hymnal/models/theme_changer.dart';
import 'package:sid_hymnal/screens/ios/view_hymn.dart';

class HymnSearch extends StatefulWidget {
  @override
  _HymnSearchState createState() => _HymnSearchState();
}

class _HymnSearchState extends State<HymnSearch> {
  bool isLoading = true;
  String filter;
  TextEditingController searchTextController = new TextEditingController();

  _selfInit() async {
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    searchTextController.addListener(() {
      setState(() {
        filter = searchTextController.text;
      });
    });
    _selfInit();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);

    return Theme(
        data: theme.getTheme(),
        child: Container(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: isLoading
                ? Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(child: appLayoutMode == "ios" ? CupertinoActivityIndicator() : CircularProgressIndicator()),
                  )
                : Column(
                    children: <Widget>[
                      appLayoutMode == "ios" ? SizedBox(height: 16) : Container(),
                      appLayoutMode == "ios"
                          ? CupertinoTextField(
                              controller: searchTextController,
                              autofocus: false,
                              placeholder: "Search Hymn...",
                              clearButtonMode: OverlayVisibilityMode.editing,
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextField(
                                  controller: searchTextController,
                                  autofocus: true,
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    hintText: 'Search Hymn...',
                                  ),
                                ),
                              ],
                            ),
                      new Expanded(
                        child: new ListView.builder(
                          itemCount: hymnList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return filter == null || filter == ""
                                ? ListTile(
                                    title: Text(
                                      hymnList[index],
                                    ),
                                    trailing: cIStoAH["${(index + 1)}"] != null ? Text("AH " + cIStoAH["${(index + 1)}"], style: TextStyle(fontSize: 10, color: Colors.grey)) : null,
                                    onTap: () async {
                                      if (appLayoutMode == "ios") {
                                        launchIOSHymnView(index + 1);
                                        return;
                                      } else {
                                        Navigator.pop(context, index + 1);
                                      }
                                    },
                                  )
                                : (cIStoAH["${(index + 1)}"] != null ? ("${hymnList[index]} (AH " + cIStoAH["${(index + 1)}"] + ")") : (hymnList[index]))
                                        .toLowerCase()
                                        .contains(filter.toLowerCase())
                                    ? ListTile(
                                        title: Text(
                                          hymnList[index],
                                        ),
                                        trailing: cIStoAH["${(index + 1)}"] != null ? Text("AH " + cIStoAH["${(index + 1)}"], style: TextStyle(fontSize: 10, color: Colors.grey)) : null,
                                        onTap: () {
                                          if (appLayoutMode == "ios") {
                                            launchIOSHymnView(index + 1);
                                            return;
                                          } else {
                                            Navigator.pop(context, index + 1);
                                          }
                                        })
                                    : new Container();
                          },
                        ),
                      )
                    ],
                  )));
  }

  launchIOSHymnView(int hymnNumber) async {
    Navigator.of(context).push(
      new CupertinoPageRoute<bool>(
        builder: (BuildContext context) => new ViewHymn(hymnNumber),
      ),
    );
  }
}
