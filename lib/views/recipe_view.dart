import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RecipeView extends StatefulWidget {
  String? postUrl;

  RecipeView({postUrl});

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
                mainAxisAlignment:
                    kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: <Widget>[
                  Text("Cook-it!",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                  Text(
                    "Recipes!",
                    style: TextStyle(
                      color: Colors.deepOrangeAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]),
          )
        ],
      ),
    );
  }
}
