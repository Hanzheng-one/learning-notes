@echo off
REM ============================================================
REM  proxy-setup.bat
REM  Auto-read the Windows system proxy and apply it to Git
REM  Called by first-push.bat / deploy.bat
REM  Do NOT run this file directly.
REM ============================================================
REM
REM  Why this exists:
REM    The Windows system proxy only affects programs that honour
REM    the IE/WinINet setting (browsers do). Git's own libcurl runs
REM    in its own process and dials out directly, which is why you
REM    can browse github.com fine but 'git push' times out.
REM
REM  Why it re-reads every run:
REM    Proxy apps often pick the port dynamically (65532 in our
REM    test) and it can change after a restart. Reading the registry
REM    on each run keeps it working.
REM ============================================================

set GH_PROXY=
set GH_ENABLE=0

for /f "skip=2 tokens=3" %%A in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable 2^>nul') do set GH_ENABLE=%%A

if "%GH_ENABLE%"=="0x1" (
  for /f "skip=2 tokens=2,*" %%A in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer 2^>nul') do set GH_PROXY=%%B
)

if defined GH_PROXY (
  git config --global http.https://github.com.proxy %GH_PROXY%
  echo    Proxy   : %GH_PROXY%
  echo    Applied : yes, scoped to github.com only
  goto :check
)

git config --global --unset http.https://github.com.proxy 2>nul
echo    Proxy   : not detected, trying direct

:check
git ls-remote --heads origin >nul 2>&1
if errorlevel 1 (
  echo    Reach   : FAILED
  echo.
  echo    Cannot reach GitHub. Please check:
  echo      1. Is your proxy app running?
  echo      2. Can the browser open github.com?
  echo      3. If the proxy port changed, this script
  echo         re-reads it automatically on the next run.
  echo.
  set GH_NET_FAIL=1
) else (
  echo    Reach   : OK
)
goto :eof
