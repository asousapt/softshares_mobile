import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'preview_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({super.key, required this.camera});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture(BuildContext context) async {
    try {
      await _initializeControllerFuture;

      final directory = await getApplicationDocumentsDirectory();
      final imagePath = join(directory.path, '${DateTime.now()}.png');

      final XFile image = await _controller.takePicture();
      await image.saveTo(imagePath);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(
            image: XFile(imagePath),
            onConfirm: (confirmedImage) {
              Navigator.pop(context, confirmedImage);
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.ocorreuErro),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tirarFoto),
      ),
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
        onPressed: () => _takePicture(context),
        child: const Icon(FontAwesomeIcons.camera),
      ),
    );
  }
}
