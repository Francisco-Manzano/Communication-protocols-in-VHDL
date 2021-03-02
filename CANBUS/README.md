
                          
                            This is a classic CAN BUS implementation ==> 2.A STANDARD MESSAGE FORMAT. 
                 
 I decided not to implement the extended format because the 11 ID bits were more than enough to test the protocol. Based on the ISO standard 11898.
 
 Bit time = 1000 ns  ==> Bit rate = 1Mbit/s.
                            
 Overload frame is implemented just for the sake of it (not needed).
 
 Error counters are also implemented.

 ---------------------------------------------------------------------------------------------------------------------------------------------------
 
CONTROL NODE
  
This node receives orders from the user through the DE10-Lite switches and buttons. Then it sends the message to the rest of the nodes created. If the message is "finished" (no error/arbitration lost), the control node waits for an answer (if it sent a remote frame) or assumes the message has been properly received.

If an answer to a remote frame is received, the control node saves the data and shows it through the BCD_7.

This node can only send data/remote frames and receive data frames. It cannot receive remote frames. I made it this way so it works as a control unit, requesting/sending data to the rest of the nodes (because i needed to implement data/remote frames).

----------------------------------------------------------------------------------------------------------------------------------------------------

BASIC NODES

