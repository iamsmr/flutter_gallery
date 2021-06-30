import 'package:cloud_firestore/cloud_firestore.dart';

class GalleryImage {
  final String? id;
  final String url;
  final DateTime date;

  const GalleryImage({required this.url, required this.date, this.id});

  //TO docuemtnt
  Map<String, dynamic> toDocument() {
    return {"url": url, "date": Timestamp.fromDate(date)};
  }

  // Flutter Document
  factory GalleryImage.fromDocument(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return GalleryImage(
      id: snap.id,
      url: data["url"] ?? "",
      date: (data["date"] as Timestamp).toDate(),
    );
  }
}
