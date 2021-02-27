
# Author = David Jerman
# Created some day in December of 2018
# This program is a graphical interface to communicate with arduino

#  Libraries included: datetime, time, pyserial, tkinter
import datetime
from time import sleep


# Start of the log
def log_start():
    with open("log.txt", "a") as fileLogStart:
        print("-" * 34, file=fileLogStart)
        date_time = str(datetime.datetime.now().strftime("%Y/%m/%d - %H:%M:%S"))
        print("[Log from: {}]".format(date_time), file=fileLogStart)
        print("-" * 34, file=fileLogStart)


# Saves the performed action to log
def char_save(button_suffix, char):
    with open("log.txt", "a") as fileLogChar:
        print(">> button_{0} => sent char '{1}' to arduino".format(button_suffix, char), file=fileLogChar)


print()
fileLog = open("log.txt", "a")

# Trying to import pyserial library
try:
    import serial
except:
    print("\n >> Could not run the program successfully due to a missing library 'pyserial'.\n", file=fileLog)
    while True:
        print(
            "Library 'serial' not installed, please install the library and restart the program. "
            "(In CMD type 'pip install pyserial' or locate the library on the internet, after installing pip.).")
        i = input()

# Trying to import tkinter library
try:
    import tkinter
except:
    print("\n >> Could not run the program successfully due to a missing library 'tkinter'.\n", file=fileLog)
    while True:
        print("Library 'tkinter' not installed, please install the library and restart the program. "
              "(In CMD type 'pip install tkinter' or locate the library on the internet, after installing pip.).")
        i = input()

# Getting user input about port number
while True:
    try:
        port = int(input("Enter the number of your COM port (if nothing typed, com port will be set to 6.)\n"))
        break
    except ValueError:
        print("Invalid Number!\n")
        print("Port set to COM6!\n")
        port = 6
        break

port = str(port)
port = "COM" + port

fileLog.close()

log_start()

# This part of the code tries to establish communication with arduino
try:
    ser = serial.Serial(port, 9600, timeout=0, parity=serial.PARITY_EVEN, rtscts=1)
    print("Port open: " + str(ser.is_open) + "\n")
    print(ser.name)
    print("")
    sleep(2)
    ser.write(b"0")
    print("Type 'help' for help\n")
except:
    with open("log.txt", "a") as fileLog:
        print(" >> Could not run the program successfully due to an issue with COM port.", file=fileLog)
    while True:
        print(
            "COM port busy or entered invalid COM port or maybe arduino isn't connected. Please exit the program, "
            "reconnect arduino and start the program again. Make sure no other program is listening on that COM"
            " port "
            "(exit any other terminals or programs).")
        i = input()

mainWindow = tkinter.Tk()
mainWindow.title("Python calculator GUI")
mainWindow.geometry("290x185")


# Functions for buttons, sending certain chars, in this case numbers

# Arduino accepts the numbers and uses them to calculate

# Performed action is saved to log
def send_1():
    ser.write(b"1")
    char_save("1", "1")


def send_2():
    ser.write(b"2")
    char_save("2", "2")


def send_3():
    ser.write(b"3")
    char_save("3", "3")


def send_4():
    ser.write(b"4")
    char_save("4", "4")


def send_5():
    ser.write(b"5")
    char_save("5", "5")


def send_6():
    ser.write(b"6")
    char_save("6", "6")


def send_7():
    ser.write(b"7")
    char_save("7", "7")


def send_8():
    ser.write(b"8")
    char_save("8", "8")


def send_9():
    ser.write(b"9")
    char_save("9", "9")


def send_0():
    ser.write(b"0")
    char_save("0", "0")


# Functions send operator chars to arduino and saves the action to log
def send_plus():
    ser.write(b"+")
    char_save("plus", "+")


def send_minus():
    ser.write(b"-")
    char_save("minus", "-")


def send_multi():
    ser.write(b"*")
    char_save("multi", "*")


def send_reset():
    ser.write(b"c")
    ser.write(b"0")
    char_save("reset", "c")


# Function deletes the last char in the entry
def one_back():
    with open("log.txt", "a") as fileLogBack:
        print(">> {}".format('button_back => Removed one char from entry'), file=fileLogBack)
    if len(entry_num.get()) > 0:
        entry_num.delete(len(entry_num.get())-1, len(entry_num.get()))
    else:
        pass


# Accepts any string checks if it is equal to any command and if so, executes the code for that command

