import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double? _deviceHeight, _deviceWidth;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    List<Widget> work = [
      _workWidget('Ania', 'Stęzycka 62/18', 230.50, '12:00', 'Gdańsk', 'todo',
          DateTime(2023, 04, 2023)),
      _workWidget('Dawid', 'Berki 3/24', 1000, '15:00', 'Białogard', 'done',
          DateTime(2023, 04, 26))
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      body: Container(
        height: _deviceHeight,
        width: _deviceWidth,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 60, 10, 20),
              child: _choseDayWidget(_selectedDate),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _todayButton(),
                _mapButton(),
              ],
            ),
            work[0],
            work[1],
          ],
        ),
      ),
    );
  }

  Widget _todayButton() {
    return MaterialButton(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
              child: Text(
            'Today',
            style: TextStyle(color: Colors.white),
          )),
          width: 60,
          height: 30,
        ),
        onPressed: () {
          setState(() {
            _selectedDate = DateTime.now();
            print(_selectedDate);
          });
        });
  }

  Widget _mapButton() {
    return MaterialButton(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.orange, borderRadius: BorderRadius.circular(20)),
          child: Center(
              child: Text(
            'Map',
            style: TextStyle(color: Colors.white),
          )),
          width: 60,
          height: 30,
        ),
        onPressed: () {});
  }

  Widget _choseDayWidget(DateTime selectedDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        IconButton(
          onPressed: () {
            selectedDate = selectedDate.subtract(const Duration(days: 1));

            setState(() {
              _selectedDate = selectedDate;
            });
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
          ),
        ),
        Column(
          children: [
            selectedDate.day == DateTime.now().day
                ? Text("Your work for today")
                : Text("Work for:"),
            Text(
              DateFormat('dd-MM-yyyy').format(selectedDate),
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
        IconButton(
            onPressed: () {
              selectedDate = selectedDate.add(Duration(days: 1));
              setState(() {
                _selectedDate = selectedDate;
              });
            },
            icon: Icon(Icons.arrow_forward_ios_sharp))
      ],
    );
  }

  Widget _workWidget(
    String name,
    String street,
    double price,
    String hour,
    String city,
    String status,
    DateTime date,
  ) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Slidable(
        endActionPane: ActionPane(motion: ScrollMotion(), children: [
          SlidableAction(
            icon: Icons.delete,
            label: 'delete',
            backgroundColor: Colors.black,
            borderRadius: BorderRadius.circular(30),
            onPressed: (context) {},
          ),
          SlidableAction(
            icon: status == 'todo' ? Icons.done : Icons.close,
            backgroundColor: Colors.orange,
            borderRadius: BorderRadius.circular(30),
            label: status == 'todo' ? 'done' : 'todo',
            onPressed: (context) {
              if (status == 'done') {
                setState(() {
                  status == 'todo';
                });
              } else {
                setState(() {
                  status == 'done';
                });
              }
              print(status);
            },
          )
        ]),
        child: Container(
          width: _deviceWidth! * 0.9,
          height: _deviceHeight! * 0.11,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(street),
                        Text(city)
                      ],
                    ),
                    Column(
                      children: [
                        Text(price.toString() + ' zł'),
                        SizedBox(
                          height: 10,
                        ),
                        Text(hour)
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: status == 'todo'
                                  ? Color.fromARGB(255, 255, 137, 128)
                                  : Color.fromARGB(255, 123, 225, 124),
                              borderRadius: BorderRadius.circular(20)),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
