import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.blue));

  runApp(MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _inputController;
  TextEditingController _outputController;

  String barcode = '';
  String points = '0';
  String error = '';
  String success = '';
  bool isonetimedone = false;

  Future<bool> _scan() async {
    viewpoints();
    //  isonetimedone = false;
    success = '';
    setState(() {
      // points = '0';
      error = '';
      barcode = '';
    });
    barcode = await scanner.scan();
    this._outputController.text = barcode;

    _newList = usedlist;
    setState(() {});

    bool flag = true;
    for (var items in _qrlist) {
      if (barcode == items) {
        for (var newitems in usedlist) {
          if (barcode == newitems) {
            flag = false;

            //  break;
            return flag;
          }
        }

        return flag;
      }
    }
    return false;
  }

  Future<bool> managepoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int prevponits;

    prevponits = (prefs.getInt("points") ?? 0) + 0;
    if (usedlist.length != 0) {
      usedlist = (prefs.getStringList("usedQR") ?? []);
    } else {
      usedlist = [];
    }
    int newpoints = 200;
    setState(() {
      points = (prevponits + newpoints).toString();
      _savePoints((prevponits + newpoints));
    });
    _newList.add(barcode);
    _saveList(_newList);
    isonetimedone = true;

    setState(() {
      success = 'Congrats !!! \n\n200 new ponts added.';
    });
    return true;
  }

  Future adpoints() async {
    _scan().then((response) {
      if (response == true) {
        managepoints().then((res) {
          if (res == false) {
            setState(() {
              error = 'qr code is used or wrong.';
            });
          }
        });
      } else {
        error = 'qr code is used or wrong.';
      }
    });
  }

  List _qrlist = [
    'the12345678911qwe',
    'the12345678912qwe',
    'the12345678913qwe',
    'the12345678914qwe',
    'the12345678915qwe',
    'the12345678916qwe',
    'the12345678917qwe',
    'the12345678918qwe',
    'the12345678919qwe',
    'the12345678920qwe',
    'the12345678921qwe',
    'the12345678921qwe',
    'the12345678923qwe',
    'the12345678924qwe',
    'the12345678925qwe',
    'the12345678926qwe',
    'the12345678927qwe',
    'the12345678928qwe',
    'the12345678929qwe',
    'the12345678930qwe',
    'the12345678931qwe',
    'the12345678932qwe',
    'the12345678933qwe',
    'the12345678934qwe',
    'the12345678935qwe',
    'the12345678936qwe',
    'the12345678937qwe',
    'the12345678938qwe',
    'the12345678939qwe',
    'the12345678940qwe',
    'the12345678941qwe',
    'the12345678942qwe',
    'the12345678943qwe',
    'the12345678944qwe',
    'the12345678945qwe',
    'the12345678946qwe',
    'the12345678947qwe',
    'the12345678948qwe',
    'the12345678949qwe',
    'the12345678950qwe',
  ];

  List<String> usedlist = [];
// ...

  List<String> _newList = [];

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future _saveList(List<String> newList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setStringList("usedQR", newList);
  }

  Future<List<String>> _getList() async {
    SharedPreferences prefs = await _prefs;
    return (prefs.getStringList("usedQR") ?? null);
  }

  Future _savePoints(int points) async {
    SharedPreferences prefs = await _prefs;
    return await prefs.setInt("points", points);
  }

  Future viewpoints() async {
    SharedPreferences prefs = await _prefs;
    if (prefs.getInt("points") != null &&
        prefs.getStringList("usedQR") != null) {
      points = (prefs.getInt("points") + 0).toString();
      usedlist = prefs.getStringList("usedQR");
    } else {
      points = ((prefs.getInt("points") ?? 0) + 0).toString();
      usedlist = [];
    }
    setState(() {});
  }

  Future printData() async {
    SharedPreferences prefs = await _prefs;

    points = prefs.getInt("points").toString();
    _newList = prefs.getStringList("usedQR");

    print(_newList);
  }

  @override
  initState() {
    super.initState();
    this._inputController = new TextEditingController();
    this._outputController = new TextEditingController();
    viewpoints().then((onValue) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: InkWell(
            onTap: () {
              printData();
            },
            child: Text('The QR')),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: adpoints, label: Text('Scan')),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'Your Total Reward points :',
                  style: TextStyle(fontSize: 22, color: Colors.black),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  points,
                  style: TextStyle(fontSize: 26, color: Colors.green),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
              Center(
                child: Text(
                  success,
                  style: TextStyle(color: Colors.green, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )),
    );
  }
}
