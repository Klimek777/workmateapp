import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';

import '../services/firebase_service.dart';
import '../chart_widets/compare_transactions_chart.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  double? _deviceHeight, _deviceWidth;
  FirebaseService? _firebaseService;
  DateTime now = DateTime.now();
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  String _selectedMonth = 'January';
  int? _currentMonth;
  int? _selectedMonthIndex, planned, done;
  double? youEarned, youCouldEarn;
  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _currentMonth = now.month;
    print(_currentMonth);
    _selectedMonth = months[_currentMonth! - 1];
    _selectedMonthIndex = _currentMonth;
    test(_selectedMonthIndex!);
  }

  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: _deviceHeight,
          width: _deviceWidth,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _titleWidget(),
              _monthDropdown(),
              SizedBox(
                height: 60,
              ),
              _chart(),
              SizedBox(
                height: 40,
              ),
              _yourEarningsWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Center(
        child: RichText(
          text: TextSpan(
              text: 'Check your ',
              style: TextStyle(color: Colors.black, fontSize: 25),
              children: [
                TextSpan(
                    text: 'results!',
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold))
              ]),
        ),
      ),
    );
  }

  Widget _monthDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: DropdownButton<String>(
        menuMaxHeight: 300,
        value: _selectedMonth,
        onChanged: (String? newValue) {
          setState(() {
            _selectedMonth = newValue!;
            _selectedMonthIndex =
                months.indexOf(newValue); // Get the index of the selected month

            print(_selectedMonth);
            test(_selectedMonthIndex! + 1);
          });
        },
        items: months.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _yourEarningsWidget() {
    return Center(
      child: Column(
        children: [
          RichText(
            text: TextSpan(
                text: 'You earned: ',
                style: TextStyle(color: Colors.black, fontSize: 20),
                children: [
                  TextSpan(
                      text: ' $youEarned pln!',
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.bold))
                ]),
          ),
          SizedBox(
            height: 10,
          ),
          RichText(
            text: TextSpan(
                text: 'But you could: ',
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                      text: ' $youCouldEarn pln!',
                      style: TextStyle(color: Colors.orange))
                ]),
          ),
        ],
      ),
    );
  }

  void test(int month) async {
    Map<String, dynamic> allresults =
        await _firebaseService!.getAllWorkForUser(month);
    QuerySnapshot snapshot = allresults['snapshot'];
    int count = allresults['count'];
    print(count);

    Map<String, dynamic> doneresults =
        await _firebaseService!.getDoneWorkForUser(month);
    QuerySnapshot doneSnapshot = doneresults['snapshot'];
    int countDone = doneresults['count'];
    print(countDone);

    double sumOfDoneWork =
        await _firebaseService!.getSumOfDoneWorkForUser(month);
    print(sumOfDoneWork);

    double sumOfAllWork = await _firebaseService!.getSumOfAllWorkForUser(month);
    print(sumOfAllWork);
    setState(() {
      planned = count;
      done = countDone;
      youCouldEarn = sumOfAllWork;
      youEarned = sumOfDoneWork;
    });
  }

  Widget _chart() {
    if (planned != null && done != null) {
      return BarChartSample3(
        planned: planned!,
        done: done!,
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}
