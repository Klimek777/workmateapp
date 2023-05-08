import 'dart:async';

import 'package:flutter/material.dart';
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
  List months = [
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
  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _currentMonth = now.month;
    print(_currentMonth);
    _selectedMonth = months[_currentMonth! - 1];
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
              BarChartSample3(),
              SizedBox(
                height: 40,
              ),
              _yourEarningsWidget()
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
          });
        },
        items: <String>[
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
        ].map<DropdownMenuItem<String>>((String value) {
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
                      text: ' 1600 pln!',
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
                      text: ' 2300 pln!',
                      style: TextStyle(color: Colors.orange))
                ]),
          ),
        ],
      ),
    );
  }
}
