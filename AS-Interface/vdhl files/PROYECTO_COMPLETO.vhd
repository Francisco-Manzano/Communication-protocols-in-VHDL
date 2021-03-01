----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:01:16 08/12/2020 
-- Design Name: 
-- Module Name:    PROYECTO_COMPLETO - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PROYECTO_COMPLETO is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           MAS : in  STD_LOGIC;
           MENOS : in  STD_LOGIC;
           VISUALIZAR_ANADIR : in  STD_LOGIC;
           DATOS_PARAMETROS : in  STD_LOGIC;
           OKAY : in  STD_LOGIC;
		   ESCLAVO_ENCENDIDO_A: in STD_LOGIC;
		   ESCLAVO_ENCENDIDO_B: in STD_LOGIC;
		   ESCLAVO_ENCENDIDO_0: in STD_LOGIC;
		   LEDS_SIN_USAR: STD_LOGIC_VECTOR(2 downto 0):=(others=>'0');
		   bcd_0 : out std_logic_vector(7 downto 0);
		   bcd_3 : out std_logic_vector(7 downto 0);
		   bcd_4 : out std_logic_vector(7 downto 0);
		   bcd_5 : out std_logic_vector(7 downto 0);
           LUZ_MANUAL : out  STD_LOGIC;
           ENTRADA1_A : in  STD_LOGIC;
           ENTRADA2_A : in  STD_LOGIC;
           ENTRADA1_B : in  STD_LOGIC;
           ENTRADA2_B : in  STD_LOGIC;
           ENTRADA1_0 : in  STD_LOGIC;
           ENTRADA2_0 : in  STD_LOGIC;
           SALIDA1_A : out  STD_LOGIC;
           SALIDA2_A : out  STD_LOGIC;
           SALIDA1_B : out  STD_LOGIC;
           SALIDA2_B : out  STD_LOGIC;
           SALIDA1_0 : out  STD_LOGIC;
           SALIDA2_0 : out  STD_LOGIC);
end PROYECTO_COMPLETO;

architecture Behavioral of PROYECTO_COMPLETO is

signal rx_tx: std_logic;


COMPONENT ESCLAVO_A
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		ENTRADA1 : IN std_logic;
		ENTRADA2 : IN std_logic;
		esclavo_encendido : IN std_logic;    
		rx_tx : INOUT std_logic;      
		SALIDA1 : OUT std_logic;
		SALIDA2 : OUT std_logic
		);
END COMPONENT;

COMPONENT ESCLAVO_B
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		ENTRADA1 : IN std_logic;
		ENTRADA2 : IN std_logic;
		esclavo_encendido : IN std_logic;    
		rx_tx : INOUT std_logic;      
		SALIDA1 : OUT std_logic;
		SALIDA2 : OUT std_logic
		);
END COMPONENT;


COMPONENT ESCLAVO_0
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		ENTRADA1 : IN std_logic;
		ENTRADA2 : IN std_logic;
		esclavo_encendido : IN std_logic;    
		rx_tx : INOUT std_logic;      
		SALIDA1 : OUT std_logic;
		SALIDA2 : OUT std_logic
		);
END COMPONENT;


COMPONENT MAESTRO
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		MAS : IN std_logic;
		MENOS : IN std_logic;
		VISUALIZAR_ANADIR : IN std_logic;
		DATOS_PARAMETROS : IN std_logic;
		OKAY : IN std_logic;    
		RX_TX : INOUT std_logic; 
		bcd_0,bcd_3,bcd_4,bcd_5: out std_logic_vector(7 downto 0);	
		LUZ_MANUAL : OUT std_logic	
		);
END COMPONENT;

begin


Inst_ESCLAVO_A: ESCLAVO_A PORT MAP(
		clk => clk,
		reset => reset,
		ENTRADA1 => ENTRADA1_A,
		ENTRADA2 => ENTRADA2_A,
		esclavo_encendido => ESCLAVO_ENCENDIDO_A,
		SALIDA1 => SALIDA1_A,
		SALIDA2 => SALIDA2_A,
		rx_tx => rx_tx
	);
	
	
Inst_ESCLAVO_B: ESCLAVO_B PORT MAP(
		clk => clk,
		reset => reset,
		ENTRADA1 => ENTRADA1_B,
		ENTRADA2 => ENTRADA2_B,
		esclavo_encendido => ESCLAVO_ENCENDIDO_B,
		SALIDA1 => SALIDA1_B,
		SALIDA2 => SALIDA2_B,
		rx_tx => rx_tx
	);

Inst_ESCLAVO_0: ESCLAVO_0 PORT MAP(
		clk => clk,
		reset => reset,
		ENTRADA1 => ENTRADA1_0,
		ENTRADA2 => ENTRADA2_0,
		esclavo_encendido => ESCLAVO_ENCENDIDO_0,
		SALIDA1 => SALIDA1_0,
		SALIDA2 => SALIDA2_0,
		rx_tx => rx_tx
	);		


Inst_MAESTRO: MAESTRO PORT MAP(
		clk => clk,
		reset => reset,
		MAS => MAS,
		MENOS => MENOS,
		VISUALIZAR_ANADIR => VISUALIZAR_ANADIR,
		DATOS_PARAMETROS => DATOS_PARAMETROS,
		OKAY => OKAY,
		bcd_0 => bcd_0,
		bcd_3 => bcd_3,
		bcd_4 => bcd_4,
		bcd_5 => bcd_5,
		LUZ_MANUAL => LUZ_MANUAL,
		RX_TX => rx_tx
	);




end Behavioral;

