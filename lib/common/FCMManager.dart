import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

// import 'package:get/get_connect/connect.dart';
//
// class FCMManager extends GetConnect {
//
//   // onInit(){
//   //
//   //   httpClient.addAuthenticator((request) {
//   //     request.headers['Authorization'] = "$token";
//   //     return request;
//   //   });
//   //
//   // }
//
//   // Get request
//   Future<Response> getUser(int id) => get('http://youapi/users/$id');
//   // Post request
//   Future<Response> postUser(Map data) => post('http://youapi/users', body: data);
//   // Post request with File
//   // Future<Response<CasesModel>> postCases(List<int> image) {
//   //   final form = FormData({
//   //     'file': MultipartFile(image, filename: 'avatar.png'),
//   //     'otherFile': MultipartFile(image, filename: 'cover.png'),
//   //   });
//   //   return post('http://youapi/users/upload', form);
//   // }
//   //
//   // GetSocket userMessages() {
//   //   return socket('https://yourapi/users/socket');
//   // }
// }

Future<List<String>> uploadFileAndGetDownloadUrls(
    List<String> filePaths, String directoryName) async {
  var downloadUrlList = <String>[];
  if (filePaths.isEmpty) return downloadUrlList;

  try {
    for (String filePath in filePaths) {
      File file = File(filePath);
      var fileName = Uuid().v1();
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(directoryName)
          .child('$fileName.png');
      await ref.putFile(file);
      var downloadUrl = await ref.getDownloadURL();
      downloadUrlList.add(downloadUrl);
    }
  } catch (e) {
    print(e);
  }
  return downloadUrlList;
}

Future<List<String>> uploadFileAndGetDownloadUrls1(
    List<String> filePaths, String directoryName) async {
  var downloadUrlList = <String>[];
  if (filePaths.isEmpty) return downloadUrlList;

  filePaths.forEach((filePath) async {
    try {
      File file = File(filePath);
      var fileName = Uuid().v1();
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(directoryName)
          .child('$fileName.png');
      await ref.putFile(file);
      var downloadUrl = await ref.getDownloadURL();
      downloadUrlList.add(downloadUrl);
    } catch (e) {
      print(e);
    }
  });

  return downloadUrlList;
}
//  firestoreTransaction(){
//    // Create a reference to the document the transaction will use
//    DocumentReference documentReference = FirebaseFirestore.instance
//        .collection('users')
//        .doc(documentId);
//
//    return FirebaseFirestore.instance.runTransaction((transaction) async {
//      // Get the document
//      DocumentSnapshot snapshot = await transaction.get(documentReference);
//
//      if (!snapshot.exists) {
//        throw Exception("User does not exist!");
//      }
//
//      // Update the follower count based on the current count
//      // Note: this could be done without a transaction
//      // by updating the population using FieldValue.increment()
//
//      int newFollowerCount = snapshot.data()['followers'] + 1;
//
//      // Perform an update on the document
//      transaction.update(documentReference, {'followers': newFollowerCount});
//
//      // Return the new count
//      return newFollowerCount;
//    })
//        .then((value) => print("Follower count updated to $value"))
//        .catchError((error) => print("Failed to update user followers: $error"));
// }

// Future<void> firestoreBatch() {
//   CollectionReference users = FirebaseFirestore.instance.collection('users');
//
//   WriteBatch batch = FirebaseFirestore.instance.batch();
//
//   return users.get().then((querySnapshot) {
//     querySnapshot.docs.forEach((document) {
//       batch.delete(document.reference);
//     });
//
//     return batch.commit();
//   });
// }
