import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //Api key / chave de acesso
  final _weatherService = WeatherService('YOUR_KEY');
  Weather? _weather;

  String pathAssets = 'assets';
  String statusWeather = 'loagind..';
  String iconStatus = 'assets/loading.json';
  Color? navColor = Colors.white;
  Color? bodyBg = Colors.white;
  Color? textLabel = Colors.black;
  String textNav = "loading";

  //Leitura do tempo/ fetch weather
  _fetchWeather() async {
    //Get City / buscar cidade
    String cityName = await _weatherService.getCurrentCity();

    //get weather for city / Buscar tempo da cidade
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        getAnimation(weather.mainCondition);
      });
    } catch (e) {
      print(e);
    }
  }

  void refreshData() {
    setState(() {
      pathAssets = 'assets';
      statusWeather = 'loagind..';
      iconStatus = 'assets/loading.json';
      navColor = Colors.white;
      bodyBg = Colors.white;
      textLabel = Colors.black;
      textNav = "loading";
    });

    _fetchWeather();
  }

  void getAnimation(String? mainCondition) {
    setState(() {
      if (mainCondition == null) {
        iconStatus = '$pathAssets/loading.json';
      } else {
        textNav = mainCondition;
      }

      switch (mainCondition?.toLowerCase()) {
        case 'clouds':
        case 'mist':
        case 'smoke':
        case 'haze':
        case 'dust':
        case 'fog':
          textLabel = Colors.white;
          navColor = Colors.grey;
          bodyBg = Colors.grey[500];
          iconStatus = '$pathAssets/windy.json';
          break;
        case 'rain':
        case 'drizzle':
        case 'shower rain':
          navColor = Colors.black;
          bodyBg = Colors.black;
          textLabel = Colors.white;
          iconStatus = '$pathAssets/thunder.json';
          break;
        case 'thunderstorm':
          navColor = Colors.black;
          bodyBg = Colors.black;
          textLabel = Colors.white;
          iconStatus = '$pathAssets/storm.json';
          break;
        case 'clear':
          navColor = Colors.white;
          bodyBg = Colors.white;
          textLabel = Colors.black;
          iconStatus = '$pathAssets/sunny.json';
          break;
        default:
          navColor = Colors.white;
          bodyBg = Colors.white;
          textLabel = Colors.black;
          iconStatus = '$pathAssets/sunny.json';
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    //Init to job / Iniciar junto serviço
    _fetchWeather();

    //Get data for X seconds
    Timer.periodic(const Duration(seconds: 15), (timer) {
      _fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          textNav,
          style: TextStyle(
            color: textLabel,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                refreshData();
              },
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
              )),
        ],
        centerTitle: true,
        backgroundColor: navColor,
      ),
      backgroundColor: bodyBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //City / cidade
            Text(
              _weather?.cityName ?? "loading..",
              style: TextStyle(color: textLabel, fontSize: 25),
            ),

            //Animation / Animação

            Lottie.asset(iconStatus, height: 500),

            //Temperature / temperatura
            Text(
              (_weather != null) ? '${_weather?.temperature.round()} °C' : '',
              style: TextStyle(color: textLabel, fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
