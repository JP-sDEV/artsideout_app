import 'package:artsideout_app/components/art/ArtCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:artsideout_app/pages/search/MasterSearchPage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ResultsBox extends StatelessWidget {
  final List<dynamic> results;
  final Function getCard;
  final int columnCount;

  const ResultsBox({Key key, this.results, this.columnCount, this.getCard})
      : super(key: key);

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Center(
          child: Container(
            width: width < 600 ? width * 0.95 : (width - 100) * 0.90,
            height: 600,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: Color(0xFFF9EBEB),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(18)),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 40,
                  child: Text(
                    "Search Results:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        letterSpacing: 2.0),
                  ),
                ),
                Container(
                  width: width < 600 ? width * 0.95 : (width - 100) * 0.90,
                  height: 545,
                  color: Colors.transparent,
                  child: AnimationLimiter(
                    child: StaggeredGridView.countBuilder(
                        padding: EdgeInsets.all(0.0),
                        crossAxisCount: columnCount,
                        itemCount: results.length,
                        itemBuilder: (BuildContext context, int index) {
                          var item = results[index];
                          return AnimationConfiguration.staggeredGrid(
                              columnCount: columnCount,
                              duration: const Duration(milliseconds: 300),
                              position: index,
                              child: SlideAnimation(
                                  verticalOffset: 50,
                                  child: FadeInAnimation(
                                    child: Center(
                                      child: getCard(
                                          item.runtimeType.toString(), index),
                                    ),
                                  )));
                        },
                        staggeredTileBuilder: (int index) {
                          return StaggeredTile.count(
                            results[index].runtimeType.toString() == "Activity"
                                ? 2
                                : 1,
                            1,
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
