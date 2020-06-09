import 'package:airhere/data/library_provider.dart';
import 'package:airhere/pages/dashboard.dart';
import 'package:airhere/pages/library.dart';
import 'package:airhere/pages/map.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class Top extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LibraryProvider(),
      child: App(),
    );
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  List<Widget> _pages = <Widget>[
    Center(child: Map()),
    Center(child: Dashboard()),
    Center(child: Library2()),
  ];

  int _selectedIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  }

  @override
  Widget build(BuildContext context) {
    final libraryProvider = Provider.of<LibraryProvider>(context);
    return Scaffold(
      body: PageView(
        pageSnapping: true,
        children: _pages,
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              duration: Duration(milliseconds: 100),
              tabBackgroundColor: Color.fromRGBO(0, 67, 164, 1),
              curve: Curves.linear,
              tabs: [
                GButton(
                  icon: LineIcons.map,
                  text: "Map",
                ),
                GButton(
                  icon: LineIcons.cloud,
                  text: "Dashboard",
                ),
                GButton(
                  icon: LineIcons.save,
                  text: "Library",
                )
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                if (index == 2) {
                  libraryProvider.getSavedPlaces();
                }
                setState(() {
                  _selectedIndex = index;
                  _pageController.animateToPage(_selectedIndex,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.ease);
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
