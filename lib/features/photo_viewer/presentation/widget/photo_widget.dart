import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PhotoWidget extends StatelessWidget {
  final String? imageUrl;
  final String placeHolderPath = "assets/images/dolphin_placeholder.webp";

  const PhotoWidget({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const margin = 16.0;
        final imageSize = width - 2 * margin;

        return Container(
          margin: const EdgeInsets.all(margin),
          width: imageSize,
          height: imageSize,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    placeholder: (context, url) => Image.asset(
                      placeHolderPath,
                      fit: BoxFit.cover,
                    ),
                    fit: BoxFit.cover,
                  )
                : Image.asset(placeHolderPath,
                    fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
