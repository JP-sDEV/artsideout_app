import 'package:artsideout_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:artsideout_app/graphql/Installation.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ArtDetailWidget extends StatefulWidget {
  final Installation data;

  ArtDetailWidget({Key key, this.data}) : super(key: key);

  @override
  _ArtDetailWidgetState createState() => _ArtDetailWidgetState();
}

class _ArtDetailWidgetState extends State<ArtDetailWidget> {
  YoutubePlayerController controller;
  Widget videoPlayer = YoutubePlayerIFrame();

  void initState() {
    super.initState();
    initController();
  }

  void dispose() {
    super.dispose();
    controller.close();
  }

  void initController() {
    controller = YoutubePlayerController(
      initialVideoId:
          YoutubePlayerController.convertUrlToId(widget.data.videoURL),
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false,
        autoPlay: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    RaisedButton likeAndSaveButtons(Icon icon, int numInteractions) {
      return RaisedButton.icon(
        onPressed: () {},
        padding: EdgeInsets.all(13.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        icon: icon,
        textColor: Colors.white,
        color: asoPrimary,
        label: Text('$numInteractions  '),
      );
    }

    return YoutubePlayerControllerProvider(
      controller: controller,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            var width = MediaQuery.of(context).size.width;
            return MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                //physics: NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    // Horizontal ListView
                    height: 250,
                    width: width,
                    child: ListView.builder(
                      itemCount: widget.data.imgURL.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                            width: (width / (widget.data.imgURL.length + 1)),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(widget.data.imgURL[index]),
                              ),
                            ));
                      },
                    ),
                  ),
                  widget.data.videoURL != 'empty'
                      ? Container(
                          width: (width / widget.data.imgURL.length),
                          height: 250,
                          child: videoPlayer)
                      : Container(),
                  SizedBox(
                    height: 15.0,
                  ),
                  Card(
                    margin: EdgeInsets.all(16.0),
                    color: Color(0xFFF9EBEB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(18),
                      leading: CircleAvatar(
                        backgroundColor: Colors.pink,
                        radius: 25.0,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              'John Appleseed',
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Artist',
                            style: TextStyle(
                                fontSize: 14.5,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          likeAndSaveButtons(
                            Icon(Icons.bookmark_border),
                            72,
                          ),
                          SizedBox(
                            width: 7.0,
                          ),
                          likeAndSaveButtons(
                            Icon(Icons.favorite_border),
                            284,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Text(
                      'OVERVIEW',
                      style: TextStyle(
                        color: asoPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1.0,
                    height: 0,
                    indent: 15,
                    endIndent: 20,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 16.0,
                        ),
                        Flexible(child: Text(widget.data.desc)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
