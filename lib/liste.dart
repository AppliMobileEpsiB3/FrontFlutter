import 'dart:convert';
import 'globals.dart' as globals;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lapinte/main.dart';
import 'package:lapinte/detailBiere.dart';
import 'package:lapinte/favoris.dart';
import 'package:lapinte/search.dart';
import 'package:http/http.dart' as http;

Future<List<Biere>> fetchBeers(http.Client client) async {
  final response = await client.get('http://10.0.2.2:5000/beers',
      headers: {"Content-Type": "application/json", "token": globals.token});

  // Use the compute function to run parseBieres in a separate isolate.
  //print('Response body: ${response.body}');

  return compute(parseBieres, response.body);
}

List<Biere> parseBieres(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Biere>((json) => Biere.fromJson(json)).toList();
}

Future<String> _isInFavoris() async {
  // Récupération de la localisation actuelle de l'utilisateur
  // Construction de l'URL a appeler
  var url = 'http://10.0.2.2:5000/favorite/' + globals.user_id.toString();
  // Appel
  var response = await http.get(url,
      headers: {"Content-Type": "application/json", "token": globals.token});
  //print('Response status: ${response.statusCode}');
  //print('Response body: ${response.body}');
  globals.isfav = response.body.contains(globals.nameBeer);

  return response.body;
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

void main() {
  runApp(Liste());
}

class Liste extends StatelessWidget {
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
      home: MyHomePage(title: 'Liste des binouses !'),
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
      body: FutureBuilder<List<Biere>>(
        future: fetchBeers(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? BieresList(bieres: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
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

class BieresList extends StatelessWidget {
  final List<Biere> bieres;

  BieresList({Key key, this.bieres}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: bieres.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(bieres[index].name),
          onTap: () async {
            globals.beerIndex = bieres[index].id;
            globals.nameBeer = bieres[index].name;
            globals.category = bieres[index].category;
            globals.percentageAlcohol = bieres[index].percentageAlcohol;
            await _isInFavoris();

            runApp(Detail());
          },
        );
      },
    );
  }
}
