import 'package:cloud_firestore/cloud_firestore.dart';

class Memo {
  String id;
  String title;
  String detail;
  Timestamp createDate;
  Timestamp? updatedDate;

  Memo({
    required this.id,
    required this.title,
    required this.detail,
    required this.createDate,
    this.updatedDate,
  });
}
