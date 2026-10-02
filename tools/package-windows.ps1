param(
    [string]$QtRoot = "$env:USERPROFILE/Qt/6.8.3/mingw_64",
    [string]$MinGWRoot = "$env:USERPROFILE/Qt/Tools/mingw1310_64",
    [string]$BuildDirectory = "$env:USERPROFILE/SkyDolly-build/build-zh_CN",
    [string]$PackageDirectory = "$env:USERPROFILE/Desktop/SkyDolly-zh_CN"
)
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$binaryDirectory = Join-Path $BuildDirectory 'bin'
if (!(Test-Path -LiteralPath (Join-Path $binaryDirectory 'SkyDolly.exe'))) { throw 'Build SkyDolly.exe first.' }
if (!(Test-Path -LiteralPath (Join-Path $binaryDirectory 'Plugins/Connect/MSFSSimConnect.dll'))) {
    throw 'The Microsoft Flight Simulator connection plugin is missing. Build with MSFS_SDK configured.'
}
$geoidFiles = @('egm2008-5.pgm', 'egm2008-5.pgm.aux.xml', 'egm2008-5.wld')
foreach ($name in $geoidFiles) {
    if (!(Test-Path -LiteralPath (Join-Path $binaryDirectory "Resources/geoids/$name"))) {
        throw "Missing geoid resource: $name. Configure the build with -DSKY_FETCH_EGM=ON."
    }
}
if (Test-Path -LiteralPath $PackageDirectory) { throw 'Package directory already exists. Choose a new output directory.' }
& (Join-Path $PSScriptRoot 'check-translations.ps1')
New-Item -ItemType Directory -Path $PackageDirectory | Out-Null
Get-ChildItem -LiteralPath $binaryDirectory -Filter '*.dll' | Copy-Item -Destination $PackageDirectory
Copy-Item -LiteralPath (Join-Path $binaryDirectory 'SkyDolly.exe') -Destination $PackageDirectory
foreach ($name in @('Plugins', 'Resources')) {
    Copy-Item -LiteralPath (Join-Path $binaryDirectory $name) -Destination $PackageDirectory -Recurse
}
$connectConfiguration = Join-Path $binaryDirectory 'SimConnect.cfg'
if (Test-Path -LiteralPath $connectConfiguration) { Copy-Item -LiteralPath $connectConfiguration -Destination $PackageDirectory }
foreach ($name in @('LICENSE', 'THIRD_PARTY.md', 'README-zh_CN.md')) {
    Copy-Item -LiteralPath (Join-Path $root $name) -Destination $PackageDirectory
}
foreach ($relativeName in @('Plugins/Connect/PathCreator.dll', 'Plugins/Module/Template.dll')) {
    $file = Join-Path $PackageDirectory $relativeName
    if (Test-Path -LiteralPath $file) { Remove-Item -LiteralPath $file }
}
$env:PATH = "$QtRoot/bin;$MinGWRoot/bin;" + $env:PATH
& (Join-Path $QtRoot 'bin/windeployqt.exe') --release --compiler-runtime --sql --no-opengl-sw --no-system-d3d-compiler --translations zh_CN (Join-Path $PackageDirectory 'SkyDolly.exe')
if ($LASTEXITCODE -ne 0) { throw 'windeployqt failed.' }
$translationDirectory = Join-Path $PackageDirectory 'translations'
New-Item -ItemType Directory -Path $translationDirectory -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $QtRoot 'translations/qtbase_zh_CN.qm') -Destination $translationDirectory
$qtConfiguration = "[Paths]`nPrefix=.`nPlugins=.`nTranslations=translations`n"
$qtConfiguration | Set-Content -LiteralPath (Join-Path $PackageDirectory 'qt.conf') -Encoding utf8
$required = @('SkyDolly.exe', 'Qt6Core.dll', 'Qt6Gui.dll', 'Qt6Widgets.dll', 'Qt6Sql.dll',
    'platforms/qwindows.dll', 'sqldrivers/qsqlite.dll', 'SimConnect.dll',
    'Plugins/Connect/MSFSSimConnect.dll', 'translations/qtbase_zh_CN.qm',
    'Resources/geoids/egm2008-5.pgm', 'Resources/geoids/egm2008-5.pgm.aux.xml', 'Resources/geoids/egm2008-5.wld',
    'libgcc_s_seh-1.dll', 'libstdc++-6.dll', 'libwinpthread-1.dll')
foreach ($relativeName in $required) {
    if (!(Test-Path -LiteralPath (Join-Path $PackageDirectory $relativeName))) { throw "Missing runtime file: $relativeName" }
}
Get-ChildItem -LiteralPath $PackageDirectory -File -Recurse | ForEach-Object {
    $relativeName = [System.IO.Path]::GetRelativePath($PackageDirectory, $_.FullName)
    "$((Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash)  $relativeName"
} | Set-Content -LiteralPath (Join-Path $PackageDirectory 'SHA256SUMS.txt') -Encoding ascii
$archive = "$PackageDirectory.zip"
Compress-Archive -LiteralPath $PackageDirectory -DestinationPath $archive
Write-Output "Package: $PackageDirectory"
Write-Output "Archive: $archive"
