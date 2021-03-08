

   ###                            Modbus RTU implementation
         
   Master and slave implemented. Slave answers to digital functions (1,2,5,15).
    
   Baud rate = 115200.  Bit time = 6680 ns
 
   Message format ==> 1 Start bit and 2 End bits. Parity bit NOT implemented.
    
   Values recieved => 16 bits unsigned integers. Big Endian format.
    
   ## FUNCTIONS 
   
   The user can manually introduce any function he wants (digital or analogic). The master recieves this order through
the switches and buttons from the development board, and then sends it to the slave selected.
   My slave only answers to digital functions. Analogic functions cause an exception.
   
   ## SLAVES
   
   The slave has 4 inputs and 4 outputs. Inputs and outputs are stored in a 1 byte std_logic_vector, so you can add at least 4 more of each with ease. It can answer to the following functions:
   1. Read coils (digital outputs).
   2. Read input (digital input).
   5. Write coil (digital output).
   15. Write several coils (1 or more) (digital output).
   
   ## EXCEPTIONS
   
   Three exception implemented:
   1. Illegal function : In our case, analogic functions (not implemented).
   2. Illegal data address: The address does not exist. It happens when you try to access an input/output that does not exist in the selected slave.
   3. Illegal data value.

## DATA DISPLAY

 BCD_7 from the DE10-Lite shows the slave answer, if it happens, as well as the CRC code (just for testing purposes). It also shows the inputs the user is introducing manually. The user introduces manually the message (address, function....). Once it is done, the switch "start_transmision" must be turned on.
 Slaves' inputs are connected to the switches. Slaves' outputs are connected to the leds on top of the switches.       
