import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseAuth? _firebaseAuth;
  User? user;
  StorageService(this._firebaseAuth) {
    if (_firebaseAuth!.currentUser == null) {
      _firebaseAuth!.signInAnonymously().then((value) async {
        user = _firebaseAuth!.currentUser;
      });
    } else {
      user = _firebaseAuth!.currentUser;
    }
  }

  final _storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>> getNFTDownloadURLs(
      int amountToGet, String? pt, String? nftType) async {
    List<String> urlList = [];
    final storageRef = _storage.ref().child("app/$nftType");
    ListResult? listResult;
    String? pageToken;
    if (amountToGet == 0) {
      listResult = await storageRef.listAll();
    } else {
      listResult = await storageRef.list(ListOptions(
        maxResults: amountToGet,
        pageToken: pt,
      ));
      pageToken = listResult.nextPageToken;
    }
    for (Reference item in listResult.items) {
      String u =
          'https://firebasestorage.googleapis.com/v0/b/product-dao-org.appspot.com/o/app%2F$nftType%2F${item.fullPath.substring(9)}?alt=media';
      urlList.add(u);
    }
    return {'pageToken': pageToken, 'urls': urlList};
  }
}
