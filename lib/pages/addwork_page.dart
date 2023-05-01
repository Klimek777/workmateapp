// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../services/firebase_service.dart';

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

  @override
  String toString() {
    return serviceNameController!.text + ' x ' + quantityController!.text;
  }
}

class _AddWrokState extends State<AddWrok> {
  // ignore: unused_field
  double? _deviceHeight, _deviceWidth, _price, _totalSum;
  // ignore: unused_field
  String? _name, _phone, _city, _address, _notes, _serviceName;
  int? _q;
  List<Widget> _serviceWidgets = [];
  TextEditingController _serviceNameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  FirebaseService? _firebaseService;
  final GlobalKey<FormState> _workFormKey = GlobalKey<FormState>();

  late List<Service> _serviceList;
  StreamController<Service> _serviceController = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _serviceList = [];
    _dateController.text = "";
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
              children: [_headWidget(), _formWidget(), _saveButton()],
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
      child: Form(
        key: _workFormKey,
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
              height: 10,
            ),
            _cityTextField(),
            SizedBox(
              height: 10,
            ),
            _timeTextField(),
            SizedBox(
              height: 10,
            ),
            _dateTextField(),
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
            _sumWidget(_totalSum),
            SizedBox(
              height: 10,
            )
          ],
        ),
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
      controller: _phoneController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      keyboardType: TextInputType.number,
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
      onChanged: (value) {
        final number = int.tryParse(value.replaceAll(' ', ''));
        if (number != null) {
          final formatter = NumberFormat('# ###');
          final newText = formatter.format(number);
          final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
          final formattedText =
              newText.replaceAllMapped(regex, (Match m) => '${m[1]} ');
          if (formattedText != value) {
            _phoneController.value = TextEditingValue(
              text: formattedText,
              selection: TextSelection.collapsed(offset: formattedText.length),
            );
          }
        }
      },
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

  Widget _cityTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: "City...",
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
          _city = _value;
        });
      },
    );
  }

  Widget _timeTextField() {
    return TextField(
      onTap: () async {
        TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );
        if (picked != null) {
          print(
              picked); //get the picked date in the format => 2022-07-04 00:00:00.000

          setState(() {
            _timeController.text =
                '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
          });
        } else {
          print("Date is not selected");
        }
      },
      readOnly: true,
      controller: _timeController,
      decoration: const InputDecoration(
        hintText: "Choose the time...",
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
    );
  }

  Widget _dateTextField() {
    return TextField(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(), //get today's date
            firstDate: DateTime(
                2000), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101));
        if (pickedDate != null) {
          print(
              pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
          String formattedDate = DateFormat('yyyy-MM-dd').format(
              pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
          print(
              formattedDate); //formatted date output using intl package =>  2022-07-04
          //You can format date as per your need

          setState(() {
            _dateController.text =
                formattedDate; //set foratted date to TextField value.
          });
        } else {
          print("Date is not selected");
        }
      },
      readOnly: true,
      controller: _dateController,
      decoration: const InputDecoration(
        hintText: "Enter Date",
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
    );
  }

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
            icon: Icon(Icons.close))
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
        MaterialButton(
          child: Container(
            width: 120,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Center(
              child: Text(
                'Add Product',
                style: TextStyle(color: Colors.white),
              ),
            ),
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
    return TextFormField(
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
        onSaved: (_value) {
          setState(() {
            _notes = _value;
          });
        });
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

  Widget _saveButton() {
    return MaterialButton(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
              child: Text(
            'Save',
            style: TextStyle(color: Colors.white),
          )),
          width: 60,
          height: 30,
        ),
        onPressed: () async {
          _postWork();
        });
  }

  void _postWork() async {
    _workFormKey.currentState!.save();
    try {
      bool success = await _firebaseService!.postWork(
          _name!,
          _phone!,
          _address!,
          _city!,
          _timeController.text,
          _dateController.text,
          _serviceList.toString(),
          _notes,
          _totalSum.toString(),
          'todo');

      if (success) {
        String documentId = _firebaseService!.getDocumentId()!;
        print('Document added with id: $documentId');
        Navigator.pop(context);
      } else {
        print('Error adding document');
      }
    } catch (e) {
      print(e);
    }
  }
}
