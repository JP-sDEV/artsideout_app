// Misc
import 'package:artsideout_app/pages/art/ArtDetailPage.dart';
import 'package:artsideout_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// Common
import 'package:artsideout_app/components/PageHeader.dart';
import 'package:artsideout_app/components/common.dart';
// GraphQL
import 'package:artsideout_app/graphql/Installation.dart';
// Art
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:artsideout_app/components/art/ArtCard.dart';
import 'package:artsideout_app/components/art/ArtDetailWidget.dart';
// Activity
import 'package:artsideout_app/components/activitycard.dart';
import 'package:artsideout_app/pages/activity/ActivityDetailPage.dart';
import 'package:artsideout_app/components/activity/ActivityDetailWidget.dart';
import 'package:artsideout_app/graphql/Activity.dart';
// Profile
import 'package:artsideout_app/graphql/Profile.dart';
import 'package:artsideout_app/components/profile/profileCard.dart';
import 'package:artsideout_app/pages/profile/ProfileDetailPage.dart';
// Search
import 'package:artsideout_app/components/search/FetchSearchQueries.dart';
import 'package:artsideout_app/components/search/ResultsBox.dart';
import 'package:artsideout_app/components/search/FilterDropdown.dart';

class MasterSearchPage extends StatefulWidget {
  @override
  _MasterSearchPageState createState() => _MasterSearchPageState();
}

class _MasterSearchPageState extends State<MasterSearchPage> {
  int secondFlexSize = 1;
  int numCards = 2, numActivityCards = 2;
  bool isLargeScreen = false;
  bool isMediumScreen = false;
  bool isLoading = false;
  bool noResults = false;
  Widget selectedItem;
  String queryResult = "";

  Map<String, bool> optionsMap = {
    "Music": true,
    "Spoken Word": true,
    "Theatre": true,
    "Sculpture": true,
    "DigitalMedia": true,
    "Mix Media": true,
    "Drawings/Paintings": true,
    "Artists": true,
    "Organizers": true,
    "Sponsors": true,
    "Other": true,
  };

  TextEditingController _searchQueryController = TextEditingController();

  List<Installation> listInstallations = List<Installation>();
  List<Activity> listActivities = List<Activity>();
  List<Profile> listProfiles = List<Profile>();
  List<dynamic> listResults = List<dynamic>();

  FetchResults fetchResults = new FetchResults();

  void handleTextChange() {
    String inputText = _searchQueryController.text;

    if (inputText != ' ' && inputText != '') {
      if (listResults != null) clearResults();

      setState(() {
        isLoading = true;
        queryResult = inputText;
      });

      getResults(inputText);
    }
  }

  void getResults(String inputText) async {
    listInstallations =
        await fetchResults.getInstallationsByTypes(inputText, optionsMap);

    listActivities =
        await fetchResults.getActivitiesByTypes(inputText, optionsMap);

    listProfiles = await fetchResults.getProfilesByTypes(inputText, optionsMap);

    setState(() {
      listResults = [...listInstallations, ...listActivities, ...listProfiles];
      checkNoResults();
    });
  }

  void clearResults() {
    listInstallations.clear();
    listActivities.clear();
    listProfiles.clear();
    listResults.clear();
  }

  void checkNoResults() {
    setState(() {
      isLoading = false;
      if (listResults.isEmpty) {
        noResults = true;
        selectedItem = null;
      } else {
        noResults = false;
      }
    });
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
                  ? item.imgURL
                  : getThumbnail(item.videoURL),
            ),
            onTap: () {
              setState(() {
                if (isLargeScreen || isMediumScreen) {
                  selectedItem =
                      ArtDetailWidget(data: listInstallations[index]);
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

  void dispose() {
    _searchQueryController.dispose();
    super.dispose();
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
            Row(
              children: [
                Expanded(
                  flex: 10,
                  child: TextField(
                    controller: _searchQueryController,
                    autofocus: true,
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        icon: Icon(Icons.search),
                        color: asoPrimary,
                        onPressed: handleTextChange,
                      ),
                      suffix: SizedBox(
                        height: 26,
                        width: 26,
                        child: isLoading
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(asoPrimary),
                                backgroundColor: Colors.white,
                              )
                            : GestureDetector(
                                child: Icon(
                                  Icons.close,
                                  size: 26,
                                ),
                                onTap: () => _searchQueryController.clear(),
                              ),
                      ),
                      hintText: "Search installations, activities, artists...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 22.0),
                    onEditingComplete: handleTextChange,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: 130,
                  child: FilterDropdown(
                    onFilterChange: (String value) {
                      setState(() {
                        optionsMap[value] = !optionsMap[value];
                      });
                    },
                    optionsMap: optionsMap,
                  ),
                )
              ],
            ),
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
                                      columnCount:
                                          isLargeScreen && selectedItem == null
                                              ? 5
                                              : isMediumScreen ? 2 : 2,
                                      getCard: getCard),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                        ),
                        _buildSearchBar(context),
                        Positioned(
                          top: 90,
                          left: 20,
                          right: 20,
                          child: AnimatedOpacity(
                            opacity: noResults ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 300),
                            child: Container(
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(0xFFF9EBEB),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'No results founds for: $queryResult',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    )),
                  ]),
                ),
              ),

              // If large screen, render installation detail page
              ((isLargeScreen || isMediumScreen) && noResults != true) //
                  ? Expanded(
                      flex: 3,
                      key: UniqueKey(),
                      child: selectedItem ?? Container())
                  : Container(),
            ],
          ),
        );
      }),
    );
  }
}
