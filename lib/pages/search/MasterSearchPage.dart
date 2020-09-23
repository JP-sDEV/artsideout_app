// Misc
import 'package:artsideout_app/components/NoResultBanner.dart';
import 'package:artsideout_app/components/search/SearchBarFilter.dart';
import 'package:artsideout_app/pages/art/ArtDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// Common
import 'package:artsideout_app/components/PageHeader.dart';
import 'package:artsideout_app/components/common.dart';
// GraphQL
// Art
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:artsideout_app/components/art/ArtCard.dart';
import 'package:artsideout_app/components/art/ArtDetailWidget.dart';
// Activity
import 'package:artsideout_app/components/activitycard.dart';
import 'package:artsideout_app/pages/activity/ActivityDetailPage.dart';
import 'package:artsideout_app/components/activity/ActivityDetailWidget.dart';
// Profile
import 'package:artsideout_app/components/profile/profileCard.dart';
import 'package:artsideout_app/pages/profile/ProfileDetailPage.dart';
// Search
import 'package:artsideout_app/components/search/FetchSearchQueries.dart';
import 'package:artsideout_app/components/search/ResultsBox.dart';

class MasterSearchPage extends StatefulWidget {
  @override
  _MasterSearchPageState createState() => _MasterSearchPageState();
}

class _MasterSearchPageState extends State<MasterSearchPage> {
  int secondFlexSize = 1;
  int numCards = 2, numActivityCards = 2;
  bool isLargeScreen = false;
  bool isMediumScreen = false;
  bool noResults = false;
  Widget selectedItem;
  String queryResult = "";

  Map<String, bool> optionsMap = {
    "Music": true,
    "Spoken Word": true,
    "Theatre": true,
    "Sculpture": true,
    "DigitalMedia": true,
    "MixMedia": true,
    "DrawingsAndPaintings": true,
    "Artist": true,
    "Organizer": true,
    "Sponsor": true,
    "Other": true,
  };

  List<dynamic> listResults = List<dynamic>();
  FetchResults fetchResults = new FetchResults();

  void handleTextChange(String text) async {
    if (text != ' ' && text != '') {
      setState(() {
        selectedItem = null;
        queryResult = text;
      });

      listResults = await fetchResults.getResults(text, optionsMap);
      setState(() {
        noResults = listResults.isEmpty;
      });
    }
  }

  String getThumbnail(String videoURL) {
    return YoutubePlayerController.getThumbnail(
        videoId: YoutubePlayerController.convertUrlToId(videoURL));
  }

  Widget getCard(String type, int index) {
    switch (type) {
      case "Installation":
        {
          var item = listResults[index];
          return GestureDetector(
            child: ArtListCard(
              title: item.title,
              artist: item.zone,
              image: item.videoURL == 'empty'
                  ? item.imgURL.length == 0
                      ? ['https://via.placeholder.com/350']
                      : item.imgURL
                  : [getThumbnail(item.videoURL)],
            ),
            onTap: () {
              setState(() {
                if (isLargeScreen || isMediumScreen) {
                  selectedItem = ArtDetailWidget(data: item);
                } else {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return ArtDetailPage(item);
                      },
                    ),
                  );
                }
              });
            },
          );
        }
        break;
      case "Activity":
        {
          var item = listResults[index];
          return GestureDetector(
            child: ActivityCard(
              title: item.title,
              desc: item.desc,
              image: item.imgUrl,
              time: item.time,
              zone: item.zone,
              detailPageButton: InkWell(
                splashColor: Colors.grey[200].withOpacity(0.25),
                onTap: () {
                  if (isLargeScreen || isMediumScreen) {
                    setState(() {
                      selectedItem = ActivityDetailWidget(item);
                    });
                  } else {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) {
                          return ActivityDetailPage(item);
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            onTap: () {},
          );
        }
        break;
      case "Profile":
        {
          var item = listResults[index];
          return GestureDetector(
            child: ProfileCard(
              name: item.name,
              desc: item.desc,
              profileType: item.type,
              socials: item.social,
            ),
            onTap: () {
              setState(() {
                if (isLargeScreen || isMediumScreen) {
                  selectedItem = ProfileDetailPage(item);
                } else {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return ProfileDetailPage(item);
                      },
                    ),
                  );
                }
              });
            },
          );
        }
        break;
      default:
        {
          return Container();
        }
        break;
    }
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Container(
        height: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            SearchBarFilter(
                handleTextChange: handleTextChange, optionsMap: optionsMap),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        // Desktop Size
        if (MediaQuery.of(context).size.width > 1200) {
          secondFlexSize = 6;
          isLargeScreen = true;
          numCards = 5;
          // Tablet Size
        } else if (MediaQuery.of(context).size.width > 600) {
          secondFlexSize = 5;
          isLargeScreen = false;
          isMediumScreen = true;
          numCards = MediaQuery.of(context).orientation == Orientation.portrait
              ? 3
              : 4;
          // Phone Size
        } else {
          isLargeScreen = false;
          isMediumScreen = false;
          numCards = 2;
          numActivityCards = 1;
        }
        return Scaffold(
          body: Row(
            children: <Widget>[
              Expanded(
                flex: secondFlexSize,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Column(children: <Widget>[
                    Container(
                      color: Color(0xFFF9EBEB),
                      padding: EdgeInsets.only(left: 12.0),
                      child: Header(
                        image: "assets/icons/lightPinkBg.svg",
                        textTop: "SEARCH",
                        subtitle: "Connections",
                      ),
                    ),
                    Expanded(
                        child: Container(
                      height: 600,
                      child: Stack(children: [
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: Header(
                            image: "assets/icons/lightPinkBg.svg",
                            textTop: "",
                            subtitle: "",
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: double.infinity,
                            color: Colors.transparent,
                            child: PlatformSvg.asset(
                              "assets/icons/saved.svg",
                              width: 300,
                              height: double.infinity,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Positioned(
                          top: 80,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (listResults.length != 0)
                                  ResultsBox(
                                      results: listResults,
                                      columnCount: isLargeScreen
                                          ? 5
                                          : isMediumScreen ? 4 : 2,
                                      getCard: getCard),
                              ],
                            ),
                          ),
                        ),
                        _buildSearchBar(context),
                        NoResultBanner(queryResult, noResults),
                      ]),
                    )),
                  ]),
                ),
              ),

              // If large screen, render installation detail page
              ((isLargeScreen || isMediumScreen))
                  ? Expanded(
                      flex: 3,
                      key: UniqueKey(),
                      child: selectedItem ??
                          Container(
                            color: Colors.transparent,
                          ))
                  : Container(),
            ],
          ),
        );
      }),
    );
  }
}
