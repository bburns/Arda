<#
.SYNOPSIS
  Stitch the 64 ME-DEM Unreal Engine heightmap tiles into one georeferenced GeoTIFF.

.DESCRIPTION
  The high-resolution DEM (MEDEM_x{0-7}_y{0-7}.png) is an 8x8 grid of 4033x4033
  16-bit grayscale PNGs exported from Unreal Engine. Adjacent tiles share one
  edge row/column, so the full mosaic is 8*4032+1 = 32257 px square. Tile x
  increases eastward and tile y increases NORTHWARD (y=7 is the top row).

  This script assumes the mosaic covers the same 2000 km square as 10k.jpg and
  derives its georeferencing from data/rasters/10k.wld, so the two DEMs overlay
  exactly. It writes a world file per tile, builds a VRT mosaic, then converts
  it to a Cloud Optimized GeoTIFF (deflate compressed, internal overviews).

  Requires GDAL - the QGIS standalone installer ships it. Point -QgisDir at the
  install folder if it isn't auto-detected.

.EXAMPLE
  .\scripts\build-dem.ps1 -TilesDir "D:\height_ue" -OutFile "data\rasters\dem40k.tif"
#>
param(
    [Parameter(Mandatory)] [string] $TilesDir,
    [string] $OutFile = (Join-Path $PSScriptRoot "..\data\rasters\dem40k.tif"),
    [string] $QgisDir,
    [int] $TileSize = 4033,
    [int] $Overlap = 1,
    [int] $GridSize = 8,
    [string] $Crs = "EPSG:32631"
)

$ErrorActionPreference = "Stop"

# --- locate GDAL via the QGIS install --------------------------------------
if (-not $QgisDir) {
    $QgisDir = Get-ChildItem "C:\Program Files\QGIS*", "C:\OSGeo4W*" -Directory -ErrorAction SilentlyContinue |
        Sort-Object Name -Descending | Select-Object -First 1 -ExpandProperty FullName
}
$envBat = Join-Path $QgisDir "bin\o4w_env.bat"
if (-not (Test-Path $envBat)) { throw "GDAL not found - no o4w_env.bat under '$QgisDir'. Pass -QgisDir." }

function Invoke-Gdal([string] $cmd) {
    Write-Host ">> $cmd"
    cmd /c "call `"$envBat`" >nul && $cmd"
    if ($LASTEXITCODE -ne 0) { throw "GDAL command failed ($LASTEXITCODE): $cmd" }
}

# --- georeferencing from 10k.wld -------------------------------------------
# World files give the CENTER of the top-left pixel, so back out the corner.
$wld = Get-Content (Join-Path $PSScriptRoot "..\data\rasters\10k.wld")
$px10k = [double] $wld[0]
$cornerX = [double] $wld[4] - $px10k / 2
$cornerY = [double] $wld[5] + $px10k / 2
$extent = 10000 * $px10k

$step = $TileSize - $Overlap
$mosaicPx = $GridSize * $step + $Overlap
$px = $extent / $mosaicPx
Write-Host "Mosaic ${mosaicPx}x${mosaicPx} px, $([math]::Round($px, 3)) m/px, extent $extent m"

$tiles = @()
for ($y = 0; $y -lt $GridSize; $y++) {
    for ($x = 0; $x -lt $GridSize; $x++) {
        $png = Join-Path $TilesDir "MEDEM_x${x}_y${y}.png"
        if (-not (Test-Path $png)) { throw "Missing tile $png" }
        $row = $GridSize - 1 - $y   # tile y counts up from the south edge
        $originX = $cornerX + $x * $step * $px + $px / 2
        $originY = $cornerY - $row * $step * $px - $px / 2
        @($px, 0, 0, -$px, $originX, $originY) -join "`n" |
            Set-Content -Encoding ascii ([IO.Path]::ChangeExtension($png, ".wld"))
        $tiles += $png
    }
}

# --- stitch ------------------------------------------------------------------
$OutFile = [IO.Path]::GetFullPath($OutFile)
$vrt = [IO.Path]::ChangeExtension($OutFile, ".vrt")
$list = Join-Path $TilesDir "tiles.txt"
$tiles | Set-Content -Encoding ascii $list

Invoke-Gdal "gdalbuildvrt -a_srs $Crs -input_file_list `"$list`" `"$vrt`""
Invoke-Gdal ("gdal_translate -of GTiff -co TILED=YES -co COMPRESS=DEFLATE -co PREDICTOR=2 " +
             "-co NUM_THREADS=ALL_CPUS -co BIGTIFF=IF_SAFER `"$vrt`" `"$OutFile`"")
# internal overviews so QGIS can pan/zoom the full map without reading 2 GB
Invoke-Gdal ("gdaladdo -r average --config COMPRESS_OVERVIEW DEFLATE --config PREDICTOR_OVERVIEW 2 " +
             "`"$OutFile`" 2 4 8 16 32 64")
Invoke-Gdal "gdalinfo -stats `"$OutFile`""

# --- hillshade -----------------------------------------------------------------
# The 16-bit values are ~250-360x the old 8-bit ones, so z=0.4 here gives the
# same relief as z=100 did for 10k.jpg. JPEG-in-TIFF keeps it ~1/5 the size.
$hs = Join-Path (Split-Path $OutFile) "hillshade40k.tif"
Invoke-Gdal ("gdaldem hillshade -z 0.4 -compute_edges -co TILED=YES -co COMPRESS=JPEG " +
             "-co JPEG_QUALITY=85 -co NUM_THREADS=ALL_CPUS -co BIGTIFF=IF_SAFER `"$OutFile`" `"$hs`"")
Invoke-Gdal "gdaladdo -r average --config COMPRESS_OVERVIEW JPEG `"$hs`" 2 4 8 16 32 64"

Remove-Item $vrt, $list
Write-Host "Wrote $OutFile ($([math]::Round((Get-Item $OutFile).Length / 1MB)) MB)"
Write-Host "Wrote $hs ($([math]::Round((Get-Item $hs).Length / 1MB)) MB)"
