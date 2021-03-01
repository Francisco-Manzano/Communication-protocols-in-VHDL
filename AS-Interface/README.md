Classic AS-Interface implementation. 

Up to 31 slaves (Addresses 1 to 31).

There are 4 bits of data and 4 bits of parameters in each slave. Data shows the I/O status of each slave (ON/OFF). Parameters modify the behaviour of the slave ( frequency, speed...).

Hot module replacement => The master saves the address, ID and I/O from the defective slave ( a slave is defective when it doesn't answer the requests made by the master). After that, if the master detects a new slave with address 0 (factory address), it checks if both ID and I/O are identical to the ones saved. If the are, the master changes the new slave address so it matches the defective slave's old address.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

COMMANDS

The master is a mix of M0 and M2, meaning that it can send data, parameters and commands, but not all of them. When the system is initialized or when a new slave is detected, the master sends commands Read I/O and Read ID to the slaves. These two commands are mandatory because the master needs to store the I/O and ID from each slave. 

Address_assignment is also implemented, in case a hot module replacement is required.

These commands are done by the master on it's own. The user can't introduce then manually.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DATA AND PARAMETERS

The user can modify data and parameters from a slave detected with the switches and buttons from the development board DE10-Lite. The master receives this data/parameter from the user and sends the order to the selected slave. 

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DATA DISPLAY

BCD_7 from the DE10-Lite shows when a slave is detected, as well as the data/parameters (hex value) from this slave. It also shows the data/parameter the user is introducing manually.
Slaves' inputs are connected to GPIOs pins.
Slaves' outputs are connected to the leds on top of the switches.


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SLAVES

There are many types of slaves according to their I/O and ID. I decided to create three "easy" slaves, just to test if the implementation is properly working. These slaves have
2 digital inputs and 2 digital outputs. The I/O code is "0x3", and the ID code is "0xF" because its a free slave, meaning the I/O do whatever you want.

2 of these slaves are connected before the system is initialized. The purpose of the third one (address 0) is to test the hot module replacement. 

The slaves implemented can answer to all the commands listed in the protocol documentation ( IEC 62026-2). They don't have status leds implemented but they answer to the status' commands modifying their status' bits.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PHYSICAL IMPLEMENTATION

![placa](https://user-images.githubusercontent.com/79548135/109556379-07a8ea80-7ad7-11eb-8c71-e24374bd9107.png)








