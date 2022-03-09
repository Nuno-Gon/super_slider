// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/app/app.dart';
import 'package:very_good_slide_puzzle/bootstrap.dart';

void main() {
  // ensure that the Flutter SkyEngine has fully initialized before the
  // runZoneGuarded declaration
  WidgetsFlutterBinding.ensureInitialized();

  runZonedGuarded(
    () async {
      try {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyBfhPN7_Twt2ZQid0rMzzQmjoHJy3_WHb0',
            authDomain: 'com.veryquack.supersliderquackedition',
            appId: '1029485859684',
            messagingSenderId: 'AAAA77Ijk2Q:APA91bGSy_lFFyy28wGE'
                'mUzL9eiZKhwqYi1f3wf8kUXvg65V'
                'ctA8eSFJ1cKYfiM7JGpKi-NedeJfSxvZsGMhC1MmwsG39gKbQACgCmrBoWBH2'
                'dR0l7afAWmjr0oI1cl6o4hvs0YOcXmn',
            projectId: 'super-slider-quack-edition',
          ),
        );
      } catch (e) {
        Firebase.app();
      }

      await bootstrap(
        () => const App(),
      );
    },
    (e, s) {
      log('Could not load app: Error: $e , StackTrace: $s');
    },
  );
}
