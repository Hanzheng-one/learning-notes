@echo off
chcp 65001 >nul 2>&1
cd /d "%~dp0"

echo ================================================
echo  Learning Notes Site - Publish
echo ================================================
echo.
echo  Step 1/2  Push source files to main branch
echo  Step 2/2  Build and publish site to gh-pages
echo ================================================
echo.

call "%~dp0.venv\Scripts\activate.bat"

echo --- Step 1: pushing source ---
git add -A
git commit -m "Update notes: %date% %time%" 2>nul || echo (nothing new to commit)
git branch -m main 2>nul
git push origin main 2>nul || echo (push skipped - remote may not be linked yet)

echo.
echo --- Step 2: publishing site ---
mkdocs gh-deploy

echo.
echo Done. Press any key to close.
pause >nul
