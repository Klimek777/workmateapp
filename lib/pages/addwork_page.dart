import 'package:flutter/material.dart';

class Product {
  String name;
  int quantity;
  double price;

  Product({required this.name, required this.quantity, required this.price});

  double getTotalPrice() {
    return quantity * price;
  }
}

class AddWrok extends StatefulWidget {
  const AddWrok({super.key});

  @override
  State<AddWrok> createState() => _AddWrokState();
}

class _AddWrokState extends State<AddWrok> {
  double? _deviceHeight, _deviceWidth, _price;
  String? _name, _phone, _address, _serviceName;
  int? _q;
  List<Widget> _serviceWidgets = [];
  List<Product> _products = [];

  double getTotalOrderPrice() {
    double total = 0.0;
    for (Product product in _products) {
      total += product.getTotalPrice();
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
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
          _notesWidget()
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

  Widget _addServiceWidget({int? index}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Product name',
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Qty',
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
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
                  _serviceWidgets.removeAt(index);
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
        for (int i = 0; i < _serviceWidgets.length; i++) ...[
          _addServiceWidget(index: i),
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
              _serviceWidgets
                  .add(_addServiceWidget()); // dodaj nowy widget do listy
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
}
