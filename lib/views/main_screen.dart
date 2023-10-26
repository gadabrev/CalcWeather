import 'package:test_project/core/material.dart';
import 'package:test_project/views/calculator/screen.dart';
import 'package:test_project/views/home/screen.dart';
import 'package:test_project/views/weather/screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  final List<String> items = ['ГЛАВНАЯ', 'КАЛЬКУЛЯТОР', 'ПОГОДА'];
  int _selectedTab = 0;
  onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calculate), label: 'Калькулятор'),
            BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Погода'),
          ],
          onTap: onSelectTab,
        ),
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: const Color.fromARGB(255, 114, 1, 44),
          title: AppBarText(title: items[_selectedTab]),
          centerTitle: true,
        ),
        body: IndexedStack(
          index: _selectedTab,
          children: [
            HomeScreen(),
            CalculatorScreen(),
            WeatherScreen(),
          ],
        ),
      ),
    );
  }
}
