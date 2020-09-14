import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:artsideout_app/pages/search/MasterSearchPage.dart';

class ResultsBox extends StatelessWidget {
  final int numResults;
  final double cardAspectRatio;
  final int numColumns;
  final String heading;
  final Function getCard;

  const ResultsBox(
      {Key key,
      this.numResults,
      this.cardAspectRatio,
      this.numColumns,
      this.heading,
      this.getCard})
      : super(key: key);

  Widget build(BuildContext context) {
    return Column(
      children: [
        if (numResults > 0)
          SizedBox(
            height: 30,
          ),
        if (numResults > 0)
          Center(
            child: Container(
              width: 850,
              height: 280,
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
                      heading,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          letterSpacing: 2.0),
                    ),
                  ),
                  Container(
                    width: 850,
                    height: 225,
                    color: Colors.transparent,
                    child: AnimationLimiter(
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: numColumns,
                          childAspectRatio: cardAspectRatio,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                        ),
                        itemCount: numResults,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredGrid(
                              columnCount: numColumns,
                              duration: const Duration(milliseconds: 300),
                              position: index,
                              child: SlideAnimation(
                                  verticalOffset: 50,
                                  child: FadeInAnimation(
                                    child: Center(
                                      child: getCard(heading, index),
                                    ),
                                  )));
                        },
                      ),
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
