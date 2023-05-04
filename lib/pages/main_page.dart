import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../services/firebase_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double? _deviceHeight, _deviceWidth;
  DateTime _selectedDate = DateTime.now();
  FirebaseService? _firebaseService;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    print(_selectedDate);
  }

  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, 'add_work');
        },
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
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: work.length,
            //     itemBuilder: (context, index) {
            //       return work[index];
            //     },
            //   ),
            // )
            _worksListView(DateFormat('yyyy-MM-dd').format(_selectedDate))
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
              DateFormat('yyyy-MM-dd').format(selectedDate),
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
    String price,
    String hour,
    String city,
    String status,
    String date,
    String documentId,
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
            onPressed: (context) async {
              try {
                await _firebaseService!.deleteWork(documentId);
                print('Deleted document with id:' + documentId);
              } catch (e) {
                print(e);
              }
            },
          ),
          SlidableAction(
            icon: status == 'todo' ? Icons.done : Icons.close,
            backgroundColor: Colors.orange,
            borderRadius: BorderRadius.circular(30),
            label: status == 'todo' ? 'done' : 'todo',
            onPressed: (context) async {
              String newStatus = status == 'todo' ? 'done' : 'todo';
              bool success =
                  await _firebaseService!.updateStatus(documentId, newStatus);
              if (success) {
                setState(() {
                  status = newStatus;
                });
              }
            },
          )
        ]),
        child: Container(
          width: _deviceWidth! * 0.9,
          height: _deviceHeight! * 0.11,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black),
            color: Colors.grey[100],
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

  Widget _worksListView(String date) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firebaseService!.getWorkForUser(date),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List _workposts = snapshot.data!.docs.map((e) => e.data()).toList();
            _workposts.sort((a, b) => a["time"].compareTo(b["time"]));
            return ListView.builder(
                itemCount: _workposts.length,
                itemBuilder: (context, index) {
                  Map _work = _workposts[index];
                  String documentId = snapshot.data!.docs[index].id;
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'details', arguments: {
                        'name': _work["name"],
                        'address': _work["address"],
                        'sum': _work["sum"],
                        'time': _work["time"],
                        'city': _work["city"],
                        'status': _work["status"],
                        'date': _work["date"],
                        'documentId': documentId,
                        'phone': _work["phone"],
                        'notes': _work["notes"],
                        'product': _work["product"]
                      });
                    },
                    child: _workWidget(
                        _work["name"],
                        _work["address"],
                        _work["sum"],
                        _work["time"],
                        _work["city"],
                        _work["status"],
                        _work["date"],
                        documentId),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
          }
        },
      ),
    );
  }
}
