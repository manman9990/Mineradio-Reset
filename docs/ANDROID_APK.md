# Android APK Build

Mineradio is still a Windows Electron app. The Android build is a Capacitor WebView shell that packages `public/` into an APK.

## Android version identity

- Android app name: `Mineradio Reset`
- Android applicationId: `com.manman9990.mineradioreset`
- First reset release: `versionName "1.0.0"` and `versionCode 1`
- Version rule: keep `versionName` aligned with `package.json`; increase `versionCode` by 1 for every APK uploaded or shared outside local testing.

## Important runtime boundary

Electron starts `server.js` locally on Windows. Android WebView does not run that Node server. For search, playback, lyrics, login, covers, weather radio, and update endpoints to work outside the home network, point the APK at a stable public Mineradio API server by editing:

```js
// public/mobile-config.js
window.MINERADIO_API_BASE = 'http://YOUR_SERVER:PORT';
```

Leave it empty for the Windows Electron build.

Do not use a home LAN IP for a real Android build. Use an HTTPS domain on a cloud server, otherwise the app will fail once the phone leaves that network.

## Deploy mobile API

Build the API container:

```powershell
docker build -f Dockerfile.mobile-api -t mineradio-mobile-api .
```

Run it behind an HTTPS reverse proxy:

```powershell
docker run -d --name mineradio-mobile-api -p 3000:3000 mineradio-mobile-api
```

Then point `public/mobile-config.js` at the public HTTPS endpoint and rebuild the APK.

## Android login boundary

NetEase QR login can use the public API server. QQ automatic web login currently depends on Electron desktop window control, so Android uses manual cookie import until a native Android login flow is built.

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
