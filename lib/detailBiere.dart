import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:lapinte/favoris.dart';
import 'package:lapinte/liste.dart';
import 'package:lapinte/main.dart';
import 'package:lapinte/search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(Detail());
}

class Detail extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print(globals.nameBeer.toString());
    print(globals.isfav.toString());

    return MaterialApp(
      title: 'La Pinte',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.yellow,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Détail !'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /*Future<String> _ajoutFav() async {
    // Récupération de la localisation actuelle de l'utilisateur
    // Construction de l'URL a appeler
    var url = 'http://10.0.2.2:5000/favorite';
    // Appel
    String json = '{"beer_id": 3, "user_id": "2"}';
    var response = await http.post(url, body: json);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return response.body;
  }*/

  Future<String> _ajoutFav() async {
    Map data = {
      'beer_id': globals.beerIndex.toString(),
      'user_id': globals.user_id.toString()
    };

    String body = json.encode(data);
    var url = 'http://10.0.2.2:5000/favorite';
    http.Response response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
  }

  Future<String> _supFav() async {
    var url = 'http://10.0.2.2:5000/favorite/' +
        globals.beerIndex.toString() +
        '/' +
        globals.user_id.toString();
    http.Response response = await http.delete(
      url,
      headers: {"Content-Type": "application/json"},
    );
  }

  Future<String> _supav() async {
    /*final baseUrl = "http://10.0.2.2:5000/favorite";
    final url = Uri.parse(baseUrl);
    final request = http.Request("DELETE", url);
    /*request.headers.addAll(<String, String>{
      "Accept": "application/json",
      "token": "my token",
      "jwt": "my jwt"
    });*/

    request.body = jsonEncode({"beer_id": 2, "user_id": 1});
    final response = await request.send();
    if (response.statusCode != 200)
      return Future.error("error: status code ${response.statusCode}");
    return await response.stream.bytesToString();*/
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    var flatButton = FlatButton(
      color: Colors.orange,
      textColor: Colors.white,
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      padding: EdgeInsets.all(9.0),
      splashColor: Colors.orangeAccent,
      onPressed: () {
        setState(() {
          if (globals.isfav == false) {
            _ajoutFav();
          } else {
            _supFav();
          }
          globals.isfav = !globals.isfav;
        });

        /* Requete API pour ajouter/enlever à la table favoris  */
      },
      //Faire un if en fonction de si il est dans les favoris bouton enlever et si pas presenter bouton ajouter
      child: globals.isfav
          ? Text(
              "Supprimer de mes favoris",
              style: TextStyle(fontSize: 15.0),
            )
          : Text(
              "Ajouter à mes favoris",
              style: TextStyle(fontSize: 15.0),
            ),
    );
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(globals.nameBeer),
      ),
      floatingActionButton: flatButton,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        fixedColor: Colors.teal,
        items: [
          BottomNavigationBarItem(
            title: Text("Acceuil"),
            icon: Icon(Icons.list_alt_sharp),
          ),
          BottomNavigationBarItem(
            title: Text("Recherche"),
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            title: Text("Mes favoris"),
            icon: Icon(Icons.favorite_outline),
          ),
          BottomNavigationBarItem(
            title: Text("Déconnexion"),
            icon: Icon(Icons.account_circle_outlined),
          ),
        ],
        onTap: (int index) {
          if (index == 0) {
            runApp(Liste());
          }
          if (index == 1) {
            runApp(Search());
          }
          if (index == 2) {
            runApp(Favoris());
          }
          if (index == 3) {
            runApp(Auth());
          }
        },
      ),
    );
  }
}