# Otherwise it checks the string for ant non-numerical chars and id none are detected, it sends the string to arduino
# char by char
def analyze():
    text = entry_num.get()

    # Info command - Prints out info string
    if text == "info":
        with open("log.txt", "a") as fileLogInfo:
            print(">> Received command >> 'info' => Printed information", file=fileLogInfo)
        print("GUI Calculator created by David Jerman. \nUse together with arduino.\n")
        return 0

    # Help command - Prints out help string
    if text == "help":
        with open("log.txt", "a") as fileLogHelp:
            print(">> Received command >> 'help' => Printed help section", file=fileLogHelp)
        print("The calculator works like this:\n" + "-"*35 +
              "\nNumber pad - sends numbers directly to arduino\n"
              "Operator buttons"
              " - sent directly to arduino\n'<<' or 'back' - deletes the last letter/ number in the entry\n"
              "'=' - sends data contained in the entry to arduino, invalid input is filtered,"
              " commands are executed\n"
              "'x' - Clears any data that arduino is holding at the time\n\n"
              "Available commands:\n"
              "clearLog - Deletes the whole log\n"
              "readLog - Reads the whole log\n"
              "info - Reads the info"
              "\n\nNote!\n"
              "Pressing the buttons will not affect the entry, because you are meant to type in there\n"
              + "-"*35 + "\n")
        return 0

    # ReadLog command - Reads the whole log
    if text == "readLog":
        with open("log.txt", 'a') as fileLogRead:
            print(">> Received command >> 'readLog' => Printed the whole log", file=fileLogRead)
        with open("log.txt", 'r') as file:
            for line in file.readlines():
                print(line, end='')
        return 0

    # ClearLog command - Deletes the whole log and starts it over
    if text == "clearLog":
        with open("log.txt", "w") as fileDelete:
            fileDelete.write("")
        log_start()
        with open("log.txt", "a") as fileLogAfterClear:
            print(">> Received command >> 'clearLog' => Deleted the whole log", file=fileLogAfterClear)
        print("Log cleared!\n")
        return 0

    # Checks for any non-numerical chars
    with open("log.txt", "a") as fileLogCustomString:
        numbers = "0123456789*+-"
        for index in text:
            if index not in numbers:
                print("Invalid input!\n")
                print(
                    ">> Received invalid input: Didn't send to arduino to avoid errors >> \"{0}\"".format(text),
                    file=fileLogCustomString)
                return 0

        print(">> Set of chars sent >> \"{0}\"".format(text), file=fileLogCustomString)

        # Sends data to arduino char by char
        while text != "":
            temp_char = text[0].encode('ascii')
            ser.write(temp_char)
            sleep(1.1)
            try:
                text = text[1:len(text)]
            except:
                break


# Just like html, creating the whole interface with buttons and such
frame = tkinter.Frame()
frame.grid(row=0, column=0, padx=5, pady=5)

but_1 = tkinter.Button(frame, bg="green", font="80px", text="1", command=send_1)
but_1.grid(row=2, column=0, sticky='ew', padx=2, pady=2)
but_2 = tkinter.Button(frame, bg="green", font="80px", text="2", command=send_2)
but_2.grid(row=2, column=1, sticky='ew', padx=2, pady=2)
but_3 = tkinter.Button(frame, bg="green", font="80px", text="3", command=send_3)
but_3.grid(row=2, column=2, sticky='ew', padx=2, pady=2)
but_4 = tkinter.Button(frame, bg="green", font="80px", text="4", command=send_4)
but_4.grid(row=3, column=0, sticky='ew', padx=2, pady=2)
but_5 = tkinter.Button(frame, bg="green", font="80px", text="5", command=send_5)
but_5.grid(row=3, column=1, sticky='ew', padx=2, pady=2)
but_6 = tkinter.Button(frame, bg="green", font="80px", text="6", command=send_6)
but_6.grid(row=3, column=2, sticky='ew', padx=2, pady=2)
but_7 = tkinter.Button(frame, bg="green", font="80px", text="7", command=send_7)
but_7.grid(row=4, column=0, sticky='ew', padx=2, pady=2)
but_8 = tkinter.Button(frame, bg="green", font="80px", text="8", command=send_8)
but_8.grid(row=4, column=1, sticky='ew', padx=2, pady=2)
but_9 = tkinter.Button(frame, bg="green", font="80px", text="9", command=send_9)
but_9.grid(row=4, column=2, sticky='ew', padx=2, pady=2)
but_0 = tkinter.Button(frame, bg="green", font="80px", text="0", command=send_0)
but_0.grid(row=4, column=3, sticky='ew', padx=2, pady=2)

entry_num = tkinter.Entry(frame, bg="white", font="80px")
entry_num.grid(row=0, column=0, columnspan=4, sticky='ew', padx=2, pady=2)
entry_send = tkinter.Button(frame, bg="yellow", font="80px", text="=", command=analyze)
entry_send.grid(row=1, column=2, sticky='ew', padx=2, pady=2)

but_plus = tkinter.Button(frame, bg="yellow", font="40px", text="+", command=send_plus)
but_plus.grid(row=2, column=3, sticky='ew', padx=2, pady=2)
but_minus = tkinter.Button(frame, bg="yellow", font="40px", text="-", command=send_minus)
but_minus.grid(row=3, column=3, sticky='ew', padx=2, pady=2)
but_multi = tkinter.Button(frame, bg="yellow", font="40px", text="*", command=send_multi)
but_multi.grid(row=1, column=3, sticky='ew', padx=2, pady=2)
but_reset = tkinter.Button(frame, bg="red", font="40px", text="x", command=send_reset)
but_reset.grid(row=1, column=0, sticky="ew", padx=2, pady=2)
but_back = tkinter.Button(frame, bg="red", font="40px", text="<<", command=one_back)
but_back.grid(row=1, column=1, sticky='ew', padx=2, pady=2)

# Settings the max and min size of the window
mainWindow.update()
mainWindow.maxsize(frame.winfo_width()+10, frame.winfo_height()+10)
mainWindow.minsize(frame.winfo_width()+10, frame.winfo_height()+10)

mainWindow.mainloop()

fileLog.close()
