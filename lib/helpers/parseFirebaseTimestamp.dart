import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

DateTime parseFirebaseTimestamp(dynamic date) {
  return Platform.isIOS ? (date as Timestamp).toDate() : (date as DateTime);
}
