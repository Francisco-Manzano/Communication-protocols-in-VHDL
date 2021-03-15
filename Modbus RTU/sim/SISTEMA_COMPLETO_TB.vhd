--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:46:24 12/03/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/MODBUSS/MODBUS/SISTEMA_COMPLETO_TB.vhd
-- Project Name:  MODBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MODBUS_SISTEMA_COMPLETO
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
 
ENTITY SISTEMA_COMPLETO_TB IS
END SISTEMA_COMPLETO_TB;
 
ARCHITECTURE behavior OF SISTEMA_COMPLETO_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MODBUS_SISTEMA_COMPLETO
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
		 LEDS_SIN_USAR: OUT STD_LOGIC_VECTOR(1 DOWNTO 0):=(OTHERS=>'0');
		 rx_maestro : in  STD_LOGIC;
		 rx_esclavo : in  STD_LOGIC;
         tx_maestro : out  STD_LOGIC:='1';
		 tx_esclavo : out  STD_LOGIC:='1';
		 LED_TX_iniciada: out STD_LOGIC;  
		 LED_RX_finalizada : OUT std_logic;
		 LED_RX_RECIBIDO_ESCLAVO: out STD_LOGIC;
		 LED_TX_INICIADA_ESCLAVO: out STD_LOGIC;
         switch_comando_siguiente : IN  std_logic;
         switch_inicio_transmision : IN  std_logic;
         switch_datos_recibidos : IN  std_logic;
         MAS : IN  std_logic;
         MENOS : IN  std_logic;
         SIGUIENTE_REGISTRO : IN  std_logic;
         LED_CRC : OUT  std_logic;
         bcd7 : OUT  std_logic_vector(47 downto 0);
         ENTRADA1 : IN  std_logic;
         ENTRADA2 : IN  std_logic;
         ENTRADA3 : IN  std_logic;
         ENTRADA4 : IN  std_logic;
         SALIDA1 : OUT  std_logic;
         SALIDA2 : OUT  std_logic;
         SALIDA3 : OUT  std_logic;
         SALIDA4 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
  
   signal rx_esclavo: std_logic:='0';
   signal rx_maestro: std_logic:='0';
   signal switch_comando_siguiente : std_logic := '0';
   signal switch_inicio_transmision : std_logic := '0';
   signal switch_datos_recibidos : std_logic := '0';
   signal MAS : std_logic := '0';
   signal MENOS : std_logic := '0';
   signal SIGUIENTE_REGISTRO : std_logic := '0';
   signal ENTRADA1 : std_logic := '0';
   signal ENTRADA2 : std_logic := '0';
   signal ENTRADA3 : std_logic := '0';
   signal ENTRADA4 : std_logic := '0';

 	--Outputs
 
   signal LED_CRC : std_logic;
   signal tx_esclavo:std_logic;
   signal tx_maestro: std_logic;
   signal LED_TX_iniciada: std_logic;
   signal LED_RX_finalizada: std_logic;
   signal LED_RX_RECIBIDO_ESCLAVO: std_logic;
   signal LED_TX_INICIADA_ESCLAVO: std_logic;
   signal LEDS_SIN_USAR: STD_LOGIC_VECTOR(1 downto 0);
   signal bcd7 : std_logic_vector(47 downto 0);
   signal SALIDA1 : std_logic;
   signal SALIDA2 : std_logic;
   signal SALIDA3 : std_logic;
   signal SALIDA4 : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MODBUS_SISTEMA_COMPLETO PORT MAP (
          clk => clk,
          reset => reset,
		  tx_esclavo => tx_esclavo,
		  tx_maestro => tx_maestro,
		  LED_TX_iniciada => LED_TX_iniciada,
		  LED_RX_finalizada => LED_RX_finalizada,
		  LED_RX_RECIBIDO_ESCLAVO => LED_RX_RECIBIDO_ESCLAVO,
		  LED_TX_INICIADA_ESCLAVO => LED_TX_INICIADA_ESCLAVO,
		  LEDS_SIN_USAR => LEDS_SIN_USAR,
		  rx_esclavo => rx_esclavo,
		  rx_maestro => rx_maestro,
          switch_comando_siguiente => switch_comando_siguiente,
          switch_inicio_transmision => switch_inicio_transmision,
          switch_datos_recibidos => switch_datos_recibidos,
          MAS => MAS,
          MENOS => MENOS,
          SIGUIENTE_REGISTRO => SIGUIENTE_REGISTRO,
          LED_CRC => LED_CRC,
          bcd7 => bcd7,
          ENTRADA1 => ENTRADA1,
          ENTRADA2 => ENTRADA2,
          ENTRADA3 => ENTRADA3,
          ENTRADA4 => ENTRADA4,
          SALIDA1 => SALIDA1,
          SALIDA2 => SALIDA2,
          SALIDA3 => SALIDA3,
          SALIDA4 => SALIDA4
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
		MAS <= '1';
		MENOS <= '1';
      wait for clk_period*10;

      -- insert stimulus here 
	  
	  reset <= '1';
	  wait for clk_period*20;
	  reset <='0';
	  
	  wait for 1 us;
	  
	  switch_comando_siguiente<='1';
	   wait for clk_period;
	  switch_comando_siguiente<='0'; 
	  wait for clk_period*2;
	  
	  MAS <= '0';
	  wait for clk_period;
	  MAS <= '1';
	   wait for clk_period*4;
	   
	   switch_comando_siguiente<='1';
	   wait for clk_period;
	  switch_comando_siguiente<='0'; 
	  wait for clk_period*4;
	  
	   MAS <= '0';
	  wait for clk_period*15;
	  MAS <= '1';
	   wait for clk_period*4;
	   
	    switch_comando_siguiente<='1';
	   wait for clk_period;
	  switch_comando_siguiente<='0'; 
	  wait for clk_period*4;
	  
	  
	   MAS <= '0';
	  wait for clk_period;
	  MAS <= '1';
	   wait for clk_period*4;
	   
	    switch_comando_siguiente<='1';
	   wait for clk_period;
	  switch_comando_siguiente<='0'; 
	  wait for clk_period*4;
	  
	   MAS <= '0';
	  wait for clk_period*4;
	  MAS <= '1';
	   wait for clk_period*4;
	   
	    
	    switch_comando_siguiente<='1';
	   wait for clk_period;
	  switch_comando_siguiente<='0'; 
	  wait for clk_period*4;
	  
	   MAS <= '0';
	  wait for clk_period;
	  MAS <= '1';
	   wait for clk_period*4;
	   
	    
	    switch_comando_siguiente<='1';
	   wait for clk_period;
	  switch_comando_siguiente<='0'; 
	  wait for clk_period*4;
	  
	   MAS <= '0';
	  wait for clk_period*15;
	  MAS <= '1';
	   wait for clk_period*4;
	   
	   
	   
	   wait for 10 us;
	  
	  switch_inicio_transmision <= '1';
	  wait for 15 ms;
	   switch_inicio_transmision <= '0';
	   
	   
		
      wait;
   end process;

END;
