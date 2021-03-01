
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

entity MAESTRO is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           MAS : in  STD_LOGIC;
           MENOS : in  STD_LOGIC;
           VISUALIZAR_ANADIR : in  STD_LOGIC;
           DATOS_PARAMETROS : in  STD_LOGIC;
           OKAY : in  STD_LOGIC;
		   LUZ_MANUAL : out STD_LOGIC;
		   bcd_0,bcd_3,bcd_4,bcd_5: out std_logic_vector(7 downto 0);
           RX_TX : inout  STD_LOGIC);
end MAESTRO;

architecture Behavioral of MAESTRO is


COMPONENT controles
	PORT(
		clk_1_hz : IN std_logic;
		reset : IN std_logic;
		MAS : IN std_logic;
		MENOS : IN std_logic;
		VISUALIZAR_ANADIR : IN std_logic;
		DATOS_PARAMETROS : IN std_logic;
		OKAY : IN std_logic;          
		dato_o_parametro : OUT std_logic;
		dato_o_parametro_manual : OUT std_logic_vector(1 downto 0);
		luz_manual : OUT std_logic;
		senal_para_bcd : OUT std_logic;
		dir_introducida : OUT std_logic_vector(4 downto 0);
		dato_introducido : OUT std_logic_vector(4 downto 0)
		);
END COMPONENT;


COMPONENT relojj_1hz
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;          
		reloj1hz : OUT std_logic
		);
END COMPONENT;


COMPONENT unidad_operativa
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		management : IN std_logic;
		dato_anadido : IN std_logic;
		dir_introducida : IN std_logic_vector(4 downto 0);
		dato_introducido : IN std_logic_vector(4 downto 0);
		dato_o_parametro : IN std_logic;
		esclavo_no_conectado : OUT boolean;
		esclavo_off : IN std_logic_vector(1 downto 0);
		dato_recibido : IN std_logic_vector(3 downto 0);          
		dato_a_mostrar : OUT std_logic_vector(10 downto 0);
		dato_completo : OUT std_logic_vector(10 downto 0);
		tx_inicio : OUT std_logic;
		fase_ciclica_datos : OUT std_logic;
		fase_ciclica_iniciacion : OUT std_logic
		);
END COMPONENT;
	
	
COMPONENT uart_top
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		tx_inicio : IN std_logic;
		datos : IN std_logic_vector(10 downto 0);    
		rx_tx : INOUT std_logic;      
		tx_activo : OUT std_logic;
		tx_fin : OUT std_logic;
		rx_fin : OUT std_logic;
		esclavo_off : OUT std_logic_vector(1 downto 0);
		datos_recibidos : OUT std_logic_vector(3 downto 0)
		);
END COMPONENT;	

COMPONENT BCD_7
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		dato_a_mostrar_operativa : IN std_logic_vector(10 downto 0);
		esclavo_no_conectado : IN boolean;
		senal_desde_controles : IN std_logic;
		dato_desde_controles : IN std_logic_vector(4 downto 0);          
		bcd_0 : OUT std_logic_vector(7 downto 0);
		bcd_3 : OUT std_logic_vector(7 downto 0);
		bcd_4 : OUT std_logic_vector(7 downto 0);
		bcd_5 : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;



signal reloj1hz : STD_LOGIC ;
signal dir_introducida,dato_introducido : std_logic_vector (4 downto 0);
signal dato_o_parametro: STD_LOGIC;
signal dato_o_parametro_manual : std_logic_vector (1 downto 0);
signal senal_para_bcd : STD_LOGIC;    


signal dato_a_mostrar,dato_completo: std_logic_vector ( 10 downto 0);
signal fase_ciclica_datos,fase_ciclica_iniciacion : STD_LOGIC; --TESTBENCH
signal tx_inicio : std_logic;
signal esclavo_off : std_logic_vector ( 1 downto 0);
signal dato_recibido : std_logic_vector ( 3 downto 0);
signal esclavo_no_conectado: boolean;

signal tx_activo,tx_fin,rx_fin: std_logic;

begin


Inst_controles: controles PORT MAP(
		clk_1_hz => reloj1hz,
		reset => reset,
		MAS => MAS,
		MENOS => MENOS,
		VISUALIZAR_ANADIR => VISUALIZAR_ANADIR,
		DATOS_PARAMETROS => DATOS_PARAMETROS,
		OKAY => OKAY,
		dato_o_parametro => dato_o_parametro,
		dato_o_parametro_manual => dato_o_parametro_manual,
		luz_manual => LUZ_MANUAL,
		senal_para_bcd => senal_para_bcd, 
		dir_introducida => dir_introducida,
		dato_introducido => dato_introducido
	);


Inst_relojj_1hz: relojj_1hz PORT MAP(
		clk => clk,
		reset => reset,
		reloj1hz => reloj1hz
	);


Inst_unidad_operativa: unidad_operativa PORT MAP(
		clk => clk,
		reset => reset,
		management => dato_o_parametro_manual(1),
		dato_anadido => dato_o_parametro_manual(0),
		dir_introducida => dir_introducida,
		dato_introducido => dato_introducido,
		dato_o_parametro => dato_o_parametro,
		esclavo_no_conectado => esclavo_no_conectado,
		dato_a_mostrar => dato_a_mostrar,  --ESTO VA AL BCD
		dato_completo => dato_completo, --ESTO VA AL UART TRANSMISOR
		esclavo_off => esclavo_off,  --VIENE DEL UART TRANSMISOR
		tx_inicio => tx_inicio,  --ESTO VA AL UART TRANSMISOR
		fase_ciclica_datos => fase_ciclica_datos,
		fase_ciclica_iniciacion => fase_ciclica_iniciacion,
		dato_recibido => dato_recibido  -- VIENE DEL UART RECEPTOR
	);


Inst_uart_top: uart_top PORT MAP(
		clk => clk,
		reset => reset,
		rx_tx => RX_TX,
		tx_inicio => tx_inicio,
		tx_activo => tx_activo,
		tx_fin => tx_fin,
		rx_fin => rx_fin,
		datos => dato_completo,
		esclavo_off => esclavo_off,
		datos_recibidos => dato_recibido
	);


Inst_BCD_7: BCD_7 PORT MAP(
		clk => clk,
		reset => reset,
		dato_a_mostrar_operativa => dato_a_mostrar,
		esclavo_no_conectado => esclavo_no_conectado,
		senal_desde_controles => senal_para_bcd,
		dato_desde_controles => dato_introducido,
		bcd_0 => bcd_0,
		bcd_3 => bcd_3,
		bcd_4 => bcd_4,
		bcd_5 => bcd_5
	);


end Behavioral;

