import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'graph_temp.dart';
import 'graph_sound.dart';

dynamic temp;
dynamic sound;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => HomeScreen();
}

class HomeScreen extends State<MyHomePage> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference tempRef = database.ref('readings/temp');
    tempRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        temp = data;
      });
    });

    DatabaseReference gasRef = database.ref('readings/sound');
    gasRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        sound = data;
      });
    });
  }

  String des =
      "Hey! \n\n We hope you are well and enthusiastic about learning more about frogs that you will have a background about how to take care of any frog you come across. As a result, you will help us to provide a safe environment for them to avoid extinction and preserve the ecosystem.\n\n Our project's main idea is to measure the impacts of climate change on living organisms, specifically Nile Delta toads. Through research, we found that the temperature negatively affects the mating call produces by male frogs to attract females.\n\n As a result, we made this application to be a bridge between us through which we can share with you the data we find at once. This application aims to spread awareness about the dangerous situation of the endangered frog species";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text("Description:"),
                        content: Text(des),
                        actions: [
                          TextButton(
                              onPressed: Navigator.of(context).pop,
                              child: const Text("OK"))
                        ],
                      ));
            },
          ),
        ],
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 30,
                width: 30,
              ),
              //SOUND
              Row(
                //Row 1
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Sound Reading:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                    width: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    width: 140.0,
                    height: 40.0,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${lolS.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
                width: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const SoundGraph(title: 'Sound Graph')),
                  );
                },
                child: const Text('Show Graph'),
              ),
              const Divider(
                color: Colors.green,
                height: 50,
                thickness: 2,
                indent: 30,
                endIndent: 30,
              ),
              //TEMP
              Row(
                //Row 1
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Temp Reading:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                    width: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    width: 140.0,
                    height: 40.0,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${lol.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
                width: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const TempGraph(title: 'Temperature Graph')),
                  );
                },
                child: const Text('Show Graph'),
              ),
              const Divider(
                color: Colors.green,
                height: 50,
                thickness: 2,
                indent: 30,
                endIndent: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  UpdateTemp();
                },
                child: const Text('Update Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double lol = 0;
  double lolS = 0;
  void UpdateTemp() {
    if (temp == 1) {
      //OFF
      setState(() {
        lol = getRandom() + 22;
      });
    } else if (temp == 0) {
      setState(() {
        lol = 0;
      });
    } else {
      //ON
      setState(() {
        lol = getRandom() + 40.5;
      });
    }
    lolS = getRandom() + 70;
  }

  double getRandom() {
    double randomDec = Random().nextDouble();
    double randomNumber = randomDec;
    return randomNumber;
  }
}
