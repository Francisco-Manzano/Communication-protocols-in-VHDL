----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:59:50 12/03/2020 
-- Design Name: 
-- Module Name:    MODBUS_SISTEMA_COMPLETO - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
--use IEEE.STD_LOGIC_ARITH.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MODBUS_SISTEMA_COMPLETO is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           rx_maestro : in  STD_LOGIC;
		   LEDS_SIN_USAR: OUT STD_LOGIC_VECTOR(1 DOWNTO 0):=(OTHERS=>'0');
		   rx_esclavo : in  STD_LOGIC;
           tx_maestro : out  STD_LOGIC:='1';
		   tx_esclavo : out  STD_LOGIC:='1';
		   LED_TX_iniciada: out STD_LOGIC;  
		   LED_RX_finalizada : OUT std_logic;
		   LED_RX_RECIBIDO_ESCLAVO: out STD_LOGIC;
		   LED_TX_INICIADA_ESCLAVO: out STD_LOGIC;
		   switch_comando_siguiente : in  STD_LOGIC;
           switch_inicio_transmision: in STD_LOGIC;
		   switch_datos_recibidos: in STD_LOGIC;
           MAS : in  STD_LOGIC;
           MENOS : in  STD_LOGIC;
		   SIGUIENTE_REGISTRO: in STD_LOGIC;
		   LED_CRC: out std_logic:='0';
		    bcd7: out STD_LOGIC_VECTOR (47 downto 0);
           ENTRADA1 : in  STD_LOGIC;
           ENTRADA2 : in  STD_LOGIC;
           ENTRADA3 : in  STD_LOGIC;
           ENTRADA4 : in  STD_LOGIC;
           SALIDA1 : out  STD_LOGIC;
           SALIDA2 : out  STD_LOGIC;
           SALIDA3 : out  STD_LOGIC;
           SALIDA4 : out  STD_LOGIC);
end MODBUS_SISTEMA_COMPLETO;

architecture Behavioral of MODBUS_SISTEMA_COMPLETO is




COMPONENT MODBUS_TOP
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		switch_comando_siguiente : IN std_logic;
		switch_inicio_transmision : IN std_logic;
		switch_datos_recibidos : IN std_logic;
		MAS : IN std_logic;
		MENOS : IN std_logic;
		SIGUIENTE_REGISTRO : IN std_logic;
		rx : IN std_logic;          
		tx : OUT std_logic;
		LED_CRC : OUT std_logic;
		LED_RX_finalizada : OUT std_logic;
		LED_TX_iniciada : OUT std_logic;
		bcd7 : OUT std_logic_vector(47 downto 0)
		);
END COMPONENT;


	COMPONENT ESCLAVO_MODBUS
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		rx : IN std_logic;
		LED_TX_INICIADA_ESCLAVO: out STD_LOGIC;
		LED_RX_RECIBIDO_ESCLAVO: out STD_LOGIC;
		ENTRADA1 : IN std_logic;
		ENTRADA2 : IN std_logic;
		ENTRADA3 : IN std_logic;
		ENTRADA4 : IN std_logic;          
		tx : OUT std_logic;
		SALIDA1 : OUT std_logic;
		SALIDA2 : OUT std_logic;
		SALIDA3 : OUT std_logic;
		SALIDA4 : OUT std_logic
		);
	END COMPONENT;

signal tx_m_rx_e: std_logic;
signal tx_e_rx_m: std_logic;

begin



Inst_MODBUS_TOP: MODBUS_TOP PORT MAP(
		clk => CLK,
		reset => reset,
		switch_comando_siguiente => switch_comando_siguiente,
		switch_inicio_transmision => switch_inicio_transmision,
		switch_datos_recibidos => switch_datos_recibidos,
		MAS => MAS,
		MENOS => MENOS,
		SIGUIENTE_REGISTRO => SIGUIENTE_REGISTRO,
		tx => TX_MAESTRO, --tx_m_rx_e para TB
		LED_CRC => LED_CRC,
		LED_RX_finalizada => LED_RX_finalizada,
		LED_TX_iniciada => LED_TX_iniciada,
		bcd7 => bcd7,
		rx => RX_MAESTRO --tx_e_rx_m para TB
	);



Inst_ESCLAVO_MODBUS: ESCLAVO_MODBUS PORT MAP(
		clk => clk,
		reset => reset,
		rx => RX_ESCLAVO, --tx_m_rx_e para TB
		tx => TX_ESCLAVO, --tx_e_rx_m para TB
		LED_RX_RECIBIDO_ESCLAVO => LED_RX_RECIBIDO_ESCLAVO,
		LED_TX_INICIADA_ESCLAVO =>LED_TX_INICIADA_ESCLAVO,
		ENTRADA1 => ENTRADA1,
		ENTRADA2 => ENTRADA2,
		ENTRADA3 => ENTRADA3,
		ENTRADA4 => ENTRADA4,
		SALIDA1 => SALIDA1,
		SALIDA2 => SALIDA2,
		SALIDA3 => SALIDA3,
		SALIDA4 => SALIDA4
	);
	
	
	
	

end Behavioral;

