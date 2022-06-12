import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

// development:
//   cloud_name: "dqminndjm"
//   api_key: "235278526729169"
//   api_secret: "tnTalUY2EhprMnXN_sHN0yPDdRI"
//   secure: true

// production:
//   cloud_name: "dqminndjm"
//   api_key: "235278526729169"
//   api_secret: "tnTalUY2EhprMnXN_sHN0yPDdRI"
//   secure:true

class CloudStorageService {
  bool hasError = false;
  CloudStorageResult cloudStorage = CloudStorageResult();

  Future<String> uploadImage({File? imageToUpload}) async {
    String imageUrl;
    final String _imageFileName =
        DateTime.now().microsecondsSinceEpoch.toString();

    final _authUserId = FirebaseAuth.instance.currentUser!.uid;

    final Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('eventOrganizers/$_authUserId/$_imageFileName');

    UploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload!);

    if (imageToUpload == null) {
      hasError = true;
    }
    TaskSnapshot storageSnapshot = await uploadTask;
    var downloadURL = await storageSnapshot.ref.getDownloadURL();
    if (storageSnapshot.state == TaskState.success) {
      final String url = downloadURL.toString();
      imageUrl = url;
      print('upload success');
      return imageUrl;
    }

    print('upload failed');
    return 'There was an error uploading the picture';
  }
}

class CloudStorageResult {
  final String? imageURL;

  CloudStorageResult({this.imageURL});
}
