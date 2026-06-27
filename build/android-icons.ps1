$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$source = Join-Path $root "build\icon.png"
$resRoot = Join-Path $root "android\app\src\main\res"

if (!(Test-Path -LiteralPath $source)) {
  throw "Android icon source not found: $source"
}

if (!(Test-Path -LiteralPath $resRoot)) {
  throw "Android resources directory not found: $resRoot"
}

Add-Type -AssemblyName System.Drawing

function Save-ScaledPng {
  param(
    [Parameter(Mandatory=$true)][string]$InputPath,
    [Parameter(Mandatory=$true)][string]$OutputPath,
    [Parameter(Mandatory=$true)][int]$Size,
    [int]$Inset = 0
  )

  $src = [System.Drawing.Image]::FromFile($InputPath)
  try {
    $bmp = New-Object System.Drawing.Bitmap $Size, $Size, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    try {
      $g = [System.Drawing.Graphics]::FromImage($bmp)
      try {
        $g.Clear([System.Drawing.Color]::Transparent)
        $g.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceOver
        $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
        $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
        $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

        $target = $Size - ($Inset * 2)
        $g.DrawImage($src, $Inset, $Inset, $target, $target)
      } finally {
        $g.Dispose()
      }

      New-Item -ItemType Directory -Force -Path (Split-Path -Parent $OutputPath) | Out-Null
      $bmp.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    } finally {
      $bmp.Dispose()
    }
  } finally {
    $src.Dispose()
  }
}

$legacy = @{
  "mipmap-mdpi" = 48
  "mipmap-hdpi" = 72
  "mipmap-xhdpi" = 96
  "mipmap-xxhdpi" = 144
  "mipmap-xxxhdpi" = 192
}

$foreground = @{
  "mipmap-mdpi" = 108
  "mipmap-hdpi" = 162
  "mipmap-xhdpi" = 216
  "mipmap-xxhdpi" = 324
  "mipmap-xxxhdpi" = 432
}

foreach ($entry in $legacy.GetEnumerator()) {
  $dir = Join-Path $resRoot $entry.Key
  Save-ScaledPng -InputPath $source -OutputPath (Join-Path $dir "ic_launcher.png") -Size $entry.Value
  Save-ScaledPng -InputPath $source -OutputPath (Join-Path $dir "ic_launcher_round.png") -Size $entry.Value
}

foreach ($entry in $foreground.GetEnumerator()) {
  $dir = Join-Path $resRoot $entry.Key
  $inset = [Math]::Round($entry.Value * 0.12)
  Save-ScaledPng -InputPath $source -OutputPath (Join-Path $dir "ic_launcher_foreground.png") -Size $entry.Value -Inset $inset
}

Write-Host "Android launcher icons generated from $source"
