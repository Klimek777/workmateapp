import 'package:flutter/material.dart';

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

  @override
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
              arguments['product'])
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      String product) {
    if (product.contains(',')) {
      product = product.replaceAll(',', '\n');
      product = product.replaceAll('[', '');
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
      height: _deviceHeight! * 0.40,
      decoration: BoxDecoration(
          color: Colors.orange, borderRadius: BorderRadius.circular(40)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Text(name),
                      Text(address),
                      Text(city),
                      Text(phone)
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
                      Text(time),
                      Text(status),
                      Text(product),
                      Text(sum + ' pln ')
                    ],
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
