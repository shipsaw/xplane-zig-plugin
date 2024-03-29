mkdir src/zig-src -Force

Copy-Item ./src/SDK/CHeaders/XPLM/XPLMDefs.h ./src/SDK/CHeaders/Widgets
Copy-Item ./src/SDK/CHeaders/XPLM/XPLMDisplay.h ./src/SDK/CHeaders/Widgets

# Windows
Get-ChildItem src/SDK/CHeaders/XPLM/*.h -File | ForEach-Object { zig translate-c -D IBM=1 -D XPLM200=1 -D XPLM210=1 -D XPLM300=1 -D XPLM301=1 -D XPLM302=1 -D XPLM303=1 -D APL=0 -lc -fstrip $_.FullName > "src/zig-src/$($_.Name -replace '\.h$', '.zig')" }
Get-ChildItem src/SDK/CHeaders/Widgets/*.h -File | ForEach-Object { zig translate-c -D IBM=1 -D XPLM200=1 -D XPLM210=1 -D XPLM300=1 -D XPLM301=1 -D XPLM302=1 -D XPLM303=1 -D APL=0 -lc -fstrip $_.FullName > "src/zig-src/$($_.Name -replace '\.h$', '.zig')" }