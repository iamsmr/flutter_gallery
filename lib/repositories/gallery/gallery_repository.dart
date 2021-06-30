import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gallery/models/gallery_image.dart';
import 'dart:io';

import 'package:flutter_gallery/repositories/repositories.dart';
import 'package:uuid/uuid.dart';

class GalleryRepository extends BaseGalleryRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  GalleryRepository({
    FirebaseFirestore? firebaseFirestore,
    FirebaseStorage? firebaseStorage,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  @override
  Stream<List<GalleryImage>> getAllImage() {
    return _firebaseFirestore.collection("images").snapshots().map((snaps) =>
        snaps.docs.map((doc) => GalleryImage.fromDocument(doc)).toList());
  }

  Future<String> _uploadToFirebaseStorage(File file) async {
    final imageId = Uuid().v4();
    final ref = _firebaseStorage.ref("images/$imageId.jpg");
    final downloadUrl =
        await ref.putFile(file).then((snap) => snap.ref.getDownloadURL());

    return downloadUrl;
  }

  @override
  Future<void> uploadImage({required File image}) async {
    final imageUrl = await _uploadToFirebaseStorage(image);
    final newImage = GalleryImage(url: imageUrl, date: DateTime.now());
    await _firebaseFirestore.collection("images").add(newImage.toDocument());
  }
}
