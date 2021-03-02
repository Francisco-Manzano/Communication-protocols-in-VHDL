-- Create Date:    17:26:21 05/05/2020 
-- Design Name: 
-- Module Name:    MODBUS_TOP - Behavioral 
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

entity MODBUS_TOP is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           switch_comando_siguiente : in  STD_LOGIC;
           switch_inicio_transmision: in STD_LOGIC;
		   switch_datos_recibidos: in STD_LOGIC;
           MAS : in  STD_LOGIC;
           MENOS : in  STD_LOGIC;
		   SIGUIENTE_REGISTRO: in STD_LOGIC;
           tx : out STD_LOGIC;
		   LED_CRC: out std_logic:='0';
		   LED_RX_finalizada: out STD_LOGIC:='0'; --TEST
		   LED_TX_iniciada: out STD_LOGIC;  --TEST
			  bcd7: out STD_LOGIC_VECTOR (47 downto 0);
           rx : in  STD_LOGIC);
end MODBUS_TOP;

architecture Behavioral of MODBUS_TOP is

COMPONENT recepcion_datos
	PORT(
		clk : IN std_logic;
		clk1hz : IN std_logic;
		reset : IN std_logic;
		MAS : IN std_logic;
		datos_recibidos : IN std_logic_vector(7 downto 0);
		CRC_done : IN std_logic;
		rx_fin : IN std_logic;
		rx_fin_trama : IN std_logic;          
		dato_actual : OUT integer;
		excepcion : OUT std_logic;
		salida_datos : OUT integer
		);
	END COMPONENT;

COMPONENT uart_top
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		rx : IN std_logic;
		tx_inicio : IN std_logic;
		bytes_totales : IN integer;
		datos : IN std_logic_vector(120 downto 0);          
		tx : OUT std_logic;
		tx_activo : OUT std_logic;
		tx_fin : OUT std_logic;
		rx_fin : OUT std_logic;
		datos_recibidos : OUT std_logic_vector(7 downto 0);
		rx_fin_trama : OUT std_logic
		);
	END COMPONENT;


COMPONENT BCD_7
	PORT(
		clk : IN std_logic;
		valor : IN integer;
		CRC_in : in unsigned (15 downto 0);
		registro_actual: IN integer;
		comando_actual : IN std_logic_vector(8 downto 0); 
		excepcion: in STD_LOGIC;
		 salida_datos: in integer;
		 dato_actual : in integer;
		bcd_0 : OUT std_logic_vector(7 downto 0);
		bcd_1 : OUT std_logic_vector(7 downto 0);
		bcd_2 : OUT std_logic_vector(7 downto 0);
		bcd_3 : OUT std_logic_vector(7 downto 0);
		bcd_4 : OUT std_logic_vector(7 downto 0);
		bcd_5 : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;


COMPONENT unidad_operativa
	PORT(
		clk : IN std_logic;
		clk1hz : IN std_logic;
		reset : IN std_logic;
		comando_actual : IN std_logic_vector(8 downto 0);
		SIGUIENTE_REGISTRO: in STD_LOGIC;
		MAS : IN std_logic;
		MENOS : IN std_logic;
		inicio_transmision : in STD_LOGIC;
		CRC_DONE : out STD_LOGIC;
		LED_CRC: out std_logic:='0';
		bytes_totales : out integer:=0;
		CRC_OUT : out unsigned(15 downto 0);
		valor_vector : out std_logic_vector(120 downto 0);
		registro_actual: OUT integer;	
		valor_dec : OUT integer
		);
	END COMPONENT;

COMPONENT unidad_control
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		switch_datos_recibidos_SR: in STD_LOGIC;
		switch_comando_siguiente_SR : IN std_logic;
		switch_inicio_transmision_SR : IN std_logic;          
		comando_actual : OUT std_logic_vector(8 downto 0)
		);
	END COMPONENT;



COMPONENT relojj_1hz
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;          
		reloj1hz : OUT std_logic
		);
	END COMPONENT;



	
signal reloj1hz_int,crc_done_int,tx_fin_int: std_logic;
signal comando_actual : std_logic_vector (8 downto 0);
signal valor_dec_int,registro_actual_int,bytes_totales_int,salida_datos_int,dato_actual_int : integer;	
signal valor_vector_int: std_logic_vector(120 downto 0);
signal CRC_OUT_int: unsigned (15 downto 0);
signal rx_fin_int,rx_fin_trama_int,excepcion_int: std_logic;	
signal datos_recibidos_int: std_logic_vector(7 downto 0);  

begin

LED_RX_finalizada<=rx_fin_trama_int;

Inst_recepcion_datos: recepcion_datos PORT MAP(
		clk => clk,
		clk1hz => reloj1hz_int,
		reset => reset,
		MAS => MAS,
		datos_recibidos => datos_recibidos_int,
		CRC_done => crc_done_int,
		rx_fin => rx_fin_int,
		rx_fin_trama => rx_fin_trama_int,
		dato_actual => dato_actual_int,
		excepcion => excepcion_int,
		salida_datos => salida_datos_int
	);


Inst_uart_top: uart_top PORT MAP(
		clk => clk,
		reset => reset,
		tx => tx,
		rx => rx,
		tx_inicio => crc_done_int,
		tx_activo => LED_TX_iniciada,
		tx_fin => tx_fin_int, --esto era para el tb
		rx_fin => rx_fin_int,
		bytes_totales => bytes_totales_int,
		datos => valor_vector_int,
		datos_recibidos => datos_recibidos_int,
		rx_fin_trama => rx_fin_trama_int
	);

Inst_BCD_7: BCD_7 PORT MAP(
		clk => clk,
		valor => valor_dec_int,
		CRC_in => CRC_OUT_int,
		registro_actual => registro_actual_int,
		comando_actual => comando_actual,
		excepcion=> excepcion_int,
		salida_datos=> salida_datos_int,
		dato_actual=> dato_actual_int,
		bcd_0 => bcd7(7 downto 0),
		bcd_1 => bcd7(15 downto 8),
		bcd_2 => bcd7(23 downto 16),
		bcd_3 => bcd7(31 downto 24),
		bcd_4 => bcd7(39 downto 32),
		bcd_5 => bcd7(47 downto 40)
	);

Inst_unidad_operativa: unidad_operativa PORT MAP(
		clk => clk,
		clk1hz => reloj1hz_int,
		reset => reset,
		comando_actual => comando_actual,
		MAS => MAS,
		MENOS => MENOS,
		inicio_transmision => switch_inicio_transmision,
		CRC_DONE => crc_done_int,
		bytes_totales => bytes_totales_int,
		CRC_OUT => CRC_OUT_int,
		LED_CRC=> LED_CRC,
		valor_vector => valor_vector_int , --ESTO VA AL TRANSMISOR DE LA UART
		SIGUIENTE_REGISTRO => SIGUIENTE_REGISTRO,
		registro_actual => registro_actual_int,
		valor_dec => valor_dec_int
	);

Inst_unidad_control: unidad_control PORT MAP( 
		clk => reloj1hz_int,
		reset => reset,
		switch_datos_recibidos_SR=> switch_datos_recibidos,
		switch_comando_siguiente_SR => switch_comando_siguiente,
		switch_inicio_transmision_SR => switch_inicio_transmision,
		comando_actual => comando_actual
	);

Inst_relojj_1hz: relojj_1hz PORT MAP(
		clk => clk,
		reset => reset,
		reloj1hz => reloj1hz_int
	);


end Behavioral;

