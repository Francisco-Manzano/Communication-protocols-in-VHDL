--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:02:34 11/26/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/CANBUS/CANBUS/bit_error_TB.vhd
-- Project Name:  CANBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: BIT_ERROR
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
 
ENTITY bit_error_TB IS
END bit_error_TB;
 
ARCHITECTURE behavior OF bit_error_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT BIT_ERROR
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         flag_BIT_error : OUT  std_logic;
         bit_recibido : IN  std_logic;
         bit_enviado : IN  std_logic;
         flag_bit_recibido : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal bit_recibido : std_logic := '0';
   signal bit_enviado : std_logic := '0';
   signal flag_bit_recibido : std_logic := '0';

 	--Outputs
   signal flag_BIT_error : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: BIT_ERROR PORT MAP (
          clk => clk,
          reset => reset,
          flag_BIT_error => flag_BIT_error,
          bit_recibido => bit_recibido,
          bit_enviado => bit_enviado,
          flag_bit_recibido => flag_bit_recibido
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
	  
	  reset<='1';
	  wait for clk_period*10;
	  reset<='0';
	  wait for clk_period*2;
	  bit_recibido <='1';
	  bit_enviado <='1';
	  wait for clk_period*2;
	  flag_bit_recibido<='1';
	  wait for clk_period;
	  flag_bit_recibido<='0';
	  wait for clk_period*10;
	  bit_enviado <='0';
	  wait for clk_period*1;
	  flag_bit_recibido<='1';
	  wait for clk_period*4;
	  flag_bit_recibido<='0';
	  bit_enviado <='1';
	  wait for clk_period*50;
	  flag_bit_recibido<='1';
	  wait for clk_period;
	  flag_bit_recibido<='0';
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  

      wait;
   end process;

END;
