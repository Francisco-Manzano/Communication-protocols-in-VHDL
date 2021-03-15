--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:17:58 04/19/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/UART/testb.vhd
-- Project Name:  UART
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: uart_top
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
 
ENTITY testb IS
END testb;
 
ARCHITECTURE behavior OF testb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uart_top
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         rx_tx : IN  std_logic;
         tx : OUT  std_logic;
         tx_inicio : IN  std_logic;
         tx_fin : OUT  std_logic;
         datos : IN  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal rx : std_logic := '0';
   signal tx_inicio : std_logic := '0';
   signal datos : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal tx : std_logic;
   signal tx_fin : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns; --50 mhz
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uart_top PORT MAP (
          clk => clk,
          reset => reset,
          rx => rx,
          tx => tx,
          tx_inicio => tx_inicio,
          tx_fin => tx_fin,
          datos => datos
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
		wait for clk_period*3;
			reset <= '0';
			 wait until rising_edge(clk);
			 datos <= X"13A3";
			wait until rising_edge(clk);
			tx_inicio   <= '1';
			
			wait until rising_edge(clk);
			tx_inicio   <= '0';
			wait until tx_fin = '1';
      wait;
   end process;

END;
