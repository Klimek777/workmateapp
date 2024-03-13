// ignore_for_file: prefer_final_fields, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../services/firebase_service.dart';

class EditDeatilsPage extends StatefulWidget {
  const EditDeatilsPage({
    super.key,
    required String name,
    required String phone,
    required String address,
    required String city,
    required String time,
    required String date,
    required String product,
    required String notes,
    required String status,
  });

  @override
  State<EditDeatilsPage> createState() => _EditDeatilsPageState();
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
    return serviceNameController!.text +
        'x' +
        quantityController!.text +
        'x' +
        priceController!.text;
  }
}

class _EditDeatilsPageState extends State<EditDeatilsPage> {
  FirebaseService? _firebaseService;
  final GlobalKey<FormState> _workFormKey = GlobalKey<FormState>();
  double? _deviceHeight, _deviceWidth, _totalSum;
  // ignore: unused_field
  String? _name, _phone, _city, _address, _notes, _serviceName, documentId;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  TextEditingController _statusController = TextEditingController();

  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    print(_serviceList);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _nameController.text = arguments['name'];
    _phoneController.text = arguments['phone'];
    _addressController.text = arguments['address'];
    _cityController.text = arguments['city'];
    _timeController.text = arguments['time'];
    _dateController.text = arguments['date'];
    _notesController.text = arguments['notes'];
    documentId = arguments['documentId'];
    _statusController.text = arguments['status'];

    var product = arguments['product'];

    if (product is String) {
      // Split the string by newline characters and remove any leading/trailing whitespace
      var productLines = product.split('\n').map((line) => line.trim());
      _productList = productLines.toList();
      for (int i = 0; i < _productList.length; i++) {
        var _serviceNameController =
            TextEditingController(text: _productList[i].split('x')[0]);
        var _quantityController =
            TextEditingController(text: _productList[i].split('x')[1]);
        var _priceController =
            TextEditingController(text: _productList[i].split('x')[2]);

        _serviceList.add(Service(
            serviceNameController: _serviceNameController,
            quantityController: _quantityController,
            priceController: _priceController));
      }
    }

    _calculateFinalSum();
    print(arguments['documentId']);
  }

  List _productList = [];
  List<Service> _serviceList = [];

  @override
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
        )),
      )),
    );
  }

  Widget _headWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Edit Customer Info',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              size: 30,
            ),
          ),
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
            SizedBox(
              height: 10,
            ),
            _serviceListWidget(),
            SizedBox(
              height: 10,
            ),
            _sumWidget(_totalSum),
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
            _saveButton(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _nameTextField() {
    return TextFormField(
      controller: _nameController,
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
          _nameController.text = _value!;
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
        if (value.length > 9) {
          value = value.substring(0, 9); // limit to 9 digits
        }
        if (value.length > 3) {
          value = value.replaceRange(3, value.length, ' ' + value.substring(3));
        }
        if (value.length > 7) {
          value = value.replaceRange(7, value.length, ' ' + value.substring(7));
        }
        _phoneController.value = TextEditingValue(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
        );
      },
      onSaved: (_value) {
        setState(() {
          _phoneController.text = _value!;
        });
      },
    );
  }

  Widget _adressTextField() {
    return TextFormField(
      controller: _addressController,
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
          _addressController.text = _value!;
        });
      },
    );
  }

  Widget _cityTextField() {
    return TextFormField(
      controller: _cityController,
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
          _cityController.text = _value!;
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
                  print(_serviceList);
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
          _serviceWidget(index: i, service: _serviceList[i]),
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
              print(_serviceList);
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
        controller: _notesController,
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
            _notesController.text = _value!;
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
            'Update',
            style: TextStyle(color: Colors.white),
          )),
          width: 60,
          height: 30,
        ),
        onPressed: () async {
          _updateWork();
        });
  }

  void _updateWork() async {
    _workFormKey.currentState!.save();
    try {
      bool success = await _firebaseService!.updateWork(
          documentId.toString(),
          _nameController.text,
          _phoneController.text,
          _addressController.text,
          _cityController.text,
          _timeController.text,
          _dateController.text,
          _serviceList.toString(),
          _notesController.text,
          _totalSum.toString(),
          _statusController.text);

      if (success) {
        print('Document updated with id: $documentId');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.orange,
              content: Text('Data successfully updated')),
        );
        Navigator.pop(context, true);
      } else {
        print('Error adding document');
      }
    } catch (e) {
      print(e);
    }
  }
}
