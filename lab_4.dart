import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart';

const images = [
  'https://images.unsplash.com/photo-1593642634367-d91a135587b5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2069&q=80',
  'https://images.unsplash.com/photo-1593642532871-8b12e02d091c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1112&q=80',
  'https://images.unsplash.com/photo-1640215775144-cafac1067fe6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
  'https://images.unsplash.com/photo-1593642533144-3d62aa4783ec?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1169&q=80'
];

var my_photo = 'https://i.ibb.co/JzVnyqF/IMG-20211223-230343.jpg';

const Map<int, Color> color = {
  50: Color.fromRGBO(190, 190, 190, 1),
  100: Color.fromRGBO(158, 158, 158, 1),
  200: Color.fromRGBO(139, 139, 139, 1),
  300: Color.fromRGBO(121, 121, 121, 1),
  400: Color.fromRGBO(103, 103, 103, 1),
  500: Color.fromRGBO(85, 85, 85, 1),
  600: Color.fromRGBO(68, 68, 68, 1),
  700: Color.fromRGBO(52, 52, 52, 1),
  800: Color.fromRGBO(37, 37, 37, 1),
  900: Color.fromRGBO(20, 20, 20, 1),
};

MaterialColor colorCustom = MaterialColor(color[900]!.value, color);

var return_tag;

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => ColorSelector(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            title: 'Instagram',
            theme: notifier.darkMode ? darkMode : lightMode,
            initialRoute: '/',
            routes: {
              '/': (context) => MyHomePage(title: 'Instagram'),
              '/img': (context) => OpenedImage(),
            },
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int count = 0;

  void changeTitle() {
    setState(() {
      widget.title = 'Total likes ' + count.toString();
      count += 1;
    });
  }

  void _buttonAction() {
    Provider.of<ColorSelector>(context, listen: false).changeColor();
    Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
  }

  void _fetch() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => FutureWidgetPage()))
        .then((themeName) => widget.title = themeName);
  }

  int _currIndex = 0;

  var tabs;

  var controller;
  bool isFabVisible = true;

  @override
  void initState() {
    super.initState();

    var posts = <Widget>[];
    for (var i = 0; i < 4; i++) {
      posts.add(Container(
        padding: const EdgeInsets.only(top: 20),
        // color: const Color.fromRGBO(0, 20, 20, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.person_pin),
                  Expanded(
                      child: Consumer<ColorSelector>(
                    builder: (context, colorSelector, child) => Text(
                        'User ' + (i + 1).toString(),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: colorSelector.cur_color,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ))
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                return_tag = i;
                Navigator.pushNamed(context, '/img', arguments: changeTitle);
              },
              child: Hero(
                tag: (i + 1).toString(),
                child: Container(
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ]),
                  child: Image.network(images[i]),
                ),
              ),
            ),
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.comment),
                  Icon(Icons.send),
                ],
              ),
            )
          ],
        ),
      ));
    }

    tabs = [
      ListView(
        children: [
          Column(
            children: posts +
                <Widget>[
                  ElevatedButton(onPressed: _fetch, child: const Text('Fetch'))
                ],
          ),
        ],
      ),
      ListView(
        children: [
          Column(
            children: List.from(posts.reversed),
          ),
        ],
      ),
    ];
    controller = TabController(length: tabs.length, vsync: this);
    controller.addListener(() {
      setState(() {
        _currIndex = controller.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            if (!isFabVisible) setState(() => isFabVisible = true);
          } else if (notification.direction == ScrollDirection.reverse) {
            if (isFabVisible) setState(() => isFabVisible = false);
          }
          return false;
        },
        child: TabBarView(
          children: tabs,
          controller: controller,
        ),
      ),
      drawer: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Yevhenii Hnatiuk TI-82',
              style: TextStyle(color: Colors.white, fontSize: 36)),
          Image.network(my_photo),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _buttonAction,
        tooltip: 'Dialog',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currIndex,
        selectedItemColor: color[900],
        onTap: (index) {
          setState(() {
            _currIndex = index;
            controller.animateTo(index);
          });
        },
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: const Icon(Icons.home_filled),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: const Icon(Icons.person_pin_circle),
          ),
        ],
      ),
    );
  }
}

