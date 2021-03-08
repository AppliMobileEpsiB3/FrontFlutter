import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:lapinte/liste.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(Auth());
}

class Auth extends StatelessWidget {
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
      home: MyHomePage(title: 'Authentification'),
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
  final pseudoCtrlr = TextEditingController();
  final passwordCtrlr = TextEditingController();

  bool isExist(TextEditingController pseudo, TextEditingController password) {
    //final test = http.get('https://jsonplaceholder.typicode.com/albums/1');

    //debugPrint(pseudoCtrlr.text);
    //debugPrint(passwordCtrlr.text);

    if (pseudoCtrlr.text == "toto" && passwordCtrlr.text == "titi") {
      globals.userName = pseudoCtrlr.text;
      return true;
    }
    return false;
  }

  Future<String> _getAuth() async {
    // Récupération de la localisation actuelle de l'utilisateur
    // Construction de l'URL a appeler
    var url = 'http://10.0.2.2:5000/beers';
    // Appel
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    debugPrint(response.body);
    return response.body;
  }

  Future<String> sunriseSunsetTimes;

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
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).

          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                child: Text(' Sign in : ', style: TextStyle(fontSize: 22))),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Login',
              ),
              controller: pseudoCtrlr,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              controller: passwordCtrlr,
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
              onPressed: () {
                if (isExist(pseudoCtrlr, passwordCtrlr)) {
                  _getAuth();
                  runApp(Liste());
                } else {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("Wrong password or login !"),
                      );
                    },
                  );
                }
              },
              child: Text(
                "Connexion",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Text(
              "@Version 1.3.1",
              style: TextStyle(fontSize: 8.0),
            ),
          ],
        ),
      ),
    );
  }
}
