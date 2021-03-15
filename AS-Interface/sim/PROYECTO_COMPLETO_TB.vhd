--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:46:55 08/12/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/AS-Interface/PROYECTO_COMPLETO_TB.vhd
-- Project Name:  AS-Interface
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PROYECTO_COMPLETO
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
 
ENTITY PROYECTO_COMPLETO_TB IS
END PROYECTO_COMPLETO_TB;
 
ARCHITECTURE behavior OF PROYECTO_COMPLETO_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PROYECTO_COMPLETO
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         MAS : IN  std_logic;
         MENOS : IN  std_logic;
         VISUALIZAR_ANADIR : IN  std_logic;
         DATOS_PARAMETROS : IN  std_logic;
         OKAY : IN  std_logic;
         ESCLAVO_ENCENDIDO_A : IN  std_logic;
         ESCLAVO_ENCENDIDO_B : IN  std_logic;
         ESCLAVO_ENCENDIDO_0 : IN  std_logic;
		 bcd_0 : out std_logic_vector(7 downto 0);
		 bcd_3 : out std_logic_vector(7 downto 0);
		 bcd_4 : out std_logic_vector(7 downto 0);
		 bcd_5 : out std_logic_vector(7 downto 0);
         LUZ_MANUAL : OUT  std_logic;
         ENTRADA1_A : IN  std_logic;
         ENTRADA2_A : IN  std_logic;
         ENTRADA1_B : IN  std_logic;
         ENTRADA2_B : IN  std_logic;
         ENTRADA1_0 : IN  std_logic;
         ENTRADA2_0 : IN  std_logic;
         SALIDA1_A : OUT  std_logic;
         SALIDA2_A : OUT  std_logic;
         SALIDA1_B : OUT  std_logic;
         SALIDA2_B : OUT  std_logic;
         SALIDA1_0 : OUT  std_logic;
         SALIDA2_0 : OUT  std_logic
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
   signal ESCLAVO_ENCENDIDO_A : std_logic := '0';
   signal ESCLAVO_ENCENDIDO_B : std_logic := '0';
   signal ESCLAVO_ENCENDIDO_0 : std_logic := '0';
   signal ENTRADA1_A : std_logic := '0';
   signal ENTRADA2_A : std_logic := '0';
   signal ENTRADA1_B : std_logic := '0';
   signal ENTRADA2_B : std_logic := '0';
   signal ENTRADA1_0 : std_logic := '0';
   signal ENTRADA2_0 : std_logic := '0';

 	--Outputs
   signal LUZ_MANUAL : std_logic;
   signal bcd_0 : std_logic_vector(7 downto 0);
   signal bcd_3 : std_logic_vector(7 downto 0);
   signal bcd_4 : std_logic_vector(7 downto 0);
   signal bcd_5 : std_logic_vector(7 downto 0);
   signal SALIDA1_A : std_logic;
   signal SALIDA2_A : std_logic;
   signal SALIDA1_B : std_logic;
   signal SALIDA2_B : std_logic;
   signal SALIDA1_0 : std_logic;
   signal SALIDA2_0 : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PROYECTO_COMPLETO PORT MAP (
          clk => clk,
          reset => reset,
          MAS => MAS,
          MENOS => MENOS,
          VISUALIZAR_ANADIR => VISUALIZAR_ANADIR,
          DATOS_PARAMETROS => DATOS_PARAMETROS,
          OKAY => OKAY,
          ESCLAVO_ENCENDIDO_A => ESCLAVO_ENCENDIDO_A,
          ESCLAVO_ENCENDIDO_B => ESCLAVO_ENCENDIDO_B,
          ESCLAVO_ENCENDIDO_0 => ESCLAVO_ENCENDIDO_0,
		  bcd_0 => bcd_0,
		  bcd_3 => bcd_3,
		  bcd_4 => bcd_4,
		  bcd_5 => bcd_5,
          LUZ_MANUAL => LUZ_MANUAL,
          ENTRADA1_A => ENTRADA1_A,
          ENTRADA2_A => ENTRADA2_A,
          ENTRADA1_B => ENTRADA1_B,
          ENTRADA2_B => ENTRADA2_B,
          ENTRADA1_0 => ENTRADA1_0,
          ENTRADA2_0 => ENTRADA2_0,
          SALIDA1_A => SALIDA1_A,
          SALIDA2_A => SALIDA2_A,
          SALIDA1_B => SALIDA1_B,
          SALIDA2_B => SALIDA2_B,
          SALIDA1_0 => SALIDA1_0,
          SALIDA2_0 => SALIDA2_0
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
	  
	  
	  ESCLAVO_ENCENDIDO_B <= '1';
	  
	  reset <= '1';
	  wait for clk_period*2;
	  MAS <='1';
	  wait for clk_period*2;
	  MENOS <='1';
	  wait for clk_period*2;
	  reset <= '0';
	  wait for 10 ms;
	  ESCLAVO_ENCENDIDO_A <= '1';
	  wait for 10 ms;
	  ENTRADA1_A <='1';
	  wait for 10 ms;
	  ENTRADA1_B <='1';
	  wait for 10 ms;
	  ENTRADA2_B <='1';
	  wait for 10 ms;
	  ENTRADA2_A <='1';
	  wait for 10 ms;
	  ENTRADA1_B <='0';
	  wait for 10 ms;
	  ENTRADA1_A <='0';
	  wait for 10 ms;
	  MAS <='0';
	  wait for clk_period*2;
	  MAS <='1';
	  wait for clk_period*2;
	  VISUALIZAR_ANADIR <= '1';
	  wait for clk_period;
	  MAS <='0';
	  wait for clk_period*2;
	  MAS <='1';
	  wait for clk_period*2;
	  OKAY <='1';
	  wait for 5 us;
	  OKAY <='0';
	  wait for 10 us;
	  VISUALIZAR_ANADIR <= '0';
	  wait for 10 us;
	  
	  
	  
	  ESCLAVO_ENCENDIDO_A <= '0';
	  wait for 10 ms;
	   ESCLAVO_ENCENDIDO_0 <= '1';
	  wait for 10 ms;
	  ENTRADA1_0 <='1';	  
	  wait for 10 ms;
	  ENTRADA2_0 <='1';	  	  
	   wait for 10 ms;
	   
	   
	   
	   wait for clk_period*2;
	   VISUALIZAR_ANADIR <= '1';
	   wait for clk_period*2;
	   MAS <='0';
	   wait for clk_period*6;
	   MAS <='1';
	    wait for clk_period*3;
		OKAY <='1';
		wait for 5 us;
		OKAY <='0';
		wait for clk_period*3;
		VISUALIZAR_ANADIR <= '0';
		
		wait for 10 ms;
	   
	   wait for clk_period*2;
	   VISUALIZAR_ANADIR <= '1';
	   wait for clk_period*5;
	   MAS <='0';
	   wait for clk_period*9;
	   MAS <='1';
	    wait for clk_period*3;
		OKAY <='1';
		wait for 5 us;
		OKAY <='0';
		wait for clk_period*3;
		VISUALIZAR_ANADIR <= '0';
		
		wait for 10 ms;
	   
	   wait for clk_period*2;
	   DATOS_PARAMETROS <= '1';
	   wait for clk_period*5;
	   VISUALIZAR_ANADIR <= '1';
	   wait for clk_period*5;
	   MAS <='0';
	   wait for clk_period*9;
	   MAS <='1';
	    wait for clk_period*3;
		OKAY <='1';
		wait for 10 ms;
		OKAY <='0';
		wait for clk_period*3;
		VISUALIZAR_ANADIR <= '0';
		
	   
	   
	   
	   
	   
	  
	  
	 
	  

      wait;
   end process;

END;
