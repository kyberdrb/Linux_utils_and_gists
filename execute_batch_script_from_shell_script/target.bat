# Dispatching/Executing Batch script from Shell script
# target script - in batch

@echo on

set DRIVE_LETTER=%1
set DIRECTORY=%2
set OPTIONS=%3

%DRIVE_LETTER%:
cd %DRIVE_LETTER%:\%DIRECTORY%\
script.bat %OPTIONS%
