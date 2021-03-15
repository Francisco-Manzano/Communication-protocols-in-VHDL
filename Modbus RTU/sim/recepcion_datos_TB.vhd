--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:16:50 05/19/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/MODBUS/recepcion_datos_TB.vhd
-- Project Name:  MODBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: recepcion_datos
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
 
ENTITY recepcion_datos_TB IS
END recepcion_datos_TB;
 
ARCHITECTURE behavior OF recepcion_datos_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT recepcion_datos
    PORT(
         clk : IN  std_logic;
         clk1hz : IN  std_logic;
         reset : IN  std_logic;
         MAS : IN  std_logic;
         datos_recibidos : IN  std_logic_vector(7 downto 0);
         CRC_done : IN  std_logic;
         rx_fin : IN  std_logic;
         rx_fin_trama : IN  std_logic;
         excepcion : OUT  std_logic;
         salida_datos : OUT  integer
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal clk1hz : std_logic := '0';
   signal reset : std_logic := '0';
   signal MAS : std_logic := '0';
   signal datos_recibidos : std_logic_vector(7 downto 0) := (others => '0');
   signal CRC_done : std_logic := '0';
   signal rx_fin : std_logic := '0';
   signal rx_fin_trama : std_logic := '0';

 	--Outputs
   signal excepcion : std_logic;
   signal salida_datos : integer;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
   constant clk1hz_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: recepcion_datos PORT MAP (
          clk => clk,
          clk1hz => clk1hz,
          reset => reset,
          MAS => MAS,
          datos_recibidos => datos_recibidos,
          CRC_done => CRC_done,
          rx_fin => rx_fin,
          rx_fin_trama => rx_fin_trama,
          excepcion => excepcion,
          salida_datos => salida_datos
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
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

      wait for clk_period*10;

      -- insert stimulus here 
	    MAS<='1';
		reset<='1';
		wait for clk_period*3;
		reset<='0';
		wait for clk_period*3;
		CRC_done <='1';
		wait for clk_period*3;
		CRC_done <='0';
		wait for clk_period*3;
		datos_recibidos<=X"01";  --ad slave
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"01";  --funcion 1
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"03";  --bytes a seguir
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F1";  -- BYTE 1
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F2";  --BYTE 2
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F3";  --BYTE 3
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"CC";  --CRC BYTE1
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"DD";  --CRC BYTE2
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*2;
		rx_fin_trama<='1';
		wait for clk_period*2;
		rx_fin_trama<='0';
		wait for clk_period*2;
		MAS <='0';
		wait for clk1hz_period*10;
		MAS <='1';                 --PRUEBA 1 VALIDA
		wait for clk_period*2;
		reset <='1';
		wait for clk_period*2;
		reset <='0';             --INICIO PRUEBA 2
		wait for clk_period*3;
		CRC_done <='1';
		wait for clk_period*3;
		CRC_done <='0';
		wait for clk_period*3;
		datos_recibidos<=X"03";  --ad slave
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"02";  --funcion  2
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"05";  --bytes a seguir
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F1";  -- BYTE 1
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F2";  --BYTE 2
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F3";  --BYTE 3
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F4";  --BYTE 4
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F5";  --BYTE 5
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"CC";  --CRC BYTE1
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"DD";  --CRC BYTE2
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*2;
		rx_fin_trama<='1';
		wait for clk_period*2;
		rx_fin_trama<='0';
		wait for clk_period*2;
		MAS <='0';
		wait for clk1hz_period*10;
		MAS <='1';                 --PRUEBA 2 VALIDA
		wait for clk_period*2;
		reset <='1';
		wait for clk_period*2;
		reset <='1';
		wait for clk_period*2;
		reset <='0';
		wait for clk_period*3;
		CRC_done <='1';
		wait for clk_period*3;
		CRC_done <='0';
		wait for clk_period*3;
		datos_recibidos<=X"03";  --ad slave
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"03";  --funcion  3
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"06";  --bytes a seguir
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F1";  -- BYTE 1
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F2";  --BYTE 2
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F3";  --BYTE 3
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F4";  --BYTE 4
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F5";  --BYTE 5
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F6";  --BYTE 6
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"CC";  --CRC BYTE1
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"DD";  --CRC BYTE2
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*2;
		rx_fin_trama<='1';
		wait for clk_period*2;
		rx_fin_trama<='0';
		wait for clk_period*2;
		MAS <='0';
		wait for clk1hz_period*10;
		MAS <='1';                 -- PRUEBA 3 VALIDA
		wait for clk_period*2;
		reset <='1';
		wait for clk_period*2;
		reset <='0';
		wait for clk_period*3;
		CRC_done <='1';
		wait for clk_period*3;
		CRC_done <='0';
		wait for clk_period*3;
		datos_recibidos<=X"03";  --ad slave
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"04";  --funcion  4
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"06";  --bytes a seguir
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F1";  -- BYTE 1
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F2";  --BYTE 2
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F3";  --BYTE 3
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F4";  --BYTE 4
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F5";  --BYTE 5
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F6";  --BYTE 6
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"CC";  --CRC BYTE1
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"DD";  --CRC BYTE2
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*2;
		rx_fin_trama<='1';
		wait for clk_period*2;
		rx_fin_trama<='0';
		wait for clk_period*2;
		MAS <='0';
		wait for clk1hz_period*10;
		MAS <='1';                 -- PRUEBA 3 VALIDA
		wait for clk_period*2;
		reset <='1';
		wait for clk_period*2;
		reset <='0';
		wait for clk_period*3;
		CRC_done <='1';
		wait for clk_period*3;
		CRC_done <='0';
		wait for clk_period*3;
		datos_recibidos<=X"03";  --ad slave
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"83";  --funcion  5
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"06";  --bytes a seguir
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F1";  -- BYTE 1
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F2";  --BYTE 2
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F3";  --BYTE 3
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F4";  --BYTE 4
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F5";  --BYTE 5
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"F6";  --BYTE 6
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"CC";  --CRC BYTE1
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*3;
		datos_recibidos<=X"DD";  --CRC BYTE2
		wait for clk_period*3;
		rx_fin<='1';
		wait for clk_period*1;
		rx_fin<='0';
		wait for clk_period*2;
		rx_fin_trama<='1';
		wait for clk_period*2;
		rx_fin_trama<='0';
		wait for clk_period*2;
		MAS <='0';
		wait for clk1hz_period*10;
		MAS <='1';                 -- PRUEBA 3 VALIDA
		wait for clk_period*2;
		reset <='1';
		wait for clk_period*2;
		reset <='1';
		wait for clk_period*2;
		reset <='0';
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

      wait;
   end process;

END;
