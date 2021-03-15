--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:13:54 09/04/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/CANBUS/CANBUS/stuff_error_TB.vhd
-- Project Name:  CANBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: STUFF_ERROR
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
 
ENTITY stuff_error_TB IS
END stuff_error_TB;
 
ARCHITECTURE behavior OF stuff_error_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT STUFF_ERROR
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
		  inicio_anticipado: in STD_LOGIC;
         inicio_recepcion : IN  std_logic;
         flag_bit_recibido : IN  std_logic;
         bit_recibido : IN  std_logic;
         flag_stuff_error : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal inicio_recepcion : std_logic := '0';
   signal flag_bit_recibido : std_logic := '0';
   signal inicio_anticipado: std_logic := '0';
   signal bit_recibido : std_logic := '0';

 	--Outputs
   signal flag_stuff_error : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: STUFF_ERROR PORT MAP (
          clk => clk,
          reset => reset,
          inicio_recepcion => inicio_recepcion,
		  inicio_anticipado  => inicio_anticipado,
          flag_bit_recibido => flag_bit_recibido,
          bit_recibido => bit_recibido,
          flag_stuff_error => flag_stuff_error
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
	  
		reset<='1';
	    wait for clk_period*10;  --1
		reset<= '0';
		bit_recibido<='1';
		flag_bit_recibido<='1';
		wait for clk_period*1;
		flag_bit_recibido<='0';
		wait for clk_period*5;
		
		flag_bit_recibido<='1'; --2
		wait for clk_period*1;
		flag_bit_recibido<='0';
		wait for clk_period*5;
		
		flag_bit_recibido<='1';--3
		wait for clk_period*1;
		flag_bit_recibido<='0';
		wait for clk_period*5;
		
		flag_bit_recibido<='1';--4
		wait for clk_period*1;
		flag_bit_recibido<='0';
		wait for clk_period*5;
		
		flag_bit_recibido<='1';--5
		wait for clk_period*1;
		flag_bit_recibido<='0';
		wait for clk_period*5;
		
		flag_bit_recibido<='1';--6
		wait for clk_period*1;
		flag_bit_recibido<='0';
		wait for clk_period*5;
		
		wait for 5 us;
		
		inicio_recepcion <= '1';
		wait for clk_period;
		inicio_recepcion <= '0';
		
		bit_recibido <='0';
		
		
		flag_bit_recibido<='1'; 
		wait for clk_period*1;
		flag_bit_recibido<='0';
		wait for clk_period*5;
		
		
		flag_bit_recibido<='1'; 
		wait for clk_period*1;
		flag_bit_recibido<='0';
		wait for clk_period*5;
		
		
		flag_bit_recibido<='1'; 
		wait for clk_period*1;
		flag_bit_recibido<='0';
		wait for clk_period*5;
		
		bit_recibido <='1';
		
		
		flag_bit_recibido<='1'; 
		wait for clk_period*1;
		flag_bit_recibido<='0';
		wait for clk_period*5;
		
		
		flag_bit_recibido<='1'; 
		wait for clk_period*1;
		flag_bit_recibido<='0';
		wait for clk_period*5;
		
		
		flag_bit_recibido<='1'; 
		wait for clk_period*1;
		flag_bit_recibido<='0';
		wait for clk_period*5;
		
		
		flag_bit_recibido<='1';
		wait for clk_period*1;
		flag_bit_recibido<='0';
		wait for clk_period*5;
		
		bit_recibido <='0';
		
		
		flag_bit_recibido<='1'; 
		wait for clk_period*1;
		flag_bit_recibido<='0';
		wait for clk_period*5;
		
		
		flag_bit_recibido<='1'; 
		wait for clk_period*1;
		flag_bit_recibido<='0';
		wait for clk_period*5;
		
		
		flag_bit_recibido<='1'; 
		wait for clk_period*1;
		flag_bit_recibido<='0';
		wait for clk_period*5;
		
		
		flag_bit_recibido<='1'; 
		wait for clk_period*1;
		flag_bit_recibido<='0';
		wait for clk_period*5;
		
		
		flag_bit_recibido<='1'; 
		wait for clk_period*1;
		flag_bit_recibido<='0';
		wait for clk_period*5;
		
		
		flag_bit_recibido<='1'; 
		wait for clk_period*1;
		flag_bit_recibido<='0';
		wait for clk_period*5;


		

      -- insert stimulus here 

      wait;
   end process;

END;
