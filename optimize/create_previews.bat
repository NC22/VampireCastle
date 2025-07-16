@echo off
setlocal enabledelayedexpansion

:: Папка запуска
cd /d %~dp0

:: Папки
set "BASE_ORIG=..\orig"
set "BASE_PREV=..\img\look"

:: Опциональная подпапка
set "SUBFOLDER=%~1"

if not "%SUBFOLDER%"=="" (
    set "SRC=%BASE_ORIG%\%SUBFOLDER%"
    set "DST=%BASE_PREV%\%SUBFOLDER%"
) else (
    set "SRC=%BASE_ORIG%"
    set "DST=%BASE_PREV%"
)

:: Получаем абсолютный путь SRC
pushd "%SRC%"
set "ABS_SRC=%CD%"
popd

echo Creating previews from: %SRC% to %DST%

for /r "%SRC%" %%F in (*.png) do (
    set "ABS=%%F"
    set "REL=!ABS:%ABS_SRC%\=!"
    set "OUT=%DST%\!REL!"

    :: Создадим папку назначения
    for %%D in ("!OUT!") do (
        if not exist "%%~dpD" mkdir "%%~dpD"
    )

    echo Creating preview for: %%~nxF
    magick "%%F" -resize 390x390^> "!OUT!"

    echo Optimizing preview with pngquant
    pngquant --force --output "!OUT!" --quality=65-80 "!OUT!"
)

echo Done.
pause