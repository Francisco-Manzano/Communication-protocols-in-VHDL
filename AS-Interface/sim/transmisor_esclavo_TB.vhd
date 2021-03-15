--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:27:54 11/28/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/AS-I/AS-IN/AS-Interface/transmisor_esclavo_TB.vhd
-- Project Name:  AS-Interface
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: transmisor_ESCLAVO
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
 
ENTITY transmisor_esclavo_TB IS
END transmisor_esclavo_TB;
 
ARCHITECTURE behavior OF transmisor_esclavo_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT transmisor_ESCLAVO
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         ticks : IN  std_logic;
         tx_activado : IN  std_logic;
         tx_activo : OUT  std_logic;
         reset_cont_tx : OUT  std_logic;
         tx : OUT  std_logic;
         tx_fin : OUT  std_logic;
         datos_a_enviar : IN  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal ticks : std_logic := '0';
   signal tx_activado : std_logic := '0';
   signal datos_a_enviar : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal tx_activo : std_logic;
   signal reset_cont_tx : std_logic;
   signal tx : std_logic;
   signal tx_fin : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: transmisor_ESCLAVO PORT MAP (
          clk => clk,
          reset => reset,
          ticks => ticks,
          tx_activado => tx_activado,
          tx_activo => tx_activo,
          reset_cont_tx => reset_cont_tx,
          tx => tx,
          tx_fin => tx_fin,
          datos_a_enviar => datos_a_enviar
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	tickssss: process
	begin
		ticks <= '1';
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
	  
		datos_a_enviar <= "1010";
		wait for clk_period*10;
		tx_activado <= '1';
		

      wait;
   end process;

END;
