// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:firebase_core/firebase_core.dart';
import 'package:very_good_slide_puzzle/app/app.dart';
import 'package:very_good_slide_puzzle/bootstrap.dart';

// ignore: avoid_void_async
void main() async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBfhPN7_Twt2ZQid0rMzzQmjoHJy3_WHb0',
      appId: '1029485859684',
      messagingSenderId: 'AAAA77Ijk2Q:APA91bGSy_lFFyy28wGEmUz'
          'L9eiZKhwqYi1f3wf8kUXvg65V'
          'ctA8eSFJ1cKYfiM7JGpKi-NedeJfSxvZsGMhC1MmwsG39gKbQACgCmrBoWBH2'
          'dR0l7afAWmjr0oI1cl6o4hvs0YOcXmn',
      projectId: 'super-slider-quack-edition',
      storageBucket: 'gs://super-slider-quack-edition.appspot.com',
    ),
  );
  await bootstrap(
    () => const App(),
  );
}
