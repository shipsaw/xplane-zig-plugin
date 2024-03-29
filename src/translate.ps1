mkdir zig-src -Force

mkdir zig-src/win -Force
mkdir zig-src/win/xplm -Force
mkdir zig-src/win/widgets -Force

mkdir zig-src/lin -Force
mkdir zig-src/lin/xplm -Force
mkdir zig-src/lin/widgets -Force

Copy-Item ./SDK/CHeaders/XPLM/XPLMDefs.h ./SDK/CHeaders/Widgets
Copy-Item ./SDK/CHeaders/XPLM/XPLMDisplay.h ./SDK/CHeaders/Widgets

# Windows
Get-ChildItem SDK/CHeaders/XPLM/*.h -File | ForEach-Object { zig translate-c -D IBM=1 -D XPLM200=1 -D XPLM210=1 -D XPLM300=1 -D XPLM301=1 -D XPLM302=1 -D XPLM303=1 -D APL=0 -lc -fstrip $_.FullName > "zig-src/win/xplm/$($_.Name -replace '\.h$', '.zig')" }
Get-ChildItem SDK/CHeaders/Widgets/*.h -File | ForEach-Object { zig translate-c -D IBM=1 -D XPLM200=1 -D XPLM210=1 -D XPLM300=1 -D XPLM301=1 -D XPLM302=1 -D XPLM303=1 -D APL=0 -lc -fstrip $_.FullName > "zig-src/win/widgets/$($_.Name -replace '\.h$', '.zig')" }

# Linux
Get-ChildItem SDK/CHeaders/XPLM/*.h -File | ForEach-Object { zig translate-c -D IBM=0 -D XPLM200=1 -D XPLM210=1 -D XPLM300=1 -D XPLM301=1 -D XPLM302=1 -D XPLM303=1 -D APL=0 -D LIN=1 -lc -fstrip $_.FullName > "zig-src/lin/xplm/$($_.Name -replace '\.h$', '.zig')" }
Get-ChildItem SDK/CHeaders/Widgets/*.h -File | ForEach-Object { zig translate-c -D IBM=0 -D XPLM200=1 -D XPLM210=1 -D XPLM300=1 -D XPLM301=1 -D XPLM302=1 -D XPLM303=1 -D APL=0 -D LIN=1 -lc -fstrip $_.FullName > "zig-src/lin/widgets/$($_.Name -replace '\.h$', '.zig')" }
