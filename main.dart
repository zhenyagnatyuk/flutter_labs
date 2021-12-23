import 'package:flutter/material.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram',
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
      home: const MyHomePage(title: 'Instagram'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  void _dismissDialog() {
    Navigator.pop(context);
  }

  void _buttonAction() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Dialog'),
            content: const Text('Message.'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    _dismissDialog();
                  },
                  child: const Text('Close')),
              TextButton(
                onPressed: () {
                  _dismissDialog();
                },
                child: const Text('And... close'),
              ),
            ],
          );
        });
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
        color: const Color.fromRGBO(234, 230, 230, 1),
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
                    child: Text('User ' + (i + 1).toString(),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                return_tag = i;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OpenedImage()));
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
            children: posts,
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
      floatingActionButton: Visibility(
          visible: isFabVisible,
          child: FloatingActionButton(
            onPressed: _buttonAction,
            tooltip: 'Dialog',
            child: const Icon(Icons.add),
          )),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image'),
        ),
        body: Hero(
          tag: (return_tag + 1).toString(),
          child: Image.network(images[return_tag]),
        ));
  }
}
