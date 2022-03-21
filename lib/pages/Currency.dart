import 'dart:async';
import 'dart:io';
import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:visually_paired/pages/classifier_float.dart';
import '../functions/helper_functions.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'classifier.dart';
import 'classifier_quant.dart';

class Currency extends StatefulWidget {
  final CameraDescription firstCamera;
  const Currency({ Key? key, required this.firstCamera}) : super(key: key);
  @override
  _CurrencyState createState() => _CurrencyState();
}

class _CurrencyState extends State<Currency> {
  late CameraDescription firstCamera;

  @override
  void initState() {
    super.initState();
    AlanVoice.activate();
    callProjectApi("onTapCurrency", {});
    debugPrint("Currency initState called");
  }



  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        debugPrint("Popping from currency.dart");
        callProjectApi("resolve", {});
        AlanVoice.deactivate();
        return true;
      },
      child: TakePictureScreen(
          // Pass the appropriate camera to the TakePictureScreen widget.
          camera: widget.firstCamera,
        ),
    );
  }
}

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            debugPrint(e.toString());
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  const DisplayPictureScreen({ Key? key, required this.imagePath }) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  late Classifier _classifier;
  File? _image;
  var logger = Logger();
  Category? category;

  @override
  void initState() {
    super.initState();
    _classifier = ClassifierFloat();
    
  }

    getImage() async {
    //final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(widget.imagePath);
      _predict();
    });
  }

  void _predict() async {
    img.Image imageInput = img.decodeImage(_image!.readAsBytesSync())!;
    var pred = _classifier.predict(imageInput);

    setState(() {
      category = pred;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        children: [
          Image.file(File(widget.imagePath)),
          FloatingActionButton(onPressed: getImage),
          Text(category != null ? category!.label : '',),
          Text(
            category != null
                ? 'Confidence: ${category!.score.toStringAsFixed(3)}'
                : '',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
