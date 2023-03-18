import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:food_eat_game/module/screen/home/view/home.dart';
import 'package:food_eat_game/module/screen/lastMsg/view/lastMsg.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import "package:firebase_storage/firebase_storage.dart" as firebase_storage;

class imgInput extends StatefulWidget {
  imgInput({Key? key}) : super(key: key);

  @override
  State<imgInput> createState() => _imgInputState();
}

class _imgInputState extends State<imgInput> {
  triggerNotification() {
    // channelKey: 'test',
    //         channelName: 'testBasic'
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 12,
            channelKey: 'test',
            title: "Meal image !",
            body: "Image uploaded to firebase storage ! "));
  }

  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Pic one Image of Meal !",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      primary: Color.fromARGB(255, 76, 146, 80),
                    ),
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      primary: Color.fromARGB(255, 76, 146, 80),
                    ),
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      primary: Color.fromARGB(255, 76, 146, 80),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
//image path is here

  File? pickedImage;
  // final ImagePicker _picker = ImagePicker();
  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  //upload fun
  _uploadFile(File img) async {
    try {
      firebase_storage.UploadTask uploadTask;
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('meal')
          .child('/' + img.path.split('/').last);

      uploadTask = ref.putFile(img);

      await uploadTask.whenComplete(() => null);
      String imgUrl = await ref.getDownloadURL();
      // log("tesing " + imgUrl);
      // print(imgUrl);
      // print(imgUrl);
      //notification work!
      // return imgUrl;
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    String url;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                        onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => homePage()))
                            },
                        child: Image.asset('assets/images/backButton.jpg')),
                  ],
                ),
                Stack(children: [
                  Image.asset('assets/images/animal.png'),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 210, 0, 0),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(244, 244, 244, 244),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40.0),
                                  topRight: Radius.circular(40.0))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    pickedImage == null
                                        ? Image.asset(
                                            'assets/images/mainImg.jpg')
                                        : Stack(
                                            children: [
                                              Image.asset(
                                                  'assets/images/outPut.jpg'),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 0, 0),
                                                child: Center(
                                                  child: CircleAvatar(
                                                    radius: 120,
                                                    backgroundImage:
                                                        FileImage(pickedImage!),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                  ],
                                ),
                                GestureDetector(
                                    onTap: () => {
                                          {
                                            pickedImage == null
                                                ? imagePickerOption()
                                                : {
                                                    _uploadFile(pickedImage!),
                                                    triggerNotification(),
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const lastMsg()))
                                                  }
                                          }
                                        },
                                    child: pickedImage == null
                                        ? Image.asset(
                                            'assets/images/clickIcon.jpg')
                                        : Image.asset(
                                            'assets/images/done.jpg')),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
