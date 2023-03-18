// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:food_eat_game/module/screen/imgInput/view/imgInput.dart';

class homePage extends StatefulWidget {
  homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  void initState() {
    // TODO: implement initState
    AwesomeNotifications().isNotificationAllowed().then((isAlowed) {
      if (!isAlowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  primary: Color.fromARGB(255, 76, 146, 80),
                ),
                onPressed: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => imgInput()))
                    },
                child: Text(
                  "Share your meal",
                  style: TextStyle(fontSize: 20),
                )),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
