--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:17:46 08/13/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/AS-Interface/BCD7_TB.vhd
-- Project Name:  AS-Interface
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: BCD_7
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
 
ENTITY BCD7_TB IS
END BCD7_TB;
 
ARCHITECTURE behavior OF BCD7_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT BCD_7
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         dato_a_mostrar_operativa : IN  std_logic_vector(10 downto 0);
         esclavo_no_conectado : IN  boolean;
         senal_desde_controles : IN  std_logic;
         dato_desde_controles : IN  std_logic_vector(4 downto 0);
         bcd_0 : OUT  std_logic_vector(7 downto 0);
         bcd_3 : OUT  std_logic_vector(7 downto 0);
         bcd_4 : OUT  std_logic_vector(7 downto 0);
         bcd_5 : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal dato_a_mostrar_operativa : std_logic_vector(10 downto 0) := (others => '0');
   signal esclavo_no_conectado : boolean := false;
   signal senal_desde_controles : std_logic := '0';
   signal dato_desde_controles : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal bcd_0 : std_logic_vector(7 downto 0);
   signal bcd_3 : std_logic_vector(7 downto 0);
   signal bcd_4 : std_logic_vector(7 downto 0);
   signal bcd_5 : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: BCD_7 PORT MAP (
          clk => clk,
          reset => reset,
          dato_a_mostrar_operativa => dato_a_mostrar_operativa,
          esclavo_no_conectado => esclavo_no_conectado,
          senal_desde_controles => senal_desde_controles,
          dato_desde_controles => dato_desde_controles,
          bcd_0 => bcd_0,
          bcd_3 => bcd_3,
          bcd_4 => bcd_4,
          bcd_5 => bcd_5
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
		wait for clk_period*2;
		reset <='0';
		wait for clk_period*2;
		dato_a_mostrar_operativa <= "01111101111"; --dir 31 dato F
		dato_desde_controles <= "00011"; --dato 3
		wait for clk_period*10;
		esclavo_no_conectado <= true;
		wait for clk_period*10;
		esclavo_no_conectado <= false;
		wait for clk_period*10;
		esclavo_no_conectado <= true;
		wait for clk_period*10;
		senal_desde_controles <='1';
		wait for clk_period*10;
		senal_desde_controles <='0';
		wait for clk_period*10;
		dato_a_mostrar_operativa <= "01000100111"; --dir 17 dato 7
		wait for clk_period*10;
		dato_a_mostrar_operativa <= "01000110111"; --dir 17 parametro 7
		wait for clk_period*10;
		dato_a_mostrar_operativa <= "00011110101"; --dir 7 parametro 5
		
		
		
		
		
		
		

      wait;
   end process;

END;
