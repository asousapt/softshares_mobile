import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;

  ImageWidget({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    return imageUrl.isEmpty
        ? Container(
            height: altura * 0.2,
            width: double.infinity,
            color: Colors.grey[200],
            child: const Icon(
              Icons.broken_image,
              color: Colors.grey,
              size: 50,
            ),
          )
        : FadeInImage(
            fit: BoxFit.cover,
            height: altura * 0.2,
            width: double.infinity,
            placeholder: const AssetImage("Images/empty_image_placeholder.jpg"), // Placeholder image while loading
            image: NetworkImage(imageUrl),
            imageErrorBuilder: (context, error, stackTrace) {
              return Container(
                height: altura * 0.2,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Icon(
                  Icons.broken_image,
                  color: Colors.grey,
                  size: 50,
                ),
              );
            },
          );
  }
}