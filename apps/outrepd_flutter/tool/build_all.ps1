# Pulls the branch and builds everything a release needs: the APK for a phone,
# the app bundle for Google Play, and the web build. The APK is also copied to
# the Desktop.
#
# Run from apps\outrepd_flutter in PowerShell:
#
#     powershell -ExecutionPolicy Bypass -File tool\build_all.ps1
#
# Needs supabase\keys.env with SUPABASE_URL=... and SUPABASE_ANON_KEY=...
# lines, and, for a build Google Play accepts, android\key.properties and the
# keystore it names (docs\building.md).

$ErrorActionPreference = 'Stop'
$branch = 'camera-rep-counter-zzqfhq'
$keys = 'supabase\keys.env'

# This machine's toolchain, set for this run only. None of it is set globally:
# the global JAVA_HOME is a JDK 8 that cannot build Android, and C: has too
# little room for the Gradle cache or the build tree (over 1 GB), so both live
# on D:. OUTREPD_BUILD_DIR is read by android\build.gradle.kts.
$toolchain = @{
  JAVA_HOME         = "$env:USERPROFILE\jdk17\jdk-17.0.20+8"
  ANDROID_HOME      = 'C:\Android\Sdk'
  GRADLE_USER_HOME  = 'D:\gradle-home'
  OUTREPD_BUILD_DIR = 'D:\outrepd-build'
}
foreach ($name in $toolchain.Keys) {
  if (Test-Path $toolchain[$name]) {
    Set-Item "env:$name" $toolchain[$name]
  } elseif ($name -eq 'OUTREPD_BUILD_DIR' -or $name -eq 'GRADLE_USER_HOME') {
    # Creating them is fine; building onto C: without them is not.
    New-Item -ItemType Directory -Force $toolchain[$name] | Out-Null
    Set-Item "env:$name" $toolchain[$name]
  }
}
if ($env:JAVA_HOME) { $env:Path = "$env:JAVA_HOME\bin;$env:Path" }

function Step($name, [scriptblock]$run) {
  Write-Host "`n== $name ==" -ForegroundColor Cyan
  & $run
  if ($LASTEXITCODE -ne 0) { throw "$name failed (exit code $LASTEXITCODE)" }
}

if (-not (Test-Path $keys)) { throw "Missing $keys" }
$text = Get-Content $keys -Raw
foreach ($name in 'SUPABASE_URL', 'SUPABASE_ANON_KEY') {
  if ($text -notmatch "(?m)^\s*$name\s*=") { throw "$keys has no $name= line" }
}
if (-not (Test-Path 'android\key.properties')) {
  Write-Warning 'No android\key.properties: the builds will be signed with the debug key, which Google Play refuses.'
}

Step 'git pull' { git pull origin $branch }
Step 'flutter pub get' { flutter pub get }

$common = @('--release', '--no-tree-shake-icons', "--dart-define-from-file=$keys")
Step 'APK' { flutter build apk @common }
Step 'App bundle' { flutter build appbundle @common }
Step 'Web' { flutter build web @common }

# With OUTREPD_BUILD_DIR set, Gradle writes the outputs there, not under build\
# (Flutter's own "failed to produce an .apk" message after a good build is
# about exactly this, and is wrong).
$out = if ($env:OUTREPD_BUILD_DIR) { Join-Path $env:OUTREPD_BUILD_DIR 'app\outputs' } else { 'build\app\outputs' }
$apk = Join-Path $out 'flutter-apk\app-release.apk'
$aab = Join-Path $out 'bundle\release\app-release.aab'
$desktop = [Environment]::GetFolderPath('Desktop')
Copy-Item $apk (Join-Path $desktop 'outrepd.apk') -Force

Write-Host "`nDone." -ForegroundColor Green
Write-Host "  Phone:       $(Join-Path $desktop 'outrepd.apk')"
Write-Host "  Google Play: $aab"
Write-Host '  Web:         build\web'
