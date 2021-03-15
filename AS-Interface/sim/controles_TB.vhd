--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:42:52 08/09/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/AS-Interface/controles_TB.vhd
-- Project Name:  AS-Interface
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: controles
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
 
ENTITY controles_TB IS
END controles_TB;
 
ARCHITECTURE behavior OF controles_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT controles
    PORT(
         clk_1_hz : IN  std_logic;
         reset : IN  std_logic;
         MAS : IN  std_logic;
         MENOS : IN  std_logic;
         VISUALIZAR_ANADIR : IN  std_logic;
         DATOS_PARAMETROS : IN  std_logic;
         OKAY : IN  std_logic;
         dato_o_parametro : OUT  std_logic;
         dato_o_parametro_manual : OUT  std_logic_vector(1 downto 0);
         luz_manual : OUT  std_logic;
         senal_para_bcd : OUT  std_logic;
         dir_introducida : OUT  std_logic_vector(4 downto 0);
         dato_introducido : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_1_hz : std_logic := '0';
   signal reset : std_logic := '0';
   signal MAS : std_logic := '0';
   signal MENOS : std_logic := '0';
   signal VISUALIZAR_ANADIR : std_logic := '0';
   signal DATOS_PARAMETROS : std_logic := '0';
   signal OKAY : std_logic := '0';

 	--Outputs
   signal dato_o_parametro : std_logic;
   signal dato_o_parametro_manual : std_logic_vector(1 downto 0);
   signal luz_manual : std_logic;
   signal senal_para_bcd : std_logic;
   signal dir_introducida : std_logic_vector(4 downto 0);
   signal dato_introducido : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant clk_1_hz_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: controles PORT MAP (
          clk_1_hz => clk_1_hz,
          reset => reset,
          MAS => MAS,
          MENOS => MENOS,
          VISUALIZAR_ANADIR => VISUALIZAR_ANADIR,
          DATOS_PARAMETROS => DATOS_PARAMETROS,
          OKAY => OKAY,
          dato_o_parametro => dato_o_parametro,
          dato_o_parametro_manual => dato_o_parametro_manual,
          luz_manual => luz_manual,
          senal_para_bcd => senal_para_bcd,
          dir_introducida => dir_introducida,
          dato_introducido => dato_introducido
        );

   -- Clock process definitions
   clk_1_hz_process :process
   begin
		clk_1_hz <= '0';
		wait for clk_1_hz_period/2;
		clk_1_hz <= '1';
		wait for clk_1_hz_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_1_hz_period*10;

      -- insert stimulus here 
	  
				 MAS <= '1';
				 MENOS <= '1';
				 reset <= '1';
				 wait for clk_1_hz_period*2;
				 reset <= '0';
				 wait for clk_1_hz_period*10;
				 reset <= '0';
				 MAS <= '0';
				 wait for clk_1_hz_period*5;
				 MAS <= '1';
				 wait for clk_1_hz_period*1;
				 MENOS <='0';
				 wait for clk_1_hz_period*2;
				 MENOS <= '1';
				 wait for clk_1_hz_period*2;
				 DATOS_PARAMETROS <='1';   --mostrar parametros
				 wait for clk_1_hz_period*2;
				 MAS <= '0';
				 wait for clk_1_hz_period*2;
				 MAS <= '1';
				 wait for clk_1_hz_period*1;
				 MENOS <='0';
				 wait for clk_1_hz_period*10;
				 MENOS <= '1';
				 wait for clk_1_hz_period*2;
				 MAS <= '0';
				 wait for clk_1_hz_period*15;
				 MAS <= '1';
				 wait for clk_1_hz_period*1;
				 DATOS_PARAMETROS <='0';    --mostrar datos
				 wait for clk_1_hz_period*2;
				 DATOS_PARAMETROS <='1';    --mostrar parametros
				 wait for clk_1_hz_period*2;
				 VISUALIZAR_ANADIR <= '1';   --introd_parametro
				 wait for clk_1_hz_period*2;
				 MAS <= '0';
				 wait for clk_1_hz_period*17;
				 MAS <= '1';
				 wait for clk_1_hz_period*2;
				 MENOS <='0';
				 wait for clk_1_hz_period*20;
				 MENOS <= '1';
				 wait for clk_1_hz_period*2;
				 VISUALIZAR_ANADIR <= '0';   --mostrar parametros
				 wait for clk_1_hz_period*2;
				 VISUALIZAR_ANADIR <= '1';   --introd_parametro
				  wait for clk_1_hz_period*2;
				 MAS <= '0';
				 wait for clk_1_hz_period*5;
				 MAS <= '1';
				 wait for clk_1_hz_period*2;
				 OKAY <= '1';      			 --introd_parametro2
				 wait for clk_1_hz_period*5;
				 VISUALIZAR_ANADIR <= '0';  --mostrar parametro
				 wait for clk_1_hz_period*2;
				 OKAY <= '0';      			 
				 wait for clk_1_hz_period*5;
				 DATOS_PARAMETROS <='0';   --mostrar datos
				 wait for clk_1_hz_period*2;
				 MAS <= '0';
				 wait for clk_1_hz_period*3;
				 MAS <= '1';
				 wait for clk_1_hz_period*2;
				 MENOS <='0';
				 wait for clk_1_hz_period*4;
				 MENOS <= '1';
				 wait for clk_1_hz_period*2;
				 VISUALIZAR_ANADIR <= '1'; --introd datos
				 wait for clk_1_hz_period*2;
				 MAS <= '0';
				 wait for clk_1_hz_period*3;
				 MAS <= '1';
				 wait for clk_1_hz_period*2;
				 VISUALIZAR_ANADIR <= '0'; --mostrar datos
				 wait for clk_1_hz_period*2;
				 MENOS <='0';
				 wait for clk_1_hz_period*2;
				 MENOS <= '1';
				 Wait for clk_1_hz_period*2;
				 VISUALIZAR_ANADIR <= '1'; --introd datos
				 MAS <= '0';
				 wait for clk_1_hz_period*3;
				 MAS <= '1';
				 wait for clk_1_hz_period*2;
				 OKAY <= '1';               --introd datos2
				 Wait for clk_1_hz_period*2;
				 VISUALIZAR_ANADIR <= '0'; --mostrar datos
				 wait for clk_1_hz_period*2;
				 OKAY <= '0'; 
				 
				 wait for 10 us;
				 
				 reset <= '1';
				 wait for clk_1_hz_period*2;
				 reset <= '0'; 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				 
				

      wait;
   end process;

END;
