--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:06:31 12/02/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/MODBUSS/MODBUS/CRC_TRANSMISOR_ESCLAVO_TB.vhd
-- Project Name:  MODBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CRC_TRANSMISOR_ESCLAVO
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
 
ENTITY CRC_TRANSMISOR_ESCLAVO_TB IS
END CRC_TRANSMISOR_ESCLAVO_TB;
 
ARCHITECTURE behavior OF CRC_TRANSMISOR_ESCLAVO_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CRC_TRANSMISOR_ESCLAVO
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         datos : IN  std_logic_vector(120 downto 0);
         datos_out : OUT  std_logic_vector(120 downto 0);
         flag_CRC_transmisor : IN  std_logic;
         bytes_CRC_transmisor : IN  integer;
         bytes_totales_mensaje : OUT  integer;
         tx_inicio : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal datos : std_logic_vector(120 downto 0) := (others => '0');
   signal flag_CRC_transmisor : std_logic := '0';
   signal bytes_CRC_transmisor : integer:=0;

 	--Outputs
   signal datos_out : std_logic_vector(120 downto 0);
   signal bytes_totales_mensaje : integer;
   signal tx_inicio : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CRC_TRANSMISOR_ESCLAVO PORT MAP (
          clk => clk,
          reset => reset,
          datos => datos,
          datos_out => datos_out,
          flag_CRC_transmisor => flag_CRC_transmisor,
          bytes_CRC_transmisor => bytes_CRC_transmisor,
          bytes_totales_mensaje => bytes_totales_mensaje,
          tx_inicio => tx_inicio
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
	  
		reset <= '1';
		wait for clk_period;
		reset <= '0';
		
		datos <=(others=>'0');
		datos(7 downto 0) <= X"80";
		datos(15 downto 8) <=X"40";
		datos(23 downto 16) <= X"80";
		datos(31 downto 24) <=X"03";
		
		
		 wait for clk_period*10;
		 
		 bytes_CRC_transmisor<= 4;
		 wait for clk_period*10;
		 
		 flag_CRC_transmisor <= '1';
		 wait for clk_period;
		 flag_CRC_transmisor <= '0';
		 
		

      -- insert stimulus here 

      wait;
   end process;

END;
