import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/models/models.dart';

///Firebase Service
class FirebaseService {
  ///FireBase Singleton Constructor
  FirebaseService._privateConstructor();

  ///Instance of Firebase Service
  static final FirebaseService _instance =
      FirebaseService._privateConstructor();

  ///Getter for instance
  static FirebaseService get instance => _instance;

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

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
      _fireStore.collection('puzzle').doc(id).get().then(
        (value) {
          final data = value.data();
          final content = utf8.decode(
            base64Decode(data!['content'] as String),
          );

          onSuccess(
            Puzzle.fromJson(
              jsonDecode(content) as Map<String, dynamic>,
              isMega: true,
            ),
          );
        },
      ).catchError((Object error) {
        onError();
      });
}
