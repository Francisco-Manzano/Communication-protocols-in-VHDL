--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:36:12 08/24/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/CANBUS/CANBUS/CRC_CAN_TB.vhd
-- Project Name:  CANBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CRC
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY CRC_CAN_TB IS
END CRC_CAN_TB;
 
ARCHITECTURE behavior OF CRC_CAN_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CRC_receptor
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         flag_CRC_calc : in STD_LOGIC; --desde operacion para calcular el crc
		 flag_CRC_recibido: in STD_LOGIC; --flag crc recibido en la transmision
		 nuevo_stream_datos: in STD_LOGIC; --NUEVA TRANSMISION RECIBIDA
		 bit_CRC_in : in STD_LOGIC ; --bit para el calculo del CRC
         flag_CRC_error : out  STD_LOGIC:='0'); --flag de error de CRC
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal flag_CRC_calc: std_logic:='0';
   signal flag_CRC_recibido: std_logic:='0';
   signal nuevo_stream_datos : std_logic:='0';
   signal bit_CRC_in: std_logic :='0'; 

 	--Outputs
   signal flag_CRC_error : std_logic:='0';

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CRC_receptor PORT MAP (
          clk => clk,
          reset => reset,
		  flag_CRC_calc => flag_CRC_calc,
		  flag_CRC_recibido => flag_CRC_recibido,
          nuevo_stream_datos => nuevo_stream_datos,
          bit_CRC_in => bit_CRC_in,
		  flag_CRC_error => flag_CRC_error
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
	  
	  reset <= '1';
	  wait for clk_period*2;
	  reset <='0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 1
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 2
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 3
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 4
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 5
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 6
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 7
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 8
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 9
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 10
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 11
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 12
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 13
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 14
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 15
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 16
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 17
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 18
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 19
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_recibido<='1';  --1
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_recibido <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_recibido<='1';  --2
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_recibido <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_recibido<='1';  --3
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_recibido <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_recibido<='1';  --4
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_recibido <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_recibido<='1';  --5
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_recibido <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_recibido<='1';  --6
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_recibido <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_recibido<='1';  --7
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_recibido <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_recibido<='1';  --8
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_recibido <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_recibido<='1';  --9
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_recibido <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_recibido<='1';  --10
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_recibido <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_recibido<='1';  --11
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_recibido <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_recibido<='1';  --12
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_recibido <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_recibido<='1';  --13
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_recibido <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_recibido<='1';  --14
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_recibido <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_recibido<='1';  --15 
	  bit_CRC_in <='1';--BIT ERRONEO para test de flag
	  wait for clk_period;
	  flag_CRC_recibido <= '0';
	  wait for clk_period*10;
	  
	  
	  nuevo_stream_datos <= '1';
	  
	  wait for clk_period;
	  
	  nuevo_stream_datos <= '0';
	   wait for clk_period;
	  
	  flag_CRC_calc<='1';  --bit 1
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 2
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 3
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 4
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 5
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 6
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 7
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 8
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 9
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 10
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 11
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 12
	  bit_CRC_in <='1';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 13
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 14
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 15
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 16
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 17
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 18
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  flag_CRC_calc<='1';  --bit 19
	  bit_CRC_in <='0';
	  wait for clk_period;
	  flag_CRC_calc <= '0';
	  wait for clk_period*10;
	  
	  
	  
	  wait for 200 us; 
	  reset <= '1';
	  wait for clk_period*10;
	  reset <= '0';

	  


	  

      wait;
   end process;

END;
