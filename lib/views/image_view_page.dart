import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewPage extends StatefulWidget {
  static var HERO_TAG = "ImageViewPage";
  final String networkImage;
  final String assetsImage;

  const ImageViewPage({
    this.assetsImage,
    this.networkImage,
  });

  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: ImageViewPage.HERO_TAG,
        child: Container(
          child: PhotoView(
            imageProvider: widget.assetsImage == null ?
              NetworkImage(widget.networkImage)
                :
              ExactAssetImage(widget.assetsImage),
          ),
        ),
      ),
    );
  }
}
