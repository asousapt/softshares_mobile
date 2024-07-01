import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/widgets/gerais/tirar_foto.dart';

class FotoPicker extends StatefulWidget {
  const FotoPicker({
    super.key,
    required this.pickedImages,
    required this.onImagesPicked,
  });

  final List<XFile> pickedImages;
  final Function(List<XFile>) onImagesPicked;

  @override
  State<StatefulWidget> createState() {
    return _FotoPickerState();
  }
}

class _FotoPickerState extends State<FotoPicker> {
  final ImagePicker _picker = ImagePicker();
  List<CameraDescription> _cameras = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
  }

  void _removeImage(int index) {
    setState(() {
      widget.pickedImages.removeAt(index);
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final List<XFile>? pickedImages = await _picker.pickMultiImage();

        if (pickedImages != null && pickedImages.isNotEmpty) {
          setState(() {
            widget.pickedImages.addAll(pickedImages);
          });
          widget.onImagesPicked(widget.pickedImages);
        }
      } else if (source == ImageSource.camera && _cameras.isNotEmpty) {
        final XFile? pickedImage = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TirarFoto(cam: _cameras),
          ),
        );

        if (pickedImage != null) {
          setState(() {
            widget.pickedImages.add(pickedImage);
          });
          widget.onImagesPicked(widget.pickedImages);
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
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: altura * 0.2,
          child: widget.pickedImages.isNotEmpty
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.pickedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Stack(
                        children: [
                          Image.file(
                            File(widget.pickedImages[index].path),
                            width: largura * 0.3,
                            height: altura * 0.3,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Container(
                  height: altura * 0.2,
                  width: largura * 0.90,
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.images,
                          size: 50,
                          color: Theme.of(context).canvasColor,
                        ),
                        SizedBox(
                            height:
                                altura * 0.01), // Spacer between icon and text
                        Text(
                          AppLocalizations.of(context)!.galeriaVazia,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
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
        ),
      ],
    );
  }
}
