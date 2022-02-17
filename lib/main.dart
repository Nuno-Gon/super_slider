// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: avoid_void_async

import 'package:firebase_core/firebase_core.dart';
import 'package:very_good_slide_puzzle/app/app.dart';
import 'package:very_good_slide_puzzle/bootstrap.dart';

void main() async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBfhPN7_Twt2ZQid0rMzzQmjoHJy3_WHb0",
      appId: "1029485859684",
      messagingSenderId:
          "AAAA77Ijk2Q:APA91bGSy_lFFyy28wGEmUzL9eiZKhwqYi1f3wf8kUXvg65VctA8eSFJ1cKYfiM7JGpKi-NedeJfSxvZsGMhC1MmwsG39gKbQACgCmrBoWBH2dR0l7afAWmjr0oI1cl6o4hvs0YOcXmn",
      projectId: "super-slider-quack-edition",
    ),
  );
  await bootstrap(
    () => const App(),
  );
}
