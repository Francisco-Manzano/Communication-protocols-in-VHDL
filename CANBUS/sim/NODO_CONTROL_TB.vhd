--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:52:36 09/14/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/CANBUS/CANBUS/NODO_CONTROL_TB.vhd
-- Project Name:  CANBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: NODO_CONTROL
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
 
ENTITY NODO_CONTROL_TB IS
END NODO_CONTROL_TB;
 
ARCHITECTURE behavior OF NODO_CONTROL_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT NODO_CONTROL
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         rx : IN  std_logic;
         tx : OUT  std_logic;
         ENTRADA_SALIDA : IN  std_logic;
         MAS : IN  std_logic;
         MENOS : IN  std_logic;
         MODIFICAR_SOLICITAR : IN  std_logic;
         ACEPTAR : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal rx : std_logic := '0';
   signal ENTRADA_SALIDA : std_logic := '0';
   signal MAS : std_logic := '0';
   signal MENOS : std_logic := '0';
   signal MODIFICAR_SOLICITAR : std_logic := '0';
   signal ACEPTAR : std_logic := '0';

 	--Outputs
   signal tx : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: NODO_CONTROL PORT MAP (
          clk => clk,
          reset => reset,
          rx => rx,
          tx => tx,
          ENTRADA_SALIDA => ENTRADA_SALIDA,
          MAS => MAS,
          MENOS => MENOS,
          MODIFICAR_SOLICITAR => MODIFICAR_SOLICITAR,
          ACEPTAR => ACEPTAR
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
	  
		MAS <='1';
		MENOS <='1';
		reset<='1';
		rx <='1';
		wait for clk_period*5;
		reset<='0';
		
		
		
		wait for clk_period; --TRAMA REMOTA PARA PEDIR ENTRADAS
		MAS <='0';
		wait for clk_period;
		MAS <='1';
		wait for clk_period;
		MODIFICAR_SOLICITAR<='1';
		wait for clk_period*3;
		ACEPTAR<='1';
		wait for 60 ns;--60 ns
				
		rx <='0';
		wait for 5 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 5 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 2 us;
		rx <='0';
		wait for 5 us;
		rx <='1';
		wait for 2 us;
		rx <='0';
		wait for 2 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 3 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 2 us;
		rx <='1';
		wait for 5 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 5 us;
				
		ACEPTAR<='0';	
		wait for 5 us;
		MODIFICAR_SOLICITAR<='0';
		wait for 5 us;
		
		
		
		
		rx <='0';  --RECIBIENDO TRAMA DE DATOS
		wait for 5 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 5 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 5 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 5 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 2 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 3 us;
		rx <='0';
		wait for 2 us;
		rx <='1';
		wait for 2 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 2 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 2 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 2 us;
		
		

		WAIT FOR 40 US;

		ENTRADA_SALIDA<='1'; --TRAMA DE DATOS PARA MODIFICAR LAS SALIDAS DE LOS NODOS
		wait for 5 us;
		MAS <='0';
		wait for clk_period*1;
		MAS <='1';
		wait for clk_period*1;
		MODIFICAR_SOLICITAR<='1';
		wait for clk_period*1;
		MAS <='0';
		wait for clk_period*3;
		MAS <='1';
		wait for clk_period*3;
		ACEPTAR <='1';
		wait for 60 ns;
				
		rx <='0';
		wait for 5 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 4 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 5 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 3 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 5 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 4 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 2 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 2 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 1 us;
		
		ACEPTAR<='0';	
		wait for 30 us;
		MODIFICAR_SOLICITAR<='0';
		wait for 40 us;

      wait;
   end process;

END;
