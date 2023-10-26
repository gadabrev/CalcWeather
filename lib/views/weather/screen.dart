import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:test_project/core/globals.dart';
import 'package:test_project/core/material.dart';
import 'package:test_project/core/http.dart';
import 'package:test_project/views/weather/card.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreen createState() => _WeatherScreen();
}

class _WeatherScreen extends State<WeatherScreen> {
  FocusNode _focusSearch = FocusNode();

  String city = '';
  Map<String, dynamic> weather_info = {};
  bool city_exist = false;

  getWetaherInfo(String city) async {
    http.getWheather(city).then((response) async {
      setSafe(setState, () {
        weather_info = response;
        if (weather_info['cod'] == 200) city_exist = true;
        if (weather_info['cod'] == '404') {
          Alert.errorTryAgain(
            text: weather_info['message'],
            accept: () {
              _focusSearch.requestFocus();
            },
          );
          city_exist = false;
        }
      });
    }).catchError((err) {
      city_exist = false;
      Alert.errorAgain(
        text: err.toString(),
        accept: () {},
      );
    });
  }

  Timer? timer;
  startTimerForGetWeatherInfo() {
    print('TIMER START');
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (city_exist) {
        print('TIMER');
        getWetaherInfo(city);
      }
    });
  }

  @override
  void initState() {
    startTimerForGetWeatherInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Alert.ready(context);

    return ScrollScreen(
      padding: const EdgeInsets.only(left: 30, top: 10, right: 30, bottom: 0),
      useGesture: true,
      children: [
        if (!city_exist) ...[
          Padding(padding: EdgeInsets.only(top: 50)),
          TextField(
            focusNode: _focusSearch,
            textInputAction: TextInputAction.search,
            maxLines: 1,
            cursorHeight: 19,
            cursorColor: Colors.black,
            style: const TextStyle(
              decoration: TextDecoration.none,
              color: Colors.black,
              fontSize: 19,
            ),
            onSubmitted: (value) {
              if (value != '') {
                city = value;
                getWetaherInfo(value);
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zа-яА-Я-]')),
            ],
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black,
                size: 25,
              ),
              hintText: 'Введите название города',
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 19,
              ),
              contentPadding: EdgeInsets.symmetric(),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(
                    color: Color.fromARGB(255, 186, 39, 94), width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(
                    color: Color.fromARGB(255, 114, 1, 44), width: 4),
              ),
            ),
          ),
        ],
        if (city_exist && weather_info.isNotEmpty) ...[
          Center(
            child: Column(
              children: [
                Container(
                  height: 70,
                  child: Stack(
                    children: [
                      Center(child: CityText(city: city)),
                      Align(
                        alignment: Alignment.topRight,
                        child: RawButton(
                          onPressed: () {
                            setState(() {
                              city_exist = false;
                            });
                          },
                          child: Icon(
                            Icons.cancel_outlined,
                            size: 36,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                TemperatureText(
                    temp: '${weather_info['main']['temp'].round()}'),
                DescriptionText(
                    text: '${weather_info['weather'][0]['description']}'),
                Padding(padding: EdgeInsets.only(top: 10)),
                MinMaxTemperatureText(
                  min: weather_info['main']['temp_min'].round().toString(),
                  max: weather_info['main']['temp_max'].round().toString(),
                ),
                Padding(padding: EdgeInsets.only(top: 50)),
                Container(
                  width: double.infinity,
                  height: 320,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runAlignment: WrapAlignment.spaceBetween,
                    children: [
                      CustomCard(
                          title: 'ВЕТЕР',
                          icon: CupertinoIcons.wind,
                          value: '${weather_info['wind']['speed']} м/с'),
                      CustomCard(
                          title: 'ВЛАЖНОСТЬ',
                          icon: CupertinoIcons.drop,
                          value: '${weather_info['main']['humidity']}%'),
                      CustomCard(
                          title: 'ВИДИМОСТЬ',
                          icon: CupertinoIcons.eye_fill,
                          value:
                              '${(weather_info['visibility'] / 1000).round()} км'),
                      CustomCard(
                          title: 'ОЩУЩАЕТСЯ КАК',
                          icon: CupertinoIcons.thermometer,
                          value:
                              '${weather_info['main']['feels_like'].round()}°C'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        Padding(padding: EdgeInsets.only(top: 50)),
      ],
    );
  }
}