class OpenedImage extends StatelessWidget {
  late void Function() changer;

  @override
  Widget build(BuildContext context) {
    changer = ModalRoute.of(context)?.settings.arguments as void Function();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture'),
      ),
      body: Hero(
        tag: (return_tag + 1).toString(),
        child: Image.network(images[return_tag]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: changer,
        tooltip: 'Change',
        child: const Icon(Icons.favorite_border),
      ),
    );
  }
}

class ColorSelector extends ChangeNotifier {
  Color color = Colors.black;

  void changeColor() {
    color = Color.fromRGBO(Random().nextInt(255), Random().nextInt(255),
        Random().nextInt(255), 1.0);
    notifyListeners();
  }

  Color get cur_color => color;
}

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
);

class ThemeNotifier extends ChangeNotifier {
  String key = "theme";
  late SharedPreferences _preferences;
  bool _darkMode = true;

  bool get darkMode => _darkMode;

  ThemeNotifier() {
    _loadPreferences();
  }

  _getPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  _savePreferences() async {
    await _getPreferences();
    _preferences.setBool(key, _darkMode);
  }

  _loadPreferences() async {
    await _getPreferences();
    _darkMode = _preferences.getBool(key) ?? true;
    notifyListeners();
  }

  toggleTheme() {
    _darkMode = !_darkMode;
    _savePreferences();
    notifyListeners();
  }
}

class Page {
  final String title;
  final String text;

  Page({required this.title, required this.text});

  factory Page.fromJson(Map<String, dynamic> json) {
    return Page(
        title: json['query']['pages'].values.first['title'],
        text: json['query']['pages'].values.first['extract']);
  }
}

Future<Page> fetchPage() async {
  final response = await http.get(Uri.parse(
      'https://en.wikipedia.org/w/api.php?action=query&generator=random&grnnamespace=0&prop=extracts&exchars=500&format=json'));

  if (response.statusCode == 200) {
    return Page.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Error on request!');
  }
}

class FutureWidgetPage extends StatefulWidget {
  FutureWidgetPage();

  @override
  _FutureWidgetPageState createState() => _FutureWidgetPageState();
}

class _FutureWidgetPageState extends State<FutureWidgetPage>
    with SingleTickerProviderStateMixin {
  late Future<Page> futurePage;

  late AnimationController animController;
  late List<Animation> animSize;
  late List<Animation> animColor;

  @override
  void initState() {
    super.initState();
    futurePage = fetchPage();

    animController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animSize = List.generate(
        10,
        (i) => Tween<double>(begin: 10, end: (i * 40) / ((i % 2) + 1))
            .animate(animController));
    animColor = List.generate(
        10,
        (i) => ColorTween(
                begin: const Color.fromRGBO(0, 150, 0, 1),
                end: Color.fromRGBO(0, 255 ~/ (i + 1), 255 ~/ (i + 1), 1))
            .animate(animController)
          ..addStatusListener((status) {}));

    animController.addListener(() {
      setState(() {});
    });
    animController.forward();
    animController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: Consumer<ThemeNotifier>(
            builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            title: 'Http request to wikipedia',
            theme: notifier._darkMode ? darkMode : lightMode,
            home: Scaffold(
                appBar: AppBar(
                    title: const Text('Http request to wikipedia'),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          String theme =
                              notifier._darkMode ? 'Dark Theme' : 'Light Theme';
                          Navigator.pop(context, theme);
                        },
                      ),
                    ]),
                body: Column(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        10,
                        (i) => Container(
                              height: 20,
                              width: animSize[i].value,
                              color: animColor[i].value,
                            )),
                  ),
                  Center(
                    child: FutureBuilder<Page>(
                      future: futurePage,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data!.title +
                              "\n\n" +
                              snapshot.data!.text);
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        // By default, show a loading spinner.
                        return const CircularProgressIndicator();
                      },
                    ),
                  )
                ])),
          );
        }));
  }
}
