@echo off
chcp 65001 >nul 2>&1
cd /d "%~dp0"

call "%~dp0.venv\Scripts\activate.bat"

echo ================================================
echo  Learning Notes Site - Local Preview
echo ================================================
echo.

python -c "import re,urllib.parse as u;y=open('mkdocs.yml',encoding='utf-8').read();m=re.search(r'site_url:\s*(\S+)',y);p=u.urlparse(m.group(1)).path.rstrip('/') if m else '';print('  Open this URL in your browser:');print('');print('  >>> http://127.0.0.1:8000'+p+'/');print('');print('  (this sub-path comes from the site_url in mkdocs.yml');print('   if you rename the repo, update site_url too)')"

echo.
echo ================================================
echo  Keep this window OPEN while previewing.
echo  Edit files in docs/ and the page auto-refreshes.
echo  Press Ctrl+C (then Y) to stop the server.
echo ================================================
echo.

mkdocs serve

echo.
echo Server stopped. Press any key to close.
pause >nul
