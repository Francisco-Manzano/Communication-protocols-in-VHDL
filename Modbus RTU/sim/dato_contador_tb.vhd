--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:28:07 05/07/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/MODBUS/dato_contador_tb.vhd
-- Project Name:  MODBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: dato_contador
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
 
ENTITY dato_contador_tb IS
END dato_contador_tb;
 
ARCHITECTURE behavior OF dato_contador_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT dato_contador
    PORT(
         reset : IN  std_logic;
         E : IN  std_logic;
         clk : IN  std_logic;
         funcion : IN  integer;
         valor_dec : OUT  integer;
         MENOS : IN  std_logic;
         MAS : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';
   signal E : std_logic := '0';
   signal clk : std_logic := '0';
   signal funcion : integer := 0;
   signal MENOS : std_logic := '0';
   signal MAS : std_logic := '0';

 	--Outputs
   signal valor_dec : integer;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: dato_contador PORT MAP (
          reset => reset,
          E => E,
          clk => clk,
          funcion => funcion,
          valor_dec => valor_dec,
          MENOS => MENOS,
          MAS => MAS
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
			wait for clk_period*4;
			reset <= '0';
			wait for clk_period*4;
			E <= '1';
			wait for clk_period*4;
			MAS <= '1';
			wait for clk_period*10;
			MAS <= '0';
			wait for clk_period*4;
			menos <= '1';
			wait for clk_period*15;
			menos <= '0';
			wait for clk_period*4;
			MAS <= '1';
			wait for clk_period*20;
			funcion <= 5;
			wait for clk_period*4;
			mas <= '0';
			wait for clk_period*4;
			menos <= '1';
			wait for clk_period*4;
			menos <= '0';
			wait for clk_period*4;
			reset <= '1';
			wait for clk_period*4;
			reset <= '0';
			wait for clk_period*4;
			funcion <= 0;
			wait for clk_period*4;
			mas<= '1';
			wait for clk_period*4;



      wait;
   end process;

END;
