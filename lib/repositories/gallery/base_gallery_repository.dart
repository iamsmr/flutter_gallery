import 'dart:io';

import 'package:flutter_gallery/models/models.dart';

abstract class BaseGalleryRepository {
  Future<void> uploadImage({required File image});
  Stream<List<GalleryImage>> getAllImage();
}
