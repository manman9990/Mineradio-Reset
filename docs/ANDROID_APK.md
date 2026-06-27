# Android APK Build

Mineradio is still a Windows Electron app. The Android build is a Capacitor WebView shell that packages `public/` into an APK.

## Important runtime boundary

Electron starts `server.js` locally on Windows. Android WebView does not run that Node server. For search, playback, lyrics, login, covers, weather radio, and update endpoints to work on Android, point the APK at a reachable Mineradio API server by editing:

```js
// public/mobile-config.js
window.MINERADIO_API_BASE = 'http://YOUR_SERVER:PORT';
```

Leave it empty for the Windows Electron build.

## Local toolchain used here

- JDK: `C:\Program Files\Amazon Corretto\jdk21.0.11_10`
- Android SDK: `C:\Android\Sdk`
- Android platform: `android-36`
- Build tools: `36.0.0`

## Build debug APK

```powershell
npm run build:android:debug
```

The build script regenerates Android launcher icons from `build/icon.png` before packaging.

Output:

```text
android\app\build\outputs\apk\debug\app-debug.apk
```

This is a debug-signed APK for local installation/testing. A release APK needs a keystore and `assembleRelease` signing config.
