@echo off
REM ============================================================
REM  deploy.bat  -  push source + publish site to GitHub Pages
REM ============================================================
cd /d "%~dp0"

echo ==================================================
echo   Learning Notes - Publish
echo ==================================================
echo   1/3  network
echo   2/3  push source to main
echo   3/3  build site to gh-pages
echo ==================================================
echo.

echo --- 1/3 Network ---
set GH_NET_FAIL=
call proxy-setup.bat
if "%GH_NET_FAIL%"=="1" goto :failed

echo.
echo --- 2/3 Push source ---
git add -A
git commit -m "Update notes: %date% %time%" 2>nul || echo   (nothing new to commit)
git push origin main
if errorlevel 1 goto :failed

echo.
echo --- 3/3 Publish site ---
if not exist "%~dp0.venv\Scripts\activate.bat" (
  echo   [X] venv not found: .venv\Scripts\activate.bat
  goto :failed
)
call "%~dp0.venv\Scripts\activate.bat"
call mkdocs gh-deploy
if errorlevel 1 goto :failed

echo.
echo ==================================================
echo   DONE
echo.
echo   Site : https://Hanzheng-one.github.io/learning-notes/
echo   Note : on the very first deploy you still need to
echo          enable Pages once in repo Settings ^-^ Pages
echo          Source = Deploy from a branch
echo          Branch = gh-pages  /  /(root)
echo ==================================================
pause
goto :eof

:failed
echo.
echo ==================================================
echo   FAILED - read the message above.
echo ==================================================
pause
