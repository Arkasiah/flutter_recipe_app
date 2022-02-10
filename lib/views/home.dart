import 'dart:convert';
import 'dart:io';
import 'package:cook_it/models/recipe_model.dart';
import 'package:cook_it/views/recipe_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipeModel> recipes = <RecipeModel>[];
  TextEditingController textEditingController = new TextEditingController();

  String applicationId = "46c2a5a2";
  String applicationKey = "0b64ad42ae877d4d519e08bcd2c2ab2d";

  getRecipes(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=$applicationId&app_key=$applicationKey";
    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> jsonData = jsonDecode(response.body);

    jsonData["hits"].forEach((element) {
      print(element.toString());

      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);

      recipes.add(recipeModel);
    });

    print("${recipes.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              const Color(0xff0A1672),
              const Color(0xff071930),
            ])),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: Platform.isIOS ? 60 : 30, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: kIsWeb
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
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
                  SizedBox(
                    height: 30,
                  ),
                  Text("Choisit ta recette du jour !",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                      "Entre ton ingrédient et trouve ta nouvelle recette favorie !)",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                              hintText: 'poulet',
                              hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.5)),
                            ),
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        InkWell(
                            onTap: () {
                              if (textEditingController.text.isNotEmpty) {
                                getRecipes(textEditingController.text);
                                print("let's go");
                              } else {
                                print("let's not go");
                              }
                            },
                            child: Container(
                                child: Icon(Icons.search, color: Colors.white)))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: GridView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200, mainAxisSpacing: 10.0),
                        children: List.generate(recipes.length, (index) {
                          return GridTile(
                              child: RecipeTile(
                                  title: recipes[index].label,
                                  desc: recipes[index].source,
                                  imgUrl: recipes[index].image,
                                  url: recipes[index].url));
                        })),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeTile extends StatefulWidget {
  String? title, desc, imgUrl, url;

  RecipeTile({title, desc, imgUrl, url});

  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossible de démarrer $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: <Widget>[
      GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url!);
            } else {
              print(widget.url);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                            postUrl: widget.url,
                          )));
            }
          },
          child: Container(
              margin: EdgeInsets.all(8),
              child: Stack(children: <Widget>[
                Image.network(
                  widget.imgUrl!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                    width: 200,
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.white30, Colors.white],
                            begin: FractionalOffset.centerRight,
                            end: FractionalOffset.centerLeft)),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.title!,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                    fontFamily: 'Overpass'),
                              ),
                              Text(widget.desc!,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black54,
                                      fontFamily: 'OverpassRegular'))
                            ])))
              ])))
    ]);
  }
}
