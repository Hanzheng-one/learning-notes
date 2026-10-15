@echo off
REM ============================================================
REM  proxy-setup.bat
REM  Make git work through the Windows system proxy.
REM  Verification is done by an ACTUAL connection test, not by
REM  inspecting the registry and guessing.
REM  Called by first-push.bat / deploy.bat.  Do NOT run directly.
REM ============================================================
REM
REM  Why a proxy is needed at all:
REM    Windows' system proxy only applies to programs that honour
REM    the WinINet setting (browsers do). Git's own libcurl dials
REM    out directly - which is why browsing github.com can work
REM    while 'git push' times out.
REM
REM  Why we TEST instead of INSPECT:
REM    An earlier version read the port from the registry and then
REM    checked whether it was listening. That looks clever but is
REM    fragile: it breaks in TUN / transparent mode (where there
REM    is no local port at all), and it is sensitive to stray
REM    characters in the registry value. Trying a real connection
REM    and falling back is simpler and always reflects reality.
REM
REM  Why we retry:
REM    Proxy nodes blip. A single failure is not proof that the
REM    configuration is wrong.
REM ============================================================

set GH_NET_FAIL=
set GH_MODE=
set GH_TRY=0
set GH_DIRECT_TRIES=
set GH_LOG=%TEMP%\gh_reach_check.txt

REM ---- git must exist ----
where git >nul 2>&1
if errorlevel 1 goto :nogit

REM ---- read the system proxy (token 3 is the value itself) ----
set GH_ENABLE=0
for /f "skip=2 tokens=3" %%A in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable 2^>nul') do set GH_ENABLE=%%A

set GH_PROXY=
if "%GH_ENABLE%"=="0x1" for /f "skip=2 tokens=3" %%A in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer 2^>nul') do set GH_PROXY=%%A

if not defined GH_PROXY goto :direct_only
if "%GH_PROXY%"=="" goto :direct_only

REM ================= attempt 1: through the proxy =================
git config --global http.https://github.com.proxy %GH_PROXY%
git config --global http.https://github.com.lowSpeedLimit 1000
git config --global http.https://github.com.lowSpeedTime 60

echo    Proxy   : %GH_PROXY%
echo    Mode    : proxy, testing...
call :probe 3
if not defined GH_NET_FAIL goto :done_proxy

echo    Proxy   : unreachable, falling back to direct
git config --global --unset http.https://github.com.proxy 2>nul
REM a direct connection to github.com rarely works domestically, so
REM give it a single quick shot instead of three long timeouts
set GH_DIRECT_TRIES=1
goto :direct_only

REM ================= attempt 2: direct =================
:direct_only
if not defined GH_DIRECT_TRIES set GH_DIRECT_TRIES=3
echo    Mode    : direct, testing...
call :probe %GH_DIRECT_TRIES%
if not defined GH_NET_FAIL goto :done_direct
goto :fail

:done_proxy
echo    Reach   : OK  (via proxy, attempt %GH_TRY%)
if exist "%GH_LOG%" del "%GH_LOG%" >nul 2>&1
goto :eof

:done_direct
echo    Reach   : OK  (direct, attempt %GH_TRY%)
if exist "%GH_LOG%" del "%GH_LOG%" >nul 2>&1
goto :eof

:fail
echo    Reach   : FAILED
echo.
echo    ---- what git said -------------------------------
type "%GH_LOG%"
echo    -------------------------------------------------
echo.
echo    Things to check:
echo      1. Is the proxy app running right now?
echo      2. Can the browser open github.com this moment?
echo      3. Try switching the proxy node, then rerun this.
echo.
set GH_NET_FAIL=1
goto :eof

REM ------------------------------------------------------------
REM  :probe [max_attempts]
REM  Tries git ls-remote up to N times (default 3).
REM  Sets GH_NET_FAIL=1 if every attempt failed.
REM ------------------------------------------------------------
:probe
set GH_MAX=%1
if "%GH_MAX%"=="" set GH_MAX=3
set GH_TRY=0
set GH_NET_FAIL=
:att
set /a GH_TRY+=1
git ls-remote --heads origin > "%GH_LOG%" 2>&1
if not errorlevel 1 exit /b 0
if %GH_TRY% lss %GH_MAX% (
  echo    Retry   : attempt %GH_TRY% of %GH_MAX% failed, waiting...
  ping -n 3 127.0.0.1 >nul 2>&1
  goto :att
)
set GH_NET_FAIL=1
exit /b 1

:nogit
echo    Git     : NOT FOUND in PATH
echo.
echo    'git' is not on your Windows PATH, so nothing can be
echo    pushed. Reinstall Git for Windows, or open a NEW
echo    terminal so the updated PATH takes effect.
echo.
set GH_NET_FAIL=1
goto :eof
