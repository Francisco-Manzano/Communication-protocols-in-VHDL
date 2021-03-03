
                          
##                           Classic CAN BUS implementation ==> 2.A STANDARD MESSAGE FORMAT. 
                 
 I decided not to implement the extended format because the 11 ID bits were more than enough to test the protocol. Based on the ISO standard 11898.
 
 Bit time = 1000 ns  ==> Bit rate = 1Mbit/s.
                            
 Overload frame is implemented just for the sake of it (not needed).
 
 Error counters are also implemented.

 ---------------------------------------------------------------------------------------------------------------------------------------------------
 
## CONTROL NODE
  
This node receives orders (send data/remote frame) from the user through the DE10-Lite switches and buttons. Then it sends the message to the rest of the nodes created. If the message is "finished" (no error/arbitration lost), the control node waits for an answer (if it sent a remote frame) or assumes the message has been properly received.

If an answer to a remote frame is received, the control node saves the data and shows it through the BCD_7.

This node can only send data/remote frames and receive data frames. It cannot receive remote frames. I made it this way so it works as a control unit, requesting/sending data to the rest of the nodes (because I needed to implement data/remote frames).

----------------------------------------------------------------------------------------------------------------------------------------------------

## BASIC NODES

They have 2 digital inputs and 2 digital outputs. The data size of these nodes is 1 byte.

Node 1 reacts to IDs 1 and 2. ID 1 is connected to the inputs, so when the node receives a remote frame with ID 1, it sends a data frame with the current value of its inputs. ID 2 is connected to the outputs. This means that when the node receives a data frame with ID 2, it modifies its digital outputs.

Node 2 reacts to IDs 3 and 4. ID 3 is connected to the inputs, so when the node receives a remote frame with ID 3, it sends a data frame with the current value of its inputs. ID 4 is connected to the outputs. This means that when the node receives a data frame with ID 4, it modifies its digital outputs.

---

## DATA DISPLAY

BCD_7 from the DE10-Lite shows the current ID, the type if ID (if it's connected to an input or an output) and the last data received from this ID. Nodes' inputs are connected to switches. Nodes' outputs are connected to the leds on top of the switches. 

---

## PHYSICAL IMPLEMENTATION

![canbus botones](https://user-images.githubusercontent.com/79548135/109698901-30d98180-7b90-11eb-9e2d-739cc50faf82.png)


