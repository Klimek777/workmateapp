import 'package:flutter/material.dart';
import 'package:workmateapp/pages/charts_page.dart';
import 'package:workmateapp/pages/main_page.dart';
import 'package:workmateapp/pages/schedule_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;
  int _currentPage = 0;

  final List<Widget> _pages = [MainPage(), SchedulePage(), ChartsPage()];

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        bottomNavigationBar: _bottomNavigationBar(),
        body: _pages[_currentPage]);
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentPage,
      onTap: (_index) {
        setState(() {
          _currentPage = _index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: 'Schedule',
          icon: Icon(Icons.calendar_month),
        ),
        BottomNavigationBarItem(
          label: 'Charts',
          icon: Icon(Icons.insights),
        ),
      ],
    );
  }
}
