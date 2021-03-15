--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:55:46 08/12/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/AS-Interface/MAESTRO_TB.vhd
-- Project Name:  AS-Interface
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MAESTRO
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
 
ENTITY MAESTRO_TB IS
END MAESTRO_TB;
 
ARCHITECTURE behavior OF MAESTRO_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MAESTRO
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         MAS : IN  std_logic;
         MENOS : IN  std_logic;
         VISUALIZAR_ANADIR : IN  std_logic;
         DATOS_PARAMETROS : IN  std_logic;
         OKAY : IN  std_logic;
		 bcd_0,bcd_3,bcd_4,bcd_5: out std_logic_vector(7 downto 0);
         LUZ_MANUAL : OUT  std_logic;
         RX_TX : INOUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal MAS : std_logic := '0';
   signal MENOS : std_logic := '0';
   signal VISUALIZAR_ANADIR : std_logic := '0';
   signal DATOS_PARAMETROS : std_logic := '0';
   signal OKAY : std_logic := '0';

	--BiDirs
   signal RX_TX : std_logic;

 	--Outputs
   signal LUZ_MANUAL : std_logic;
   signal bcd_0 : std_logic_vector(7 downto 0);
   signal bcd_3 : std_logic_vector(7 downto 0);
   signal bcd_4 : std_logic_vector(7 downto 0);
   signal bcd_5 : std_logic_vector(7 downto 0);
   

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MAESTRO PORT MAP (
          clk => clk,
          reset => reset,
          MAS => MAS,
          MENOS => MENOS,
		  bcd_0 => bcd_0,
		  bcd_3 => bcd_3,
		  bcd_4 => bcd_4,
		  bcd_5 => bcd_5,
          VISUALIZAR_ANADIR => VISUALIZAR_ANADIR,
          DATOS_PARAMETROS => DATOS_PARAMETROS,
          OKAY => OKAY,
          LUZ_MANUAL => LUZ_MANUAL,
          RX_TX => RX_TX
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
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  

      wait;
   end process;

END;
