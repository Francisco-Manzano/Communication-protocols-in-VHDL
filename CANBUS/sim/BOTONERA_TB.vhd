--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:27:51 09/13/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/CANBUS/CANBUS/BOTONERA_TB.vhd
-- Project Name:  CANBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: BOTONERA
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
 
ENTITY BOTONERA_TB IS
END BOTONERA_TB;
 
ARCHITECTURE behavior OF BOTONERA_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT BOTONERA
    PORT(
         clk1hz : IN  std_logic;
         reset : IN  std_logic;
         ENTRADA_SALIDA : IN  std_logic;
         MODIFICAR_SOLICITAR : IN  std_logic;
         ACEPTAR : IN  std_logic;
         MAS : IN  std_logic;
         MENOS : IN  std_logic;
         visualizar_modificar : OUT  std_logic;
         mostrar_entrada_salida : OUT  std_logic;
         ID_A_ENVIAR : OUT  std_logic_vector(10 downto 0);
         RTR_A_ENVIAR : OUT  std_logic;
         introduccion_finalizada : OUT  std_logic;
         SALIDA_INTRODUCIDA : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk1hz : std_logic := '0';
   signal reset : std_logic := '0';
   signal ENTRADA_SALIDA : std_logic := '0';
   signal MODIFICAR_SOLICITAR : std_logic := '0';
   signal ACEPTAR : std_logic := '0';
   signal MAS : std_logic := '0';
   signal MENOS : std_logic := '0';

 	--Outputs
   signal visualizar_modificar : std_logic;
   signal mostrar_entrada_salida : std_logic;
   signal ID_A_ENVIAR : std_logic_vector(10 downto 0);
   signal RTR_A_ENVIAR : std_logic;
   signal introduccion_finalizada : std_logic;
   signal SALIDA_INTRODUCIDA : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk1hz_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: BOTONERA PORT MAP (
          clk1hz => clk1hz,
          reset => reset,
          ENTRADA_SALIDA => ENTRADA_SALIDA,
          MODIFICAR_SOLICITAR => MODIFICAR_SOLICITAR,
          ACEPTAR => ACEPTAR,
          MAS => MAS,
          MENOS => MENOS,
          visualizar_modificar => visualizar_modificar,
          mostrar_entrada_salida => mostrar_entrada_salida,
          ID_A_ENVIAR => ID_A_ENVIAR,
          RTR_A_ENVIAR => RTR_A_ENVIAR,
          introduccion_finalizada => introduccion_finalizada,
          SALIDA_INTRODUCIDA => SALIDA_INTRODUCIDA
        );

   -- Clock process definitions
   clk1hz_process :process
   begin
		clk1hz <= '0';
		wait for clk1hz_period/2;
		clk1hz <= '1';
		wait for clk1hz_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk1hz_period*10;

      -- insert stimulus here 
	  
	  MAS <='1';
	  MENOS <='1';
	  reset <= '1';
	  wait for clk1hz_period;
	  reset <='0';
	  wait for clk1hz_period*10;
	  MAS <= '0';
	  wait for clk1hz_period*4;
	  MAS <='1';
	  wait for clk1hz_period*2;
	  MENOS <='0';
	  wait for clk1hz_period*5;
	  MENOS <='1';
	  wait for clk1hz_period*2;
	  MAS <='0';
	  wait for clk1hz_period*3;
	  MAS <='1';
	  
	  ENTRADA_SALIDA<='1';
	  wait for clk1hz_period*5;
	  ENTRADA_SALIDA<='0';
	  wait for clk1hz_period*2;
	  wait for clk1hz_period*2;
	  ENTRADA_SALIDA<='1';
	  wait for clk1hz_period*2;
	  MODIFICAR_SOLICITAR<='1';
	  wait for clk1hz_period*5;
	  MAS <='0';
	  wait for clk1hz_period*4;
	  MAS <='1';
	  wait for clk1hz_period*2;
	  ACEPTAR <='1';
	  wait for clk1hz_period*2;
	  ACEPTAR<='0';
	  wait for clk1hz_period*2;
	  wait for clk1hz_period*2;
	  MODIFICAR_SOLICITAR<='0';
	  wait for clk1hz_period*2;
	  ENTRADA_SALIDA<='0';
	  wait for clk1hz_period*2;
	  MAS <= '0';
	  wait for clk1hz_period*4;
	  MAS <='1';
	  MODIFICAR_SOLICITAR<='1'; 
	  wait for clk1hz_period*5;
	   MAS <='0';
	  wait for clk1hz_period*4;
	  MAS <='1';
	  wait for clk1hz_period*5;
	  ACEPTAR <='1';
	  wait for clk1hz_period*2;
	  ACEPTAR<='0';
	  wait for clk1hz_period*2;
	  MODIFICAR_SOLICITAR<='0';
	  wait for clk1hz_period*2;
	  
	  
	  
	  
	  
	  
	  
	   

      wait;
   end process;

END;
