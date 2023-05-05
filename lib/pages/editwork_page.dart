import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../services/firebase_service.dart';

class EditDeatilsPage extends StatefulWidget {
  const EditDeatilsPage(
      {super.key,
      required String name,
      required String phone,
      required String address,
      required String city,
      required String time,
      required String date});

  @override
  State<EditDeatilsPage> createState() => _EditDeatilsPageState();
}

class _EditDeatilsPageState extends State<EditDeatilsPage> {
  FirebaseService? _firebaseService;
  double? _deviceHeight, _deviceWidth, _price, _totalSum;
  // ignore: unused_field
  String? _name, _phone, _city, _address, _notes, _serviceName;
  int? _q;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _serviceNameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _nameController.text = arguments['name'];
    _phoneController.text = arguments['phone'];
    _addressController.text = arguments['address'];
    _cityController.text = arguments['city'];
    _timeController.text = arguments['time'];
    _dateController.text = arguments['date'];
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        width: _deviceWidth,
        height: _deviceHeight,
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [_headWidget(), _formWidget()],
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
              )),
        ],
      ),
    );
  }

  Widget _formWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 30, left: 30),
      child: Form(
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
          _phone = _value;
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
          _address = _value;
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
}
