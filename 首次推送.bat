@echo off
REM ============================================================
REM  first-push.bat  -  push this repo to GitHub for the first time
REM ============================================================
cd /d "%~dp0"

echo ==================================================
echo   First Push to GitHub
echo ==================================================
echo.
echo   Before running, make sure you created the repo:
echo.
echo     1. Open    https://github.com/new
echo     2. Name    learning-notes
echo     3. Public
echo     4. Leave ALL checkboxes UNCHECKED
echo        (no README / .gitignore / license)
echo     5. Create repository
echo.
echo ==================================================
pause

echo.
echo --- Network ---
set GH_NET_FAIL=
call proxy-setup.bat
if "%GH_NET_FAIL%"=="1" goto :failed

echo.
echo --- Remote ---
git remote remove origin 2>nul
git remote add origin https://github.com/Hanzheng-one/learning-notes.git
git remote -v

echo.
echo --- Branch ---
git branch -M main

echo.
echo --- Pushing ---
echo   (a browser window may open - please sign in)
git push -u origin main
if errorlevel 1 goto :failed

echo.
echo ==================================================
echo   SUCCESS - source code pushed.
echo.
echo   NEXT: double-click deploy.bat
echo         to publish the website itself.
echo ==================================================
pause
goto :eof

:failed
echo.
echo ==================================================
echo   FAILED - read the message above.
echo.
echo   Most likely causes:
echo     - proxy app is not running
echo     - repo not created yet, or name mismatch
echo     - browser sign-in was cancelled
echo ==================================================
pause
