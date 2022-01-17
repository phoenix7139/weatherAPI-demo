// ignore_for_file: prefer_const_constructors

import 'package:demo_app/pages/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var latitude;
  var longitude;
  late String place;
  late String weather;
  late String tempmax;
  late String tempmin;

  bool showloading = false;

  getLocation() async {
    setState(() {
      showloading = true;
    });
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude = position.latitude;
    longitude = position.longitude;
    print(latitude);
    print(longitude);
    WeatherFactory wf = WeatherFactory("ec07fb4219544f607cb849b87636b473");
    Weather w = await wf.currentWeatherByLocation(latitude, longitude);
    print(w);
    place = w.areaName!;
    weather = w.weatherDescription!;
    tempmax = w.tempMax.toString();
    tempmin = w.tempMin.toString();
    setState(() {
      showloading = false;
    });
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  final _auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(0),
        color: Colors.black,
        child: showloading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      place,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7), fontSize: 23),
                    ),
                    Text(
                      tempmax,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7), fontSize: 23),
                    ),
                    Text(
                      tempmin,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7), fontSize: 23),
                    ),
                    Text(
                      weather,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7), fontSize: 23),
                    )
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _auth.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => (AuthPage()),
            ),
          );
        },
        child: Icon(Icons.logout_rounded),
      ),
    );
  }
}
