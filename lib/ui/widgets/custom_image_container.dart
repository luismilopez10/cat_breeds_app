import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:cat_breeds_app/settings/app_assets.dart';

class CustomImageContainer extends StatelessWidget {
  const CustomImageContainer({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: (context, url) => Image.asset(
        AppAssets.loadingGif,
        fit: BoxFit.cover,
      ),
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => Image.asset(
        AppAssets.imageNotFound,
        fit: BoxFit.cover,
      ),
      fadeInDuration: const Duration(milliseconds: 150),
      fadeOutDuration: const Duration(milliseconds: 150),
    );
  }
}
