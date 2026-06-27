$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$jdkHome = "C:\Program Files\Amazon Corretto\jdk21.0.11_10"
$sdkHome = "C:\Android\Sdk"

if (!(Test-Path -LiteralPath $jdkHome)) {
  throw "JDK 21 not found: $jdkHome"
}

if (!(Test-Path -LiteralPath $sdkHome)) {
  throw "Android SDK not found: $sdkHome"
}

$env:JAVA_HOME = $jdkHome
$env:ANDROID_HOME = $sdkHome
$env:ANDROID_SDK_ROOT = $sdkHome
$env:Path = "$jdkHome\bin;$sdkHome\platform-tools;$sdkHome\cmdline-tools\latest\bin;$env:Path"

$proxy = "127.0.0.1"
$proxyPort = 10808
$proxyOpen = Test-NetConnection -ComputerName $proxy -Port $proxyPort -InformationLevel Quiet
if ($proxyOpen) {
  $env:HTTP_PROXY = "http://${proxy}:${proxyPort}"
  $env:HTTPS_PROXY = "http://${proxy}:${proxyPort}"
  $env:GRADLE_OPTS = "-Dhttp.proxyHost=$proxy -Dhttp.proxyPort=$proxyPort -Dhttps.proxyHost=$proxy -Dhttps.proxyPort=$proxyPort"
}

Push-Location $root
try {
  & (Join-Path $root "build\android-icons.ps1")
  npx cap sync android
  Push-Location "android"
  try {
    .\gradlew.bat assembleDebug
  } finally {
    Pop-Location
  }
} finally {
  Pop-Location
}

$apk = Join-Path $root "android\app\build\outputs\apk\debug\app-debug.apk"
if (!(Test-Path -LiteralPath $apk)) {
  throw "APK was not produced: $apk"
}

Get-Item -LiteralPath $apk | Select-Object FullName, Length, LastWriteTime
