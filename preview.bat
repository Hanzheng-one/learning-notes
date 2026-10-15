@echo off
REM ============================================================
REM  preview.bat  -  local preview with hot reload
REM ============================================================
cd /d "%~dp0"

if not exist "%~dp0.venv\Scripts\activate.bat" (
  echo   [X] venv not found: .venv\Scripts\activate.bat
  pause
  goto :eof
)
call "%~dp0.venv\Scripts\activate.bat"

echo ==================================================
echo   Learning Notes - Local Preview
echo ==================================================
echo.
echo   Open this URL in your browser:
echo.
python preview_url.py
echo.
echo   The sub-path comes from site_url in mkdocs.yml.
echo   If you rename the repo, update site_url too,
echo   otherwise local preview and the live site drift apart.
echo.
echo ==================================================
echo   Keep this window OPEN while previewing.
echo   Edit files under docs/ and pages auto-refresh.
echo   Press Ctrl+C then Y to stop the server.
echo ==================================================
echo.

mkdocs serve

echo.
echo   Server stopped.
pause
