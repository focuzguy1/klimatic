import 'dart:async';
import 'dart:convert';
//import 'dart:convert';
//import 'dart:html';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:http/http.dart';
import '../util/utils.dart' as util;

class Klimatic extends StatefulWidget {

  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String _cityEntered;

 // get Json => null;
 Future _goToNextScreen (BuildContext context) async{
   Map results = await Navigator.of(context).push(
     new MaterialPageRoute<Map>(
         builder: (BuildContext context) {
           return new ChangeCity();
 }));
   if(results != null && results.containsKey('enter')){
     _cityEntered = results["enter"];
     //debugPrint("print " + results['enter'].toString());
   }
 }

 // the showStuff here shows that it will get and print the weather and the defaultcity
  void showStuff() async {
    Map data = await getWeather(util.appId, util.defaultcity);
    print(data.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Klimatic'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
          actions: <Widget>[
          new IconButton(icon: new Icon(Icons.menu), onPressed: (){_goToNextScreen(context);})
        ]
      ),
        body: new Stack(
        children: <Widget>[
          new Center(
          child: new Image.asset('images/umbrella.png', width: 490.0, height: 1200.0, fit: BoxFit.fill,
            ),
          ),

          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            //we call the city here so it will be changing automatically
            child: new Text( // if we don't input any text here it will remain in our default state with is 'spokane'
              '${_cityEntered == null ? util.defaultcity: _cityEntered}',
            style: cityStyle(),
            ),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset('images/light_rain.png'), ),
          updateTempWidget(_cityEntered) // from widget updateTemoWidget is called here to display on the screen
          // contain which will have our weather forecast data
//          new Container(
//            //margin: const EdgeInsets.fromLTRB(30.0, 360.0, 0.0, 0.0),
//            child: updateTempWidget(_cityEntered),
//            //new Text('67.8F', style: tempStyle()),
//          )

        ],
      ),
    );
  }
// fetching data using api
 Future<Map> getWeather(String appId, String city) async{
String apiUrl = 'https://samples.openweathermap.org/data/2.5/weather?q=$city&appid='

  '${util.appId}';
//&units=imperial
// the api will get a response type
  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);

}

  Widget updateTempWidget(String city){
    //it allows us to receive daata from a future type
    return new FutureBuilder( // future builder allows us to receive data from a future type Future<Map>
      future: getWeather(util.appId, city == null ? util.defaultcity: city), // if the city is null 'then' it will return to d default city else City
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot){// snapshot is the data we are receiving from our future: getWeather
    // where we get all of the info of json data, we setup widgets etc.
      if(snapshot.hasData){
        Map content =  snapshot.data;
          return new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new ListTile(
                  title:new Text(content['main']['temp'].toString() + "F",
                  style: new TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 49.9,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),

          ),
              //THis page include the remaining weather condition such as humidity...
              subtitle: new ListTile(
                title: new Text(
                  //goto 'main' in the api and then 'humidity'
                  "Humidity: ${content['main']['humidity'].toString()}\n"
                      "Min: ${content['main']['temp_min'].toString()}F\n"
                      "Max: ${content['main']['temp_max'].toString()} F",
                  style: extraData(),

              ),
                  ),
                  )
              ],
            ),
          );
      }else {
        return new Container();
      }
      });
  }

}

class ChangeCity extends StatelessWidget {
  var _cityFieldController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Change State'),
        backgroundColor: Colors.red,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/white_snow.png', width: 490.0, height: 1200.0,fit: BoxFit.fill,),
          ),


          new ListView(
              children: <Widget>[
          new ListTile(
            title: new TextField(
              decoration: new InputDecoration(
                hintText: 'Enter City',
              ),
              controller: _cityFieldController,
              keyboardType: TextInputType.text,
            ),
          ),

          new ListTile(
            title: new FlatButton(onPressed: (){
              Navigator.pop(context,{
               "enter": _cityFieldController.text,
              });
            },
            textColor: Colors.white70,
            color: Colors.redAccent,
            child: new Text("Get Weather..")),
          )
            ],
    )
        ],

      ),
    );
  }
}

  TextStyle cityStyle(){
    return new TextStyle(
      color: Colors.white, fontSize: 20.9, fontStyle: FontStyle.italic,
    );
  }

  TextStyle tempStyle(){
  return new TextStyle(
    fontSize: 49.9,
    fontStyle: FontStyle.normal,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );
}
// style for humdilt and others
TextStyle extraData(){
  return new TextStyle(
    fontSize: 17.0,
    color: Colors.white70,
    fontStyle: FontStyle.normal,

  );

}