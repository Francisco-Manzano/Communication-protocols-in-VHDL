----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:39:25 05/06/2020 
-- Design Name: 
-- Module Name:    unidad_operativa - Behavioral 
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

entity unidad_operativa is
    Port ( clk : in  STD_LOGIC;
			  clk1hz: in STD_LOGIC;
           reset : in  STD_LOGIC;
           comando_actual : in  STD_LOGIC_VECTOR (8 downto 0);
		   SIGUIENTE_REGISTRO: in STD_LOGIC;
           MAS : in  STD_LOGIC;
           MENOS : in  STD_LOGIC;
		   inicio_transmision : in STD_LOGIC;
		   CRC_DONE : out STD_LOGIC;  
		   bytes_totales : out integer:=0; --BYTES a transmitir por la uart tx
		   LED_CRC: out std_logic:='0';
		   CRC_OUT : out unsigned(15 downto 0); -- valor del CRC para el BCD
		   valor_vector : out std_logic_vector(120 downto 0); --trama a enviar para la uart tx
		   registro_actual: OUT integer;
           valor_dec : out integer); --valores de los comandos para el BCD
end unidad_operativa;

architecture Behavioral of unidad_operativa is


COMPONENT CRC
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		inicio_transmision : IN std_logic;
		dato : IN integer;
		numero_datos : IN integer;
		registro_actual : IN integer;
		comando_actual : IN std_logic_vector(8 downto 0);
		CRC_out : out unsigned(15 downto 0);
		bytes_totales : out integer:=0;
		funcion : IN integer;
		LED_CRC: out std_logic:='0';		
		flag_crcdone : OUT std_logic;
		trama_out : OUT std_logic_vector(120 downto 0)
		);
	END COMPONENT;

COMPONENT valor_datos_6
	PORT(
		reset : IN std_logic;
		E : IN std_logic;
		clk : IN std_logic;
		MENOS : IN std_logic;
		MAS : IN std_logic;
		SIGUIENTE_REGISTRO: IN std_logic;
		funcion : IN integer;
		numero_datos : IN integer; 
		registro_actual: out integer;		
		valor_dec : OUT integer
		);
	END COMPONENT;



COMPONENT mux_dato_dec
	PORT(
		ad_slave : IN integer;
		funcion : IN integer;
		ad_dato : IN integer;
		dato : IN integer;
		num_dato : IN integer;
		valor_dato : IN integer;
		comando_actual : IN std_logic_vector(8 downto 0);          
		salida : OUT integer
		);
	END COMPONENT;
	
COMPONENT numero_datos
	PORT(
		reset : IN std_logic;
		E : IN std_logic;
		clk : IN std_logic;
		funcion : IN integer;
		dato : IN integer;          
		valor_dec : OUT integer
		);
	END COMPONENT;
	
COMPONENT dato_contador
	PORT(
		reset : IN std_logic;
		E : IN std_logic;
		clk : IN std_logic;
		funcion : IN integer;
		MENOS : IN std_logic;
		MAS : IN std_logic;          
		valor_dec : OUT integer
		);
	END COMPONENT;
	
	
COMPONENT contador_hex
	PORT(
		reset : IN std_logic;
		E : IN std_logic;
		clk : IN std_logic;
		MENOS : IN std_logic;
		MAS : IN std_logic;          
		valor_dec : OUT integer
		);
	END COMPONENT;

signal ad_slave_int,funcion_int,ad_dato_int,dato_int,num_dato_int,valor_dato_int,registro_actual_int,valor_dec_int : integer:=0;
--signal : std_logic:= '0';

begin

registro_actual <= registro_actual_int;
valor_dec <= valor_dec_int;


Inst_CRC: CRC PORT MAP(
		clk => clk,
		reset => reset,
		inicio_transmision => inicio_transmision,
		dato => valor_dec_int,
		numero_datos => num_dato_int,
		registro_actual => registro_actual_int,
		flag_crcdone => CRC_DONE,
		CRC_out => CRC_OUT,
		LED_CRC=>LED_CRC,
		bytes_totales => bytes_totales,
		trama_out => valor_vector,
		comando_actual => comando_actual,
		funcion => funcion_int
	);

Inst_mux_dato_dec: mux_dato_dec PORT MAP(
		ad_slave => ad_slave_int,
		funcion => funcion_int,
		ad_dato => ad_dato_int,
		dato => dato_int,
		num_dato => num_dato_int,
		valor_dato => valor_dato_int,
		comando_actual => comando_actual,
		salida => valor_dec_int
	);


ad_slave_1: contador_hex PORT MAP(
		reset => reset,
		E => comando_actual(0),
		clk => clk1hz,
		valor_dec => ad_slave_int,
		MENOS => MENOS,
		MAS => MAS
	);
	

funcion_2: contador_hex PORT MAP(
		reset => reset,
		E => comando_actual(1),
		clk => clk1hz,
		valor_dec => funcion_int,
		MENOS => MENOS,
		MAS => MAS
	);

	
ad_dato_3: contador_hex PORT MAP(
		reset => reset,
		E => comando_actual(2),
		clk => clk1hz,
		valor_dec => ad_dato_int,
		MENOS => MENOS,
		MAS => MAS
	);


inst_dato_contador_4: dato_contador PORT MAP(
		reset => reset,
		E => comando_actual(3),
		clk => clk1hz,
		funcion => funcion_int,
		valor_dec => dato_int,
		MENOS => MENOS,
		MAS => MAS
	);

	
numero_datos_5: numero_datos PORT MAP(
		reset => reset,
		E => comando_actual(4),
		clk => clk1hz,
		funcion => funcion_int,
		dato => dato_int,
		valor_dec => num_dato_int
	);

	
Inst_valor_datos_6: valor_datos_6 PORT MAP(
		reset => reset,
		E => comando_actual(5),
		clk => clk1hz,
		MENOS => MENOS,
		MAS => MAS,
	    SIGUIENTE_REGISTRO => SIGUIENTE_REGISTRO,
		funcion => funcion_int,
		numero_datos => num_dato_int,
		registro_actual => registro_actual_int,
		valor_dec => valor_dato_int
	);
	


end Behavioral;



