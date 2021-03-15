--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:26:03 11/28/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/AS-I/AS-IN/AS-Interface/baudios_TB.vhd
-- Project Name:  AS-Interface
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: generador_baudios_esclavo
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
 
ENTITY baudios_TB IS
END baudios_TB;
 
ARCHITECTURE behavior OF baudios_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT generador_baudios_esclavo
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         reset_cont : IN  std_logic;
         ticks : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal reset_cont : std_logic := '0';

 	--Outputs
   signal ticks : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: generador_baudios_esclavo PORT MAP (
          clk => clk,
          reset => reset,
          reset_cont => reset_cont,
          ticks => ticks
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

      wait for clk_period*20;

      -- insert stimulus here 

      wait;
   end process;

END;
