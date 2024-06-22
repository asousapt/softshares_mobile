import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';

class TirarFoto extends StatefulWidget {
  const TirarFoto({super.key, required this.cam});

  final List<CameraDescription> cam;

  @override
  State<TirarFoto> createState() => _TirarFotoState();
}

class _TirarFotoState extends State<TirarFoto> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isFrontCamera = false; // Track whether front camera is selected

  CameraDescription get camera =>
      _isFrontCamera ? widget.cam.last : widget.cam.first;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggleCamera() async {
    if (_isFrontCamera) {
      await _controller.dispose();
      setState(() {
        _controller = CameraController(
          widget.cam.first,
          ResolutionPreset.medium,
        );
        _initializeControllerFuture = _controller.initialize();
        _isFrontCamera = false;
      });
    } else {
      await _controller.dispose();
      setState(() {
        _controller = CameraController(
          widget.cam.last,
          ResolutionPreset.medium,
        );
        _initializeControllerFuture = _controller.initialize();
        _isFrontCamera = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tirarFoto),
        actions: [
          IconButton(
            onPressed: _toggleCamera,
            icon: const Icon(FontAwesomeIcons.cameraRotate),
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CameraPreview(_controller),
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).canvasColor,
            ));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).canvasColor,
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final XFile foto = await _controller.takePicture();

            // Get a temporary directory for storing the captured photo
            final Directory extDir = await getTemporaryDirectory();
            final String dirPath = '${extDir.path}/Pictures/flutter_camera';
            await Directory(dirPath).create(recursive: true);
            final String filePath = '$dirPath/${DateTime.now()}.jpg';

            // Move the captured photo to the app's storage directory
            await foto.saveTo(filePath);

            // Return to previous screen (LoginScreen) with the captured photo path
            Navigator.pop(context, foto);
          } catch (e) {
            print('Erro ao capturar foto: $e');
          }
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}
