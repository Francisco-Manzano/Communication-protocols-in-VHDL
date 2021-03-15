--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:00:01 11/28/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/AS-I/AS-IN/AS-Interface/receptor_esclavo_TB.vhd
-- Project Name:  AS-Interface
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: receptor_ESCLAVO
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
 
ENTITY receptor_esclavo_TB IS
END receptor_esclavo_TB;
 
ARCHITECTURE behavior OF receptor_esclavo_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT receptor_ESCLAVO
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         esclavo_encendido : IN  std_logic;
         rx : IN  std_logic;
         ticks : IN  std_logic;
         reset_cont_rx : OUT  std_logic;
         rx_fin : OUT  std_logic;
         rx_valido : OUT  std_logic;
         datos_completos : OUT  std_logic_vector(10 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal esclavo_encendido : std_logic := '0';
   signal rx : std_logic := '0';
   signal ticks : std_logic := '0';

 	--Outputs
   signal reset_cont_rx : std_logic;
   signal rx_fin : std_logic;
   signal rx_valido : std_logic;
   signal datos_completos : std_logic_vector(10 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: receptor_ESCLAVO PORT MAP (
          clk => clk,
          reset => reset,
          esclavo_encendido => esclavo_encendido,
          rx => rx,
          ticks => ticks,
          reset_cont_rx => reset_cont_rx,
          rx_fin => rx_fin,
          rx_valido => rx_valido,
          datos_completos => datos_completos
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	ticksss: process
	begin
	
		ticks <='1';
		wait for clk_period;
		ticks <= '0';
		wait for 100 ns;
		
	end process;
	
	
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
	  reset <= '1';
	  wait for clk_period*10;
	  reset <= '0';
	  wait for clk_period*4;
	  esclavo_encendido <= '1';
	  wait for clk_period*4;
	  
	  rx <= '0';
	  wait for 5 us;
	  rx <= '1';
	  wait for 5 us;
	  rx <= '0';
	  wait for 5 us;
	  rx <= '1';
	  wait for 5 us;

      wait;
   end process;

END;
