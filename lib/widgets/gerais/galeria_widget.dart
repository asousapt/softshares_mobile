import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/screens/generic/galeria_fotos.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GaleriaWidget extends StatefulWidget {
  const GaleriaWidget({super.key, required this.urls});

  final List<String> urls;

  @override
  State<StatefulWidget> createState() {
    return _GaleriaWidgetState();
  }
}

class _GaleriaWidgetState extends State<GaleriaWidget> {
  String selectedImageUrl = "";
  @override
  void initState() {
    super.initState();
    selectedImageUrl = widget.urls.isNotEmpty ? widget.urls[0] : "";
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.urls;

    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        children: [
          // Imagem grande
          urls.isNotEmpty
              ? InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PhotoGalleryScreen(
                        imageUrls: urls,
                        initialIndex: urls.indexOf(selectedImageUrl),
                      ),
                    ));
                  },
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    height: altura * 0.2,
                    width: largura * 0.90,
                    placeholder: MemoryImage(kTransparentImage),
                    image: NetworkImage(
                      selectedImageUrl,
                    ),
                  ),
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
          SizedBox(height: altura * 0.01),
          // Galeria de imagens pequenas
          urls.isNotEmpty
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      urls.length,
                      (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedImageUrl = urls[index];
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: largura * 0.02),
                          width: largura * 0.1,
                          height: altura * 0.05,
                          child: FadeInImage(
                            fit: BoxFit.cover,
                            placeholder: MemoryImage(kTransparentImage),
                            image: NetworkImage(urls[index]),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          SizedBox(height: altura * 0.01),
          // controla a galeria de imagens
          urls.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(FontAwesomeIcons.arrowLeft),
                      onPressed: () {
                        if (urls.indexOf(selectedImageUrl) > 0) {
                          setState(() {
                            selectedImageUrl =
                                urls[urls.indexOf(selectedImageUrl) - 1];
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(FontAwesomeIcons.arrowRight),
                      onPressed: () {
                        if (urls.indexOf(selectedImageUrl) < urls.length - 1) {
                          setState(() {
                            selectedImageUrl =
                                urls[urls.indexOf(selectedImageUrl) + 1];
                          });
                        }
                      },
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
