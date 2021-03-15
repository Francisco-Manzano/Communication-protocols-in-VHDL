--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:38:03 09/16/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/CANBUS/CANBUS/CANBUS_TOP_TB.vhd
-- Project Name:  CANBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CANBUS_TOP
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
 
ENTITY CANBUS_TOP_TB IS
END CANBUS_TOP_TB;
 
ARCHITECTURE behavior OF CANBUS_TOP_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CANBUS_TOP
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         TX : OUT  std_logic;
         RX : IN  std_logic;
         ENTRADA1_NODO1 : IN  std_logic;
         ENTRADA2_NODO1 : IN  std_logic;
         ENTRADA1_NODO2 : IN  std_logic;
         ENTRADA2_NODO2 : IN  std_logic;
         SALIDA1_NODO1 : OUT  std_logic;
         SALIDA2_NODO1 : OUT  std_logic;
         SALIDA1_NODO2 : OUT  std_logic;
         SALIDA2_NODO2 : OUT  std_logic;
         ENTRADA_SALIDA : IN  std_logic;
         MAS : IN  std_logic;
         MENOS : IN  std_logic;
         MODIFICAR_SOLICITAR : IN  std_logic;
         ACEPTAR : IN  std_logic;
         BCD_0 : OUT  std_logic_vector(7 downto 0);
         BCD_2 : OUT  std_logic_vector(7 downto 0);
         BCD_4 : OUT  std_logic_vector(7 downto 0);
         BCD_5 : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal RX : std_logic := '0';
   signal ENTRADA1_NODO1 : std_logic := '0';
   signal ENTRADA2_NODO1 : std_logic := '0';
   signal ENTRADA1_NODO2 : std_logic := '0';
   signal ENTRADA2_NODO2 : std_logic := '0';
   signal ENTRADA_SALIDA : std_logic := '0';
   signal MAS : std_logic := '0';
   signal MENOS : std_logic := '0';
   signal MODIFICAR_SOLICITAR : std_logic := '0';
   signal ACEPTAR : std_logic := '0';

 	--Outputs
   signal TX : std_logic;
   signal SALIDA1_NODO1 : std_logic;
   signal SALIDA2_NODO1 : std_logic;
   signal SALIDA1_NODO2 : std_logic;
   signal SALIDA2_NODO2 : std_logic;
   signal BCD_0 : std_logic_vector(7 downto 0);
   signal BCD_2 : std_logic_vector(7 downto 0);
   signal BCD_4 : std_logic_vector(7 downto 0);
   signal BCD_5 : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CANBUS_TOP PORT MAP (
          clk => clk,
          reset => reset,
          TX => TX,
          RX => RX,
          ENTRADA1_NODO1 => ENTRADA1_NODO1,
          ENTRADA2_NODO1 => ENTRADA2_NODO1,
          ENTRADA1_NODO2 => ENTRADA1_NODO2,
          ENTRADA2_NODO2 => ENTRADA2_NODO2,
          SALIDA1_NODO1 => SALIDA1_NODO1,
          SALIDA2_NODO1 => SALIDA2_NODO1,
          SALIDA1_NODO2 => SALIDA1_NODO2,
          SALIDA2_NODO2 => SALIDA2_NODO2,
          ENTRADA_SALIDA => ENTRADA_SALIDA,
          MAS => MAS,
          MENOS => MENOS,
          MODIFICAR_SOLICITAR => MODIFICAR_SOLICITAR,
          ACEPTAR => ACEPTAR,
          BCD_0 => BCD_0,
          BCD_2 => BCD_2,
          BCD_4 => BCD_4,
          BCD_5 => BCD_5
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
		wait for clk_period*2;
		MAS <='1';
		wait for clk_period;
		MODIFICAR_SOLICITAR<='1';
		wait for clk_period*3;
		ACEPTAR<='1';
		wait for 5 us;--60 ns
				
		rx <='0';
		wait for 5 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 5 us;
		rx <='1';
		wait for 4 us;
		rx <='0';
		wait for 5 us;
		rx <='1';
		wait for 3 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 5 us;
		rx <='1';
		wait for 3 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 1 us;
		rx <='0';
		wait for 2 us;
		rx <='1';
		wait for 2 us;
		rx <='0';
		wait for 1 us;
		rx <='1';
		wait for 1 us;
				
		ACEPTAR<='0';	
		wait for 5 us;
		MODIFICAR_SOLICITAR<='0';
		wait for 5 us;	  

      wait;
   end process;

END;
