import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loginn.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CreoHive',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CreaohiveIp(),
    );
  }
}

class CreaohiveIp extends StatefulWidget {
  @override
  _CreaohiveIpState createState() => _CreaohiveIpState();
}

class _CreaohiveIpState extends State<CreaohiveIp> {
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreaohiveIp()),
        );
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal[200]!, Colors.teal[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.teal[100],
                          child: Icon(
                            Icons.work,
                            color: Colors.teal,
                            size: 60,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'CreoHive',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[800],
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'CreoHive Ip',
                            prefixIcon: Icon(Icons.vpn_key, color: Colors.teal),
                            filled: true,
                            fillColor: Colors.teal[50],
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.teal[200]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.teal[400]!),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            senddata();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal[600], // Button color
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          child: Text('Connect'),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void _saveData() async {
  //   String restaurantCode = _usernameController.text;
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   prefs.setString('restaurant', restaurantCode);
  //   prefs.setString('url', 'http://$restaurantCode:3000');
  //   prefs.setString('imgurl', 'http://$restaurantCode:3000/');
  //   prefs.setString('imgurl2', 'http://$restaurantCode:3000/');
  //
  //   print(restaurantCode);
  //
  //
  //   // Show a success message
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Connected to $restaurantCode')),
  //   );
  // }

  void senddata()async{
    String ip= _usernameController.text.toString();

    //stable ip address settings second

    print(ip);
    SharedPreferences sh=await SharedPreferences.getInstance();

    //stable ip address settings first
    sh.setString('ip', ip);
    sh.setString('url', 'http://$ip:8000');
    sh.setString('imgurl', 'http://$ip:8000/');
    sh.setString('imgurl2', 'http://$ip:8000/');
    // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginNewPage()
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()
    )
    );


  }

}
