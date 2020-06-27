import 'package:flutter/material.dart';
import 'package:artsideout_app/graphql/Installation.dart';

class ArtDetailWidget extends StatefulWidget {
  final Installation data;

  ArtDetailWidget(this.data);

  @override
  _ArtDetailWidgetState createState() => _ArtDetailWidgetState();
}

class _ArtDetailWidgetState extends State<ArtDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration( 
        color: Colors.white,
        // borderRadius: BorderRadius.circular(25),
        boxShadow: [ 
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5, 
            blurRadius: 7, 
            offset: Offset(10, 3),
          ),
        ],
      ),
<<<<<<< HEAD
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.data.title,
=======
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Container(
              width: 450,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(widget.data.imgUrl),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.pink,
              radius: 25.0,
            ),
            title: Text(
              'John Appleseed',
            ),
            trailing: IconButton(
              icon: Icon(Icons.bookmark),
              color: asoPrimary,
              onPressed: () {},
            ),
          ),
          ListTile(
            leading: Text(
              widget.data.zone,
>>>>>>> 315e50e... fixed width and removed extra libraries
              style: TextStyle(
                  fontSize: 36.0, color: Theme.of(context).primaryColor),
            ),
            Text(
              widget.data.zone,
              style: TextStyle(
                  fontSize: 36.0, color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
