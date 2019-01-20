---
layout: post
title:  "Sign In Failed on Flutter"
date:   2019-01-20 00:20
categories: dart firebase flutter authentication
---

#

While using [firebase_auth](https://pub.dartlang.org/packages/firebase_auth) and [google_sign_in](https://pub.dartlang.org/packages/google_sign_in) packages for Flutter, the below error was shown.

# Sign In with Google Account

```dart
  Future<String> _signInGoogleAccount() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    assert(!user.isAnonymous);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    print("user name: ${user.displayName}");
    print("user email: ${user.email}");
    print("user photoUrl: ${user.photoUrl}");

    return 'signInGoogleAccount succeeded.... $user';
  }
```

```text
E/flutter ( 7147): [ERROR:flutter/shell/common/shell.cc(184)] Dart Error: Unhandled exception:
E/flutter ( 7147): PlatformException(sign_in_failed, com.google.android.gms.common.api.ApiException: 12500: , null)
E/flutter ( 7147): #0      StandardMethodCodec.decodeEnvelope (package:flutter/src/services/message_codecs.dart:551:7)
E/flutter ( 7147): #1      MethodChannel.invokeMethod (package:flutter/src/services/platform_channel.dart:292:18)
E/flutter ( 7147): <asynchronous suspension>
E/flutter ( 7147): #2      GoogleSignIn._callMethod (package:google_sign_in/google_sign_in.dart:217:58)
E/flutter ( 7147): <asynchronous suspension>
E/flutter ( 7147): #3      GoogleSignIn._addMethodCall.<anonymous closure> (package:google_sign_in/google_sign_in.dart:269:28)
E/flutter ( 7147): #4      _RootZone.run (dart:async/zone.dart:1374:54)
E/flutter ( 7147): #5      _FutureListener.handleWhenComplete (dart:async/future_impl.dart:153:18)
E/flutter ( 7147): #6      Future._propagateToListeners.handleWhenCompleteCallback (dart:async/future_impl.dart:612:39)
E/flutter ( 7147): #7      Future._propagateToListeners (dart:async/future_impl.dart:668:37)
E/flutter ( 7147): #8      Future._addListener.<anonymous closure> (dart:async/future_impl.dart:351:9)
E/flutter ( 7147): #9      _microtaskLoop (dart:async/schedule_microtask.dart:41:21)
E/flutter ( 7147): #10     _startMicrotaskLoop (dart:async/schedule_microtask.dart:50:5)
```

- Note the `PlatformException(sign_in_failed, com.google.android.gms.common.api.ApiException: 12500: , null)` line about [SIGN_IN_FAILED](https://developers.google.com/android/reference/com/google/android/gms/auth/api/signin/GoogleSignInStatusCodes.html#SIGN_IN_FAILED) error.
- The local `debug.keystore` file under `$HOME/.android/` or `$USERPROFILE\.android\` directory is not recognized by Firebase Authentication services while bundled with the debug version of the Flutter app.

## Upload SHA1 from Debug Key Store to Firebase

- Get SHA1 from `debug.keystore` file.

```bash
keytool -list -v \
-keystore debug.keystore \
-alias androiddebugkey \
-storepass android \
-keypass android
```

- Create `debug.keystore` file again at the same location if required.

```bash
keytool -genkey -v \
-keystore debug.keystore \
-storepass android \
-alias androiddebugkey \
-keypass android \
-keyalg RSA \
-keysize 2048 \
-validity 10000
```

- Add SHA1 obtained from `debug.keystore` file to the settings under Firebase Project ID.

```text
https://console.firebase.google.com/project/FIREBASE_PROJECT_ID/settings/general/
```

- Download `google-services.json` file to `FLUTTER_PROJECT_ROOT/android/app` path.
- Sometimes, it helps to manually remove the installed app on device.
- Run the app against the device again. It should work now.
- See below output after `signInGoogleAccount()` being executed.

```text
W/BiChannelGoogleApi(11571): [FirebaseAuth: ] getGoogleApiForMethod() returned Gms: com.google.firebase.auth.api.internal.zzal@de661b2
D/FirebaseAuth(11571): Notifying id token listeners about user ( EZG2LN2URXGNBRGFTO2FZCQZOZQ1 ).
D/FirebaseAuth(11571): Notifying auth state listeners about user ( EZG2LN2URXGNBRGFTO2FZCQZOZQ1 ).
D/FirebaseApp(11571): Notifying auth state listeners.
D/FirebaseApp(11571): Notified 0 auth state listeners.
I/flutter (11571): user name: Admin Istrator
I/flutter (11571): user email: admin.istrator@example.com
I/flutter (11571): user photoUrl: https://lh3.googleusercontent.com/-1LMWBMYEMSC/AAAAAAAAAAB/AAAAAAAAAAA/B4GC9SMQWHY/S96-C/photo.jpg
```

## Sign Out with Google Account

- To sign out, use the below code snippets.

```dart
  Future<String> _signOutGoogleAccount() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    return 'signOutWithGoogle succeeded....';
  }
```

- See below output after `_signOutGoogleAccount()` being executed.

```text
D/FirebaseAuth(11571): Notifying id token listeners about a sign-out event.
D/FirebaseAuth(11571): Notifying auth state listeners about a sign-out event.
D/FirebaseApp(11571): Notifying auth state listeners.
D/FirebaseApp(11571): Notified 0 auth state listeners.
```
