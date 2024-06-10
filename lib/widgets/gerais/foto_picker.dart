import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:softshares_mobile/screens/camera_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FotoPicker extends StatefulWidget {
  const FotoPicker({super.key, required this.onImagesPicked});

  final Function(List<XFile>) onImagesPicked;

  @override
  State<StatefulWidget> createState() {
    return _FotoPickerState();
  }
}

class _FotoPickerState extends State<FotoPicker> {
  final ImagePicker _picker = ImagePicker();
  late Future<void> _initializeControllerFuture;
  List<CameraDescription> _cameras = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final List<XFile>? pickedImages = await _picker.pickMultiImage();

        if (pickedImages != null && pickedImages.isNotEmpty) {
          widget.onImagesPicked(pickedImages);
        }
      } else if (source == ImageSource.camera && _cameras.isNotEmpty) {
        final XFile? pickedImage = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraScreen(camera: _cameras.first),
          ),
        );

        if (pickedImage != null) {
          widget.onImagesPicked([pickedImage]);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.ocorreuErro)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.photo_library),
          onPressed: () => _pickImage(ImageSource.gallery),
        ),
        IconButton(
          icon: const Icon(Icons.camera_alt),
          onPressed: () => _pickImage(ImageSource.camera),
        ),
      ],
    );
  }
}
