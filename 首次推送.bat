@echo off
chcp 65001 >nul 2>&1
cd /d "%~dp0"

echo ================================================
echo  First Push to GitHub
echo ================================================
echo.
echo  BEFORE running this, you must create the repo:
echo.
echo    1. Open  https://github.com/new
echo    2. Repository name : learning-notes
echo    3. Visibility      : Public
echo    4. IMPORTANT - leave ALL boxes UNCHECKED
echo       (do NOT add README / .gitignore / license)
echo    5. Click "Create repository"
echo.
echo ================================================
pause

echo.
echo --- Setting remote ---
git remote remove origin 2>nul
git remote add origin https://github.com/Hanzheng-one/learning-notes.git
git remote -v

echo.
echo --- Renaming branch to main ---
git branch -M main

echo.
echo --- Pushing ---
echo (a browser window may open for you to sign in)
git push -u origin main

echo.
if errorlevel 1 (
  echo ================================================
  echo  Push FAILED. Check the message above.
  echo ================================================
) else (
  echo ================================================
  echo  Source pushed OK!
  echo.
  echo  Next: double-click deploy.bat to publish
  echo  the website itself.
  echo ================================================
)
pause
