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

$apk = 'build\app\outputs\flutter-apk\app-release.apk'
$desktop = [Environment]::GetFolderPath('Desktop')
Copy-Item $apk (Join-Path $desktop 'outrepd.apk') -Force

Write-Host "`nDone." -ForegroundColor Green
Write-Host "  Phone:       $(Join-Path $desktop 'outrepd.apk')"
Write-Host '  Google Play: build\app\outputs\bundle\release\app-release.aab'
Write-Host '  Web:         build\web'
