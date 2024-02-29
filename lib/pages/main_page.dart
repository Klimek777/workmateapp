import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:workmateapp/pages/maps_page.dart';

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

  List? addreses;
  List? names;
  List<LatLng>? coordiantes;
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
        backgroundColor: Colors.orange,
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
        onPressed: () async {
          print(addreses);
          print(names);
          coordiantes = await getCoordinates(addreses!);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapPage(
                  coordinates: coordiantes!,
                  names: names!,
                  addreses: addreses!),
            ),
          );
        });
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
          SizedBox(
            width: 8,
          ),
          SlidableAction(
            icon: status == 'to do' ? Icons.done : Icons.close,
            backgroundColor: Colors.orange,
            borderRadius: BorderRadius.circular(30),
            onPressed: (context) async {
              String newStatus = status == 'to do' ? 'done' : 'to do';
              bool success =
                  await _firebaseService!.updateStatus(documentId, newStatus);
              if (success) {
                setState(() {
                  status = newStatus;
                  print('updated to new status with id' + documentId);
                });
              }
            },
          )
        ]),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            width: _deviceWidth! * 0.9,
            decoration: BoxDecoration(
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
                                color: status == 'to do'
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
      ),
    );
  }

  Widget _worksListView(String date) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firebaseService!.getWorkForUser(date),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List _workposts = snapshot.data!.docs.map((e) => e.data()).toList();
            return ListView.builder(
                itemCount: _workposts.length,
                itemBuilder: (BuildContext context, int index) {
                  Map _work = _workposts[index];
                  String documentId = snapshot.data!.docs[index].id;
                  addreses = createFullAddressList(_workposts);
                  names = createNameList(_workposts);

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
                        'phone': _work["phone"],
                        'notes': _work["notes"],
                        'product': _work["product"],
                        'documentID': documentId
                      });
                      print(_workposts[index]);
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

  String createFullAddress(String street, String city) {
    return '$street  $city';
  }

  List<String> createFullAddressList(List workPosts) {
    List<String> addressList = [];
    for (int i = 0; i < workPosts.length; i++) {
      Map<String, dynamic> work = workPosts[i];
      String street = work["address"];
      String city = work["city"];
      String fullAddress = createFullAddress(street, city);
      addressList.add(fullAddress);
    }

    return addressList;
  }

  List<String> createNameList(List workPosts) {
    List<String> nameList = [];
    for (int i = 0; i < workPosts.length; i++) {
      Map<String, dynamic> work = workPosts[i];
      String name = work['name'];
      nameList.add(name);
    }
    return nameList;
  }

  Future<List<LatLng>> getCoordinates(List addresses) async {
    List<LatLng> coordinatesList = [];

    for (int i = 0; i < addresses.length; i++) {
      LatLng coordinates =
          await _firebaseService!.getCoordinatesFromAddress(addresses[i]);
      coordinatesList.add(coordinates);
    }
    print(coordinatesList);
    return coordinatesList;
  }
}
