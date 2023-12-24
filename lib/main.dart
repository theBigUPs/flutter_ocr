import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String text = "";
  final StreamController<String>  controller = StreamController<String>.broadcast();
 
  bool isStreamPaused = false;
  void setText(value) {
    if (!isStreamPaused) {
      controller.add(value);
    }
    
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ScalableOCR(
                  paintboxCustom: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4.0
                    ..color = const Color.fromARGB(153, 102, 160, 241),
                  boxLeftOff: 7,
                  boxBottomOff: 2.5,
                  boxRightOff: 7,
                  boxTopOff: 2.5,
                  boxHeight: MediaQuery.of(context).size.height / 3,
                  getRawData: (value) {
                    //inspect(value);
                  },
                  getScannedText: (value) {
                    setText(value);
                  }),
              StreamBuilder<String>(
                stream: isStreamPaused ? null : controller.stream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Result(
                  text: snapshot.data != null ? snapshot.data! : "",
                );
                },
              ),
              FloatingActionButton(onPressed:   (){
                setState(() {
                  isStreamPaused = !isStreamPaused;
                });
                })
            ],
          ),
        ));
  }
}

class Result extends StatelessWidget {
  const Result({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SelectableText("Readed text: $text");
  }
}