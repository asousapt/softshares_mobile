import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PreviewScreen extends StatelessWidget {
  final XFile image;
  final Function(XFile) onConfirm;

  const PreviewScreen({
    super.key,
    required this.image,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.imagePreview)),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: altura * 0.02, horizontal: largura * 0.02),
        child: Container(
          color: Theme.of(context).canvasColor,
          child: Container(
            margin: EdgeInsets.all(largura * 0.02),
            child: Column(
              children: [
                Expanded(child: Image.file(File(image.path))),
                SizedBox(height: altura * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context)!.descartar),
                    ),
                    SizedBox(width: largura * 0.02),
                    FilledButton(
                      onPressed: () {
                        onConfirm(image);
                        Navigator.pop(context, image);
                      },
                      child: Text(AppLocalizations.of(context)!.confirmar),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
