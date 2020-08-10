import 'package:flutter/material.dart';

import 'dot_indicator.dart';

void main() {
  runApp(MyApp());
}

const colors = [
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.amber,
  Colors.purpleAccent,
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.amber,
  Colors.purpleAccent,
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: PageView(
              children:
                  colors.map((color) => ColoredBox(color: color)).toList(),
              onPageChanged: (page) {
                setState(() {
                  _currentIndex = page;
                });
              },
            ),
          ),
          const SizedBox(height: 6),
          FixedScrollIndicator(
            length: colors.length,
            currentIndex: _currentIndex,
          ),
        ],
      ),
    );
  }
}
