import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:live_weather_data/CurrentCity.dart';
import 'package:live_weather_data/DifferentCity.dart';
import 'location.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(WeatherApp());
}
const apiKey = '3d7503cb15b11993475bb6a85b5a0e88';

class WeatherApp extends StatefulWidget {



  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {

  String submittedCity;

  double latitude;
  double longitude;
  String description="";
  double temperature=0.0;
  String weatherIcon;
  String cityName="Error";
  String icon='10d';

  @override
  void initState(){

    super.initState();
    getLocation();

  }

  void getLocation() async {
    Location location=Location();
    await location.getCurrentLocation();

    latitude=location.latitude;
    longitude=location.longitude;

    CurrentCityNetwork helper=CurrentCityNetwork(url:'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');
    var weatherData=await helper.getData();
    updateUI(weatherData);
    print(weatherData);
  }

  void updateUI(dynamic weatherData){
    setState(() {
      temperature = weatherData['main']['temp'].toDouble();
      icon = weatherData['weather'][0]['icon'];
      cityName = weatherData['name'];
      description=weatherData['weather'][0]['description'];
    });


  }

  void updateUI2(String city) async{


    if(city==null){
      setState(() {
        icon='10d';
        cityName ="You have not entered any city...";
        temperature=0;
      });
      return;
    }


    DifferentCityNetwork helper2=DifferentCityNetwork(url:'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');
    var weatherData=await helper2.getData();
    print(weatherData);

    if(weatherData!=null) {
      setState(() {
        temperature = weatherData['main']['temp'].toDouble();
        icon = weatherData['weather'][0]['icon'];
        cityName = weatherData['name'];
        description=weatherData['weather'][0]['description'];

      });
    }
    else{
      setState(() {
        temperature=0;
        cityName="You have entered wrong city";
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
          child: Scaffold(
            backgroundColor: Color(0xFFe3e3e3),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      child: Image.network('http://openweathermap.org/img/wn/$icon@2x.png',),
                    ),
                    Center(
                      child: Text(
                        temperature.toInt().toString() + ' °C',
                        style: TextStyle(
                            color: Colors.black, fontSize: 60.0),
                      ),
                    ),
                    Center(
                      child: Text(
                        description,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        cityName,
                        style: TextStyle(
                            color: Colors.black, fontSize: 40.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: 300,
                      child: TextField(
                        style:
                        TextStyle(color: Colors.black, fontSize: 25),
                        decoration: InputDecoration(
                          hintText: 'Search another location...',
                          hintStyle: TextStyle(
                              color: Colors.black, fontSize: 18.0),
                          prefixIcon:
                          Icon(Icons.search, color: Colors.black),
                        ),
                        onSubmitted: (value){
                          updateUI2(value);
                        },
                        onChanged: (value){
                          submittedCity=value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                          onPressed: () {
                            updateUI2(submittedCity);
                          },
                          child: Text(
                            'Get Weather',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        FlatButton(
                          onPressed: () async{
                            await getLocation();
                          },
                          child: Text(
                            'Reload Weather',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('images/git.png',
                          height: 30,
                          width: 30,
                        ),
                        Text(
                          "thesagargoyal",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

