:: Objective of the script is to toggle the proxy-settings for
:: - npm
:: - yarn
:: - git
:: 
:: Usage: 
::  Replace IP addresses in proxy_URL, proxy_URL2 and check
::  according to your proxy
::  Execute the script with cmd, Powershell or do a doubleclick
::  WindowsKey+R -> type in cmd -> Hit enter
::  Navigate to the script via cd
::  type toggle_proxy.bat into the cmd and hit enter
:: 
:: When you are at the office, make sure the script
::  says: PROXY ENABLED
:: When you want to work at home, make sure the script
::  says: PROXY DISABLED

@echo off

SET proxy_URL = "XXX"
SET proxy_URL2 = "XYZ"
SET check = "XXX"
echo.
echo.
echo Toggle proxy settings
echo This will take up to 1min, npm is slow :/
echo.

yarn config list | find /i %check% > NUL
if not errorlevel 1 (
  echo --- PROXY DISABLED
  echo.

  yarn config delete proxy
  yarn config delete https-proxy

  npm config delete proxy
  npm config delete https-proxy

  git config --global --unset http.proxy
  git config --global --unset core.gitproxy
  git config --global --unset socks.proxy

  echo. 
  echo npm proxy settings disabled
) else (
  echo --- PROXY ENABLED
  echo.

:: http://10.43.100.200:8080/accelerated_pac_base.pac
  yarn config set proxy %proxy_URL%
  yarn config set https-proxy %proxy_URL%

  npm config set proxy %proxy_URL%
  npm config set https-proxy %proxy_URL%

  git config --global http.proxy %proxy_URL2%
  git config --global core.gitproxy "git-proxy"
  git config --global socks.proxy %proxy_URL2%

  echo.
  echo npm proxy settings enabled
)
