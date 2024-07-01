import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:transparent_image/transparent_image.dart';

class PhotoGalleryScreen extends StatelessWidget {
  const PhotoGalleryScreen({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  final List<String> imageUrls;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.imageGallery),
      ),
      body: PhotoViewGallery.builder(
        itemCount: imageUrls.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions.customChild(
            child: _buildLoadingImage(imageUrls[index], context),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        pageController: PageController(initialPage: initialIndex),
      ),
    );
  }

  Widget _buildLoadingImage(String imageUrl, BuildContext context) {
    return Stack(
      children: [
        Center(
            child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).canvasColor,
        )),
        Center(
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
