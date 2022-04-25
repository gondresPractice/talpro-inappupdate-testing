import 'package:flutter/material.dart';
import 'package:in_app_testing/CheckUpdatePage.dart';
import 'package:in_app_update/in_app_update.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'In App Testing',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'In App Plugin Testing'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  AppUpdateInfo? _updateInfo;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _flexibleUpdateAvailable = false;

  void initState(){
    super.initState();
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });

      if(_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable){
        InAppUpdate.startFlexibleUpdate();
      }else if(_updateInfo?.updateAvailability == UpdateAvailability.updateNotAvailable){
        showSnack('Update no available');
      }
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  void _incrementCounter() {
    setState(() {
     _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.height;
    var deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[

            Padding(
              padding: EdgeInsets.only(top:deviceHeight/3),
              child: const Text(
                'You have pushed the button this many times:',
              ),
            ),
            SizedBox(
              height: deviceWidth/50,
            ),
            Text(
              '$_counter',
              style: TextStyle(fontSize: 20.0),

            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CheckUpdate()),
              );
            }, child: Text('Check Update')),
            Padding(
              padding:  EdgeInsets.only(top:deviceHeight/3),
              child: Container(
                child: Center(
                    child: Text(
                      'Ver 1.0.0',
                      style: TextStyle(color: Color(0xff023E8A)),
                    )),
                width:120,
                height: 35,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        15.0),
                    border: Border.all(
                      color: Color(0xff023E8A),
                      width: 2,
                    )),
              ),
            ),

          ],
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
