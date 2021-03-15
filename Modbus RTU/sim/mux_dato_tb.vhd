--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:39:51 05/07/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/MODBUS/mux_dato_tb.vhd
-- Project Name:  MODBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mux_dato_dec
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
 
ENTITY mux_dato_tb IS
END mux_dato_tb;
 
ARCHITECTURE behavior OF mux_dato_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mux_dato_dec
    PORT(
         ad_slave : IN  integer;
         funcion : IN  integer;
         ad_dato : IN  integer;
         dato : IN  integer;
         num_dato : IN  integer;
         valor_dato : IN  integer;
         comando_actual : IN  std_logic_vector(8 downto 0);
         salida : OUT  integer
        );
    END COMPONENT;
    

   --Inputs
   signal ad_slave : integer := 5;
   signal funcion : integer := 10;
   signal ad_dato : integer := 15;
   signal dato : integer:= 20;
   signal num_dato : integer := 25;
   signal valor_dato : integer := 30;
   signal comando_actual : std_logic_vector(8 downto 0) := (others => '0');

 	--Outputs
   signal salida :integer;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   --constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mux_dato_dec PORT MAP (
          ad_slave => ad_slave,
          funcion => funcion,
          ad_dato => ad_dato,
          dato => dato,
          num_dato => num_dato,
          valor_dato => valor_dato,
          comando_actual => comando_actual,
          salida => salida
        );

--   -- Clock process definitions
--   <clock>_process :process
--   begin
--		<clock> <= '0';
--		wait for <clock>_period/2;
--		<clock> <= '1';
--		wait for <clock>_period/2;
--   end process;
-- 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

     -- wait for <clock>_period*10;

      -- insert stimulus here 
			comando_actual <="000000001";
			wait for 30 ns;
			comando_actual <="000000010";
			wait for 30 ns;
			comando_actual <="000000100";
			wait for 30 ns;
			comando_actual <="000001000";
			wait for 30 ns;
			comando_actual <="000010000";
			wait for 30 ns;
			comando_actual <="000100000";
			wait for 30 ns;
			comando_actual <="001000000";
			wait for 30 ns;
			comando_actual <="000000001";	
			
      wait;
   end process;

END;
