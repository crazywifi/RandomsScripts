@ECHO off

echo.
echo "<<<Systeminfo>>>"
systeminfo
echo.
echo "<<<Net User>>>"
net user
echo.
echo "<<<Netsta>>>"
netstat -an
echo.
echo "<<<Net Share>>>"
net share
echo.
echo "<<<USB Check>>>"
REG QUERY HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR
echo.
echo "<<<Hotfix>>>"
wmic qfe list full /format:htable > hotfix.html
echo.
echo "<<<Ipconfig>>>"
ipconfig
echo.
echo "<<<Installed Software>>>"
wmic /output:InstalledSoftwareList.txt  product get name,Vendor,version,InstallDate

echo "Completed...."
