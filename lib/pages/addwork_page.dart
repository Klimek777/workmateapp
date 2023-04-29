// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class AddWrok extends StatefulWidget {
  const AddWrok({super.key});

  @override
  State<AddWrok> createState() => _AddWrokState();
}

class Service {
  TextEditingController? serviceNameController;
  TextEditingController? quantityController;
  TextEditingController? priceController;

  Service({
    this.serviceNameController,
    this.quantityController,
    this.priceController,
  });
}

class _AddWrokState extends State<AddWrok> {
  // ignore: unused_field
  double? _deviceHeight, _deviceWidth, _price, _totalSum;
  // ignore: unused_field
  String? _name, _phone, _address, _serviceName;
  int? _q;
  List<Widget> _serviceWidgets = [];
  final _serviceNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  late List<Service> _serviceList;
  StreamController<Service> _serviceController = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    _serviceList = []; // <- utworzenie pustej listy w metodzie initState
  }

  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: _deviceWidth,
          height: _deviceHeight,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _headWidget(),
                _formWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Add Customer',
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

  Widget _formWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 30, left: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          _nameTextField(),
          SizedBox(
            height: 10,
          ),
          _phoneTextField(),
          SizedBox(
            height: 10,
          ),
          _adressTextField(),
          SizedBox(
            height: 20,
          ),
          Text(
            'Product',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          _serviceListWidget(),
          SizedBox(
            height: 10,
          ),
          Text(
            'Notes',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          _notesWidget(),
          SizedBox(
            height: 10,
          ),
          _sumWidget(_totalSum)
        ],
      ),
    );
  }

  Widget _nameTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: "Name...",
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.orange),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.orange),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
      onSaved: (_value) {
        setState(() {
          _name = _value;
        });
      },
    );
  }

  Widget _phoneTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: "Phone number...",
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.orange),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.orange),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
      onSaved: (_value) {
        setState(() {
          _phone = _value;
        });
      },
    );
  }

  Widget _adressTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: "Street addres + number...",
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.orange),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.orange),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
      onSaved: (_value) {
        setState(() {
          _address = _value;
        });
      },
    );
  }

  // Widget _datePickWidget(){

  // }

  Widget _serviceWidget({int? index, required Service service}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: service.serviceNameController,
            decoration: InputDecoration(
              hintText: 'Product name',
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            onChanged: ((value) => _calculateFinalSum()),
            controller: service.quantityController,
            decoration: InputDecoration(
              hintText: 'Qty',
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            onChanged: (value) => _calculateFinalSum(),
            controller: service.priceController,
            decoration: InputDecoration(
              hintText: 'Price',
            ),
          ),
        ),
        SizedBox(
          width: 2,
        ),
        IconButton(
            onPressed: () {
              setState(() {
                if (index != null) {
                  _serviceList.removeAt(index);
                  _calculateFinalSum();
                  print('deleted index: $index');
                }
              });
            },
            icon: Icon(Icons.delete))
      ],
    );
  }

  Widget _serviceListWidget() {
    return Column(
      children: [
        for (int i = 0; i < _serviceList.length; i++) ...[
          _serviceWidget(
            index: i,
            service: _serviceList[i],
          ),
          SizedBox(height: 10),
        ], // wyświetl istniejące widgety
        SizedBox(height: 10),
        ElevatedButton(
          child: Text(
            'Add Product',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            setState(() {
              _serviceList.add(Service(
                  serviceNameController: TextEditingController(),
                  quantityController: TextEditingController(),
                  priceController: TextEditingController()));
              _calculateFinalSum();
              // dodaj nowy widget do listy
            });
          },
        ),
      ],
    );
  }

  Widget _notesWidget() {
    return TextField(
      decoration: InputDecoration(
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.orange, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.orange, width: 2.0),
        ),
        border: OutlineInputBorder(),
        labelStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            letterSpacing: 2.0),
        hintText: 'Make some notes about your customer',
      ),
      keyboardType: TextInputType.multiline,
      minLines: 2,
      maxLines: 11,
    );
  }

  void _calculateFinalSum() {
    double sum = 0;
    for (int i = 0; i < _serviceList.length; i++) {
      double price =
          double.tryParse(_serviceList[i].priceController!.text) ?? 0;
      print(price);
      int quantity =
          int.tryParse(_serviceList[i].quantityController!.text) ?? 0;
      sum += price * quantity;
    }
    setState(() {
      _totalSum = sum;
    });
  }

  Widget _sumWidget(double? finalSum) {
    return Text('SUM = ' + _totalSum.toString() + ' pln');
  }
}
