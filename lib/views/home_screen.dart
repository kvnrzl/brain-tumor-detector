import 'dart:io';
import 'package:brain_tumor_detector_app/helpers/model.dart';
import 'package:brain_tumor_detector_app/helpers/pick_image.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading;
  File _image;
  List _output;

  // function untuk mengambil foto ketika user menekan suatu button
  getImageFromUser() async {
    _image = await PickImage.getImage();
    _output = await Model.runModelBrainTumorDetection(_image);
    setState(() {});
  }

  // function untuk mengolah

  @override
  void initState() {
    super.initState();
    // init dulu kalo pas awal dibuka itu app nya sedang loading
    _isLoading = true;
    // ketika sudah load model nya baru di ubah menjadi false;
    Model.loadModelBrainTumorDetection().then((value) {
      _isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detector"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // buat nampilin foto
                  _image != null
                      ? Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(_image), fit: BoxFit.cover),
                          ),
                        )
                      : Container(),
                  // buat output
                  _output != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _output[0]['label'] == '1 Yes'
                                ? "Terindikasi adanya tumor otak"
                                : "Tidak terindikasi adanya tumor otak",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Silahkan lakukan pengecekan"),
                        ),
                  Container(
                    width: 300,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        getImageFromUser();
                      },
                      icon: Icon(Icons.add_photo_alternate),
                      label: Text("Masukkan photo"),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
