----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:38:13 08/10/2020 
-- Design Name: 
-- Module Name:    ESCLAVO_A - Behavioral 
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

entity ESCLAVO_0 is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           ENTRADA1 : in  STD_LOGIC;
           ENTRADA2 : in  STD_LOGIC;
		   esclavo_encendido : in  STD_LOGIC;
           SALIDA1 : out  STD_LOGIC:='0';
           SALIDA2 : out  STD_LOGIC:='0';
           rx_tx : inout  STD_LOGIC);
end ESCLAVO_0;

architecture Behavioral of ESCLAVO_0 is


signal tx_activado,rx_valido : STD_LOGIC;
signal datos_completos: std_logic_vector ( 10 downto 0);
signal datos_a_enviar : std_logic_vector ( 3 downto 0);



COMPONENT unidad_operativa_ESCLAVO_0
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		rx_valido : IN std_logic;
		datos_completos : IN std_logic_vector(10 downto 0);
		ENTRADA1 : IN std_logic;
		ENTRADA2 : IN std_logic; 
		esclavo_encendido : in  STD_LOGIC;			
		tx_activado : OUT std_logic;
		SALIDA1 : OUT std_logic;
		SALIDA2 : OUT std_logic;
		datos_a_enviar : OUT std_logic_vector(3 downto 0)
		);
END COMPONENT;


COMPONENT uart_top_ESCLAVO
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		tx_activado : IN std_logic;
		datos_a_enviar : IN std_logic_vector(3 downto 0);
		esclavo_encendido : IN std_logic;    
		rx_tx : INOUT std_logic;      
		rx_valido : OUT std_logic;
		datos_completos : OUT std_logic_vector(10 downto 0)
		);
END COMPONENT;



begin


Inst_unidad_operativa_ESCLAVO: unidad_operativa_ESCLAVO_0 PORT MAP(
		clk => clk,
		reset => reset,
		rx_valido => rx_valido,
		datos_completos => datos_completos,
		tx_activado => tx_activado,
		ENTRADA1 => ENTRADA1,
		ENTRADA2 => ENTRADA2,
		esclavo_encendido => esclavo_encendido,
		SALIDA1 => SALIDA1,
		SALIDA2 => SALIDA2,
		datos_a_enviar => datos_a_enviar
	);


Inst_uart_top_ESCLAVO: uart_top_ESCLAVO PORT MAP(
		clk => clk,
		reset => reset,
		tx_activado => tx_activado,
		rx_tx => rx_tx,
		datos_a_enviar => datos_a_enviar,
		esclavo_encendido => esclavo_encendido,
		rx_valido => rx_valido,
		datos_completos => datos_completos
	);








end Behavioral;
