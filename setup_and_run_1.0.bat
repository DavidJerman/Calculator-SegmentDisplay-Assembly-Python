@Echo off
Color 09
Echo Libraries to install: pyserial, datetime
TIMEOUT /T 2 

Color 02
pip install pyserial
Color 01
Echo ----------------
Echo 1 / 2 Complete
Echo ----------------

Color 02
pip install datetime
Color 01
Echo ----------------
Echo 2 / 2 Complete
Echo ----------------

Echo Python-Assembler calculator
Echo Errors and such from python will apear here


Color 0A
arduinoCalculator_v3.0.py