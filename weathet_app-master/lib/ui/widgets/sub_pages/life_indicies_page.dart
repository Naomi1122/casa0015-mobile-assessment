import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(249, 247, 188, 241),
        title: const Text('Life Indicies'),
      ),
      body: Center(
        child: WeatherIndexWidget(),
      ),
    );
  }
}
// GridView.count(
//   crossAxisCount: 2,
//   children: [
//     Center(child: WeatherIndexWidget()),
//     Center(child: Text('Widget 2')),
//     Center(child: Text('Widget 3')),
//     Center(child: Text('Widget 4')),
//   ],
// ),

class WeatherIndexWidget extends StatefulWidget {
  @override
  _WeatherIndexWidgetState createState() => _WeatherIndexWidgetState();
}

class _WeatherIndexWidgetState extends State<WeatherIndexWidget> {
  Map<String, dynamic> data = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Future<void> fetchData() async {
  //   final response = await http.get(Uri.parse(
  //       'https://devapi.qweather.com/v7/indices/1d?type=1,2,5&location=BA333&key=3750971dc4f04622ad1ee2f8757e16ae&lang=en'));
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       data = json.decode(response.body);
  //       isLoading = false;
  //     });
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }
  Future<void> fetchData() async {
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final String lat = position.latitude.toString();
    //print(lat);
    final String lon = position.longitude.toString();
    //print(lon);
    final geoUrl = Uri.parse(
        'https://geoapi.qweather.com/v2/city/lookup?location=$lon,$lat&key=APPKEY');
    final geoResponse = await http.get(geoUrl);
    final locationData = json.decode(geoResponse.body)['location'][0];
    final locationid = locationData['id'];
    print(locationid);

    // Get weather data for the location from the weather API
    final weatherUrl = Uri.parse(
        'https://devapi.qweather.com/v7/indices/1d?type=1,2,5&location=BA333&key=APPKEY&lang=en');
    final weatherResponse = await http.get(weatherUrl);

    if (weatherResponse.statusCode == 200) {
      setState(() {
        data = json.decode(weatherResponse.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
  //   final response = await http.get(Uri.parse(
  //       'https://devapi.qweather.com/v7/indices/1d?type=1,2,5&location=37.78,-122.40&key=3750971dc4f04622ad1ee2f8757e16ae&lang=en'));
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       data = json.decode(response.body);
  //       isLoading = false;
  //     });
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : SingleChildScrollView(
            child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                height: 380,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sports_soccer, size: 40),
                    SizedBox(height: 10),
                    Text(
                      'Sport Index',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 7),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'The sport index is to consider the impact of meteorological factors and the environment on the human body, including ultraviolet rays, wind, air pressure, temperature, light, rain, snow, sand and dust, etc., to provide suggestions on whether it is suitable for ordinary people to exercise.\nThe sport index is divided into 3 grades, the higher the grade, the less suitable for sports.',
                        style: TextStyle(fontSize: 15, color: Colors.amber[50]),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Level: ${data['daily'][0]['level']}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Category: ${data['daily'][0]['category']}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 400,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_car_wash, size: 40),
                    SizedBox(height: 10),
                    Text(
                      'Car Wash',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 7),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'The car wash index is based on whether there is rain or snow in the past 12 hours and the next 48 hours, whether there is snow and muddy water on the road surface, whether it is easy to splash the car with muddy water, whether there is sand and dust and other weather conditions, to provide drivers and friends whether it is suitable for car washing weather index. \nThe car wash index is divided into 4 levels, the higher the level, the less suitable for car washing.',
                        style: TextStyle(fontSize: 15, color: Colors.amber[50]),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Level: ${data['daily'][1]['level']}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Category: ${data['daily'][1]['category']}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 380,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.beach_access, size: 40),
                    SizedBox(height: 10),
                    Text(
                      'UV Index',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 7),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'The UV index refers to the actual intensity of UV radiation when the sun is at its highest point in the sky on that day, which usually occurs in the four hours before or after solar noon, and can help people assess the possible damage caused by UV rays to the human body. \nThe UV index is generally represented by 0-11+, and the larger the value, the greater the harm of ultraviolet rays to the human body.',
                        style: TextStyle(fontSize: 15, color: Colors.amber[50]),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Level: ${data['daily'][2]['level']}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Category: ${data['daily'][2]['category']}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ));
  }
}
