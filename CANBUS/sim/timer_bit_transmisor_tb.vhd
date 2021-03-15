--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:49:32 09/05/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/CANBUS/CANBUS/timer_bit_transmisor_tb.vhd
-- Project Name:  CANBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: timer_bit_transmisor
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
 
ENTITY timer_bit_transmisor_tb IS
END timer_bit_transmisor_tb;
 
ARCHITECTURE behavior OF timer_bit_transmisor_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT timer_bit_transmisor
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         timer_inicio_transmisor : IN  std_logic;
         flag_timer_transmisor : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal timer_inicio_transmisor : std_logic := '0';

 	--Outputs
   signal flag_timer_transmisor : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: timer_bit_transmisor PORT MAP (
          clk => clk,
          reset => reset,
          timer_inicio_transmisor => timer_inicio_transmisor,
          flag_timer_transmisor => flag_timer_transmisor
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
	  wait for clk_period;
	  reset <= '0';
	  wait for clk_period*4;
	  timer_inicio_transmisor <='1';
	  wait for clk_period;
	  timer_inicio_transmisor <= '0';
	  

      wait;
   end process;

END;
