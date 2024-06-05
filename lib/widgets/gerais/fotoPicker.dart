import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  List<XFile> _images = [];

  Future<void> _pickImage(ImageSource source) async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();

    if (pickedImages != null && pickedImages.isNotEmpty) {
      setState(() {
        _images = pickedImages;
      });
      widget.onImagesPicked(pickedImages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.photo_library),
          onPressed: () => _pickImage(ImageSource.gallery),
        ),
        IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: () => _pickImage(ImageSource.camera),
        ),
      ],
    );
  }
}
