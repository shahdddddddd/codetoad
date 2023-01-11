import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

dynamic temp;
dynamic sound;

class TempGraph extends StatefulWidget {
  const TempGraph({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  GraphScreen createState() => GraphScreen();
}

class GraphScreen extends State<TempGraph> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    getData();
    super.initState();
    chartData = getChartData();
    //shown data delayed by 1 sec.
    Timer.periodic(const Duration(seconds: 2), updateDataSource);
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

    DatabaseReference turbRef = database.ref('readings/sound');
    turbRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        sound = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: const Text('Temperature Graph'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SfCartesianChart(
          backgroundColor: Colors.white,
          series: <LineSeries<LiveData, int>>[
            LineSeries<LiveData, int>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesController = controller;
              },
              //data source, color, and x-y data assignment
              dataSource: chartData,
              color: Colors.red,
              xValueMapper: (LiveData reading, _) => reading.time,
              yValueMapper: (LiveData reading, _) => reading.data,
            )
          ],
          //x-axis grid view
          primaryXAxis: NumericAxis(
              //grid width
              majorGridLines: const MajorGridLines(width: 0),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              //interval
              interval: 1,
              //axis Title
              title: AxisTitle(text: 'Time (seconds)')),
          //y-axis grid view
          primaryYAxis: NumericAxis(
              axisLine: const AxisLine(width: 0),
              //Tick Lines
              majorTickLines: const MajorTickLines(size: 0),
              //axis Title
              title: AxisTitle(text: 'Temperature (C)')),
        ),
      ),
    );
  }

  double lol = 0;
  int time = 8;
  void updateDataSource(Timer timer) {
    if (temp == 0) {
      //OFF
      lol = getRandom() + 22;
    } else {
      //ON
      lol = getRandom() + 40.5;
    }
    chartData.add(LiveData(time++, lol));
    chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  }

  double getRandom() {
    double randomDec = Random().nextDouble();
    double randomNumber = randomDec;
    return randomNumber;
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 0),
      LiveData(1, 0),
      LiveData(2, 0),
      LiveData(3, 0),
      LiveData(4, 0),
      LiveData(5, 0),
      LiveData(6, 0),
      LiveData(7, 0),
    ];
  }
}

class LiveData {
  LiveData(this.time, this.data);
  final dynamic time; //must be an integer 'cause time (1,2,3,..)
  final dynamic data; //can have a decimal point
}
