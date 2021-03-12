import 'package:flutter/material.dart';
import 'package:lapinte/favoris.dart';
import 'package:lapinte/liste.dart';
import 'package:flutter/foundation.dart';
import 'package:lapinte/main.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'dart:convert';

void main() {
  runApp(Ajout());
}

class Ajout extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
      home: MyHomePage(title: 'Ajouter une mousse'),
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

class Biere {
  final int id;
  final String name;
  final String percentageAlcohol;
  final String category;

  Biere({this.id, this.name, this.percentageAlcohol, this.category});

  factory Biere.fromJson(Map<String, dynamic> json) {
    return Biere(
      id: json['id'] as int,
      name: json['name'] as String,
      percentageAlcohol: json['percentageAlcohol'] as String,
      category: json['category'] as String,
    );
  }
}

Future<List<Biere>> fetchBeers(http.Client client) async {
  // final response = await client.get('http://10.0.2.2:5000/beers',
  final response = await client.get('http://172.16.18.16:5000/beers',
      headers: {"Content-Type": "application/json", "token": globals.token});

  // Use the compute function to run parseBieres in a separate isolate.
  // print('Response body: ${response.body}');
  //print('----');
  //print(compute(parseBieres, response.body).toString());
  return compute(parseBieres, response.body);
}

List<Biere> parseBieres(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Biere>((json) => Biere.fromJson(json)).toList();
}

class _MyHomePageState extends State<MyHomePage> {
  final nomCtrl = TextEditingController();
  final couleurCtrl = TextEditingController();
  final degreCtrl = TextEditingController();

  Future<String> _ajoutBeer(List<Biere> bieres) async {
    globals.isHere = false;

    bieres.forEach((biere) => {
          if (biere.name.toLowerCase() == nomCtrl.text.toLowerCase() &&
              biere.category.toLowerCase() == couleurCtrl.text.toLowerCase())
            {globals.isHere = true}
        });
    Map data = {
      'name': nomCtrl.text.toString(),
      'percentageAlcohol': degreCtrl.text.toString(),
      'category': couleurCtrl.text.toString()
    };

    if (!globals.isHere) {
      String body = json.encode(data);
      //var url = 'http://10.0.2.2:5000/beers';
      var url = 'http://172.16.18.16:5000/beers';
      http.Response response = await http.post(
        url,
        headers: {"Content-Type": "application/json", "token": globals.token},
        body: body,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
        child: Column(children: <Widget>[
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nom',
            ),
            controller: nomCtrl,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Couleur',
            ),
            controller: couleurCtrl,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Degré',
            ),
            controller: degreCtrl,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
          ),
          FlatButton(
            color: Colors.orange,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(9.0),
            splashColor: Colors.orangeAccent,
            onPressed: () async {
              //await fetchBeers(http.Client());
              List<Biere> listeBeers = await fetchBeers(http.Client());
              await _ajoutBeer(listeBeers);
              if (globals.isHere == false) {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text("Biere ajoutée à la liste"),
                    );
                  },
                );
              }
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text("Biere déjà existante"),
                  );
                },
              );
            },
            child: Text(
              "Ajouter",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        fixedColor: Colors.teal,
        items: [
          BottomNavigationBarItem(
            title: Text("Acceuil"),
            icon: Icon(Icons.list_alt_sharp),
          ),
          BottomNavigationBarItem(
            title: Text("Ajouter"),
            icon: Icon(Icons.add_circle_outline),
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
