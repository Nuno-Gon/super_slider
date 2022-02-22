import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/models/models.dart';

///Firebase Service
class FirebaseService {
  ///FireBase Singleton Constructor
  FirebaseService._privateConstructor();

  ///Instance of Firebase Service
  static final FirebaseService _instance = FirebaseService._privateConstructor();

  ///Getter for instance
  static FirebaseService get instance => _instance;

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  ///Upload to Firebase Storage
  Future<String?> uploadToStorage({
    required String puzzleCode,
    required Uint8List data,
  }) async =>
      _firebaseStorage.ref().child(puzzleCode).putData(data).then((p0) async {
        final url = await _firebaseStorage
            .ref(
              p0.ref.fullPath,
            )
            .getDownloadURL();

        return url;
      });

  /// Add to firebase collection
  Future<void> addToCollection({
    required String collection,
    required Map<String, dynamic> data,
    required VoidCallback onSuccess,
    required VoidCallback onError,
  }) async =>
      _fireStore
          .collection(collection)
          .doc(
            data['id'] as String,
          )
          .set(data)
          .then(
        (value) {
          onSuccess();
        },
      ).catchError(
        (Object obj) {
          onError();
        },
      );

  ///Get puzzle from Firebase Collection
  Future<void> getPuzzle({
    required String id,
    required Function(Puzzle) onSuccess,
    required VoidCallback onError,
  }) async =>
      _fireStore.collection('puzzle').doc('QUACK-$id').get().then(
        (value) async {
          final data = value.data();

          final content = data!['content'] as String;

          final dataBytes = await _firebaseStorage
              .refFromURL(
                content,
              )
              .getData();

          if (dataBytes == null) throw Error();

          final decoded = utf8.decode(dataBytes);

          onSuccess(
            Puzzle.fromJson(
              jsonDecode(decoded) as Map<String, dynamic>,
              isMega: true,
            ),
          );
        },
      ).catchError(
        (Object error) {
          onError();
        },
      );
}
