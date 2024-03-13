import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../services/firebase_service.dart';

class WorkDetailsPage extends StatefulWidget {
  const WorkDetailsPage({
    super.key,
    required String name,
    required String address,
    required String sum,
    required String time,
    required String city,
    required String status,
    required String date,
    required String documentId,
    required String phone,
    required String notes,
    required String product,
  });

  @override
  State<WorkDetailsPage> createState() => _WorkDetailsPageState();
}

class _WorkDetailsPageState extends State<WorkDetailsPage> {
  double? _deviceHeight, _deviceWidth;
  FirebaseService? _firebaseService;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _headWidget(arguments['name']),

          SizedBox(
            height: _deviceHeight! * 0.15,
          ),
          _customerCardWidget(
              arguments['name'],
              arguments['address'],
              arguments['sum'],
              arguments['time'],
              arguments['city'],
              arguments['status'],
              arguments['date'],
              arguments['phone'],
              arguments['notes'],
              arguments['product'],
              arguments['documentID'])
          // _customerCardWidget()
        ],
      ),
    ));
  }

  Widget _headWidget(String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Details about ' + name,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                size: 30,
              )),
        ],
      ),
    );
  }

  Widget _customerCardWidget(
    String name,
    String address,
    String sum,
    String time,
    String city,
    String status,
    String date,
    String phone,
    String notes,
    String product,
    String documentId,
  ) {
    if (product.contains(',')) {
      product = product.replaceAll(',', '\n');
      product = product.replaceAll('[', ' ');
      product = product.replaceAll(']', '');
    } else {
      product = product.replaceAll('[', '');
      product = product.replaceAll(']', '');
    }

    if (status == 'todo') {
      status = 'to do';
    }
    return Container(
      width: _deviceWidth! * 0.90,
      decoration: BoxDecoration(
          color: Colors.orange, borderRadius: BorderRadius.circular(40)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      'Personal Info: ',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      name,
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(address,
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    Text(city,
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    Text(phone,
                        style: TextStyle(color: Colors.white, fontSize: 15))
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Service info:',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(time,
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    Text(status,
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    Text(product,
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    Text(sum + ' pln ',
                        style: TextStyle(color: Colors.white, fontSize: 15))
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, 'edit', arguments: {
                    'name': name,
                    'phone': phone,
                    'address': address,
                    'city': city,
                    'time': time,
                    'date': date,
                    'product': product,
                    'notes': notes,
                    'status': status,
                    'documentId': documentId,
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(100)),
                  height: 50,
                  width: 50,
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //       color: Colors.black,
              //       borderRadius: BorderRadius.circular(100)),
              //   height: 50,
              //   width: 50,
              //   child: InkWell(
              //     onTap: () async {
              //       String newStatus = status == 'to do' ? 'done' : 'todo';
              //       bool success = await _firebaseService!
              //           .updateStatus(documentId, newStatus);
              //       if (success) {
              //         setState(() {
              //           status = newStatus;
              //           print('staus updated for' + status);
              //         });
              //       }
              //     },
              //     child: Icon(
              //       status == 'to do' ? Icons.done : Icons.close,
              //       color: Colors.white,
              //       size: 30,
              //     ),
              //   ),
              // ),
              // Container(
              //   decoration: BoxDecoration(
              //       color: Colors.black,
              //       borderRadius: BorderRadius.circular(100)),
              //   height: 50,
              //   width: 50,
              //   child: Icon(
              //     Icons.pin_drop,
              //     color: Colors.white,
              //   ),
              // ),
              InkWell(
                onTap: () async {
                  await launchUrl(Uri.parse("tel:$phone"));
                  print('phone');
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(100)),
                  height: 50,
                  width: 50,
                  child: Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            notes,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  void _refreshData() {
    setState(() {});
  }
}
