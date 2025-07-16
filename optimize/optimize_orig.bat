@echo off
setlocal enabledelayedexpansion

:: Папка запуска
cd /d %~dp0

:: Папка с оригиналами
set "BASE_ORIG=..\orig"

:: Опциональная подпапка
set "SUBFOLDER=%~1"

if not "%SUBFOLDER%"=="" (
    set "TARGET=%BASE_ORIG%\%SUBFOLDER%"
) else (
    set "TARGET=%BASE_ORIG%"
)

echo Optimizing originals in: %TARGET%

for /r "%TARGET%" %%F in (*.png) do (
    echo Processing: %%~nxF
    
    set "W="
    for /f "usebackq" %%W in (`magick identify -format "%%w" "%%F"`) do set "W=%%W"
    
    set RESIZE_FLAG=0
    if !W! gtr 2000 set RESIZE_FLAG=1
    
    echo !W!
    echo !RESIZE_FLAG!
    
    if !RESIZE_FLAG! equ 1 (
        echo Resizing %%F to max 2000px
        magick "%%F" -resize 2000x2000^> "%%F"
        echo Optimizing with pngquant
        pngquant --force --output "%%F" --quality=65-80 "%%F"
    ) else (
        echo Skipping %%F
    )
)

echo Done.
pause