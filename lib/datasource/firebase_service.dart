import 'package:cloud_firestore/cloud_firestore.dart';

///Firebase Service
class FirebaseService {
  ///FireBase Singleton Constructor
  FirebaseService._privateConstructor();

  ///Instance of Firebase Service
  static final FirebaseService _instance = FirebaseService._privateConstructor();

  ///Getter for instance
  static FirebaseService get instance => _instance;

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  /// Add to firebase collection
  Future<void> addToCollection({
    required String collection,
    required Map<String, dynamic> data,
  }) async =>
      _fireStore.collection(collection).add(data).then(
            (value) => print('Added'),
          )..catchError(print);
}
