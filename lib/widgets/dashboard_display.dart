import 'package:airhere/animations/animated_aqi.dart';
import 'package:airhere/widgets/descriptions.dart';
import 'package:airhere/widgets/pollutant_card.dart';
import 'package:flutter/material.dart';

class Display extends StatefulWidget {
  Display({this.data});
  final data;
  @override
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> {

  List<Color> _gradient(aqi){
    List<Color> gradient;
    if (aqi >= 0 && aqi < 51) {
      gradient = [
        Colors.greenAccent[100],
        Colors.green[700]
      ];
    } else if (aqi >= 51 && aqi < 101) {
      gradient = [
        Colors.yellowAccent[100],
        Colors.yellow[600]
      ];
    } else if (aqi >= 101 && aqi < 151) {
      gradient = [
        Colors.orangeAccent[100],
        Colors.orange[700]
      ];
    } else if (aqi >= 151 && aqi < 200) {
      gradient = [
        Colors.redAccent[100],
        Colors.red[700]
      ];
    } else if (aqi >= 200 && aqi < 301) {
      gradient = [
        Colors.purpleAccent[100],
        Colors.purple[700]
      ];
    } else if (aqi >= 301) {
      gradient = [
        Color.fromARGB(255, 126, 0, 35),
        Color.fromARGB(255, 123, 44, 66)
      ];
    } 

    return gradient;
  }

  ScrollController _titleController = ScrollController();

  Widget displayedPollutants() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                controller: _titleController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Text(
                      widget.data['position'],
                      style: TextStyle(
                          fontSize: 40
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 8,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        AnimatedValue(aqiValue: int.parse(widget.data['aqi']),)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: PollutantCard(
                name: "PM₂.₅",
                level: widget.data["pm25"],
              ),
            ),
            Expanded(
              child: PollutantCard(
                name: "PM₁₀",
                level: widget.data["pm10"],
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: PollutantCard(
                name: "NO₂",
                level: widget.data["no2"],
              ),
            ),
            Expanded(
              child: PollutantCard(
                name: "o₃",
                level: widget.data["o3"],
              ),
            )
          ],
        ),
      ],
    );
  }


  PageController pageController;

  Text currentText = Text("Information");
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: 0,
      keepPage: true,
      viewportFraction: 1
    );
    pageController.addListener(() {
      int next = pageController.page.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
          if (currentPage == 0)
            currentText = Text("Information");
          if (currentPage == 1)
            currentText = Text("Today's air");
        });
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void changePage(int pageNumber) {
    if (pageNumber == 0) {
      pageController.animateToPage(1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut,);
    }
    if (pageNumber == 1) {
      pageController.animateToPage(0, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut,);
    }
  }


  Descriptions descriptions = Descriptions();

  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _gradient(int.parse(widget.data["aqi"])),
            end: Alignment.bottomRight,
            begin: Alignment.topLeft,
          )
        ),
        child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Color.fromRGBO(0, 67, 164, 1),
            heroTag: null,
            onPressed: () => changePage(currentPage),
            label: currentText,
          ),
          backgroundColor: Colors.transparent,
          body: PageView(
            controller: pageController,
            scrollDirection: Axis.vertical,
            pageSnapping: true,
            children: <Widget>[
              displayedPollutants(),
              Container(
                width: MediaQuery.of(context).size.width-20,
                child: descriptions
              )
            ],
          ),
        ),
      ),
    );
  }
}

