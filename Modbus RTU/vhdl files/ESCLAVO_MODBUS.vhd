----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:43:41 12/02/2020 
-- Design Name: 
-- Module Name:    ESCLAVO_MODBUS - Behavioral 
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

entity ESCLAVO_MODBUS is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           rx : in  STD_LOGIC;
           tx : out  STD_LOGIC;
		   LED_RX_RECIBIDO_ESCLAVO: out STD_LOGIC;
		   LED_TX_INICIADA_ESCLAVO: out STD_LOGIC;
           ENTRADA1 : in  STD_LOGIC;
           ENTRADA2 : in  STD_LOGIC;
           ENTRADA3 : in  STD_LOGIC;
           ENTRADA4 : in  STD_LOGIC;
           SALIDA1 : out  STD_LOGIC;
           SALIDA2 : out  STD_LOGIC;
           SALIDA3 : out  STD_LOGIC;
           SALIDA4 : out  STD_LOGIC);
end ESCLAVO_MODBUS;

architecture Behavioral of ESCLAVO_MODBUS is


signal datos_recibidos: STD_LOGIC_VECTOR(7 downto 0);
signal tx_inicio,flag_fin_recepcion,flag_byte_recibido: std_logic;
signal datos_completos: STD_LOGIC_VECTOR (120 downto 0);
signal bytes_a_enviar,numerobytes_recibidos: integer;

COMPONENT operaciones_ESCLAVO
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		numerobytes_recibidos : IN integer;
		datos_recibidos : IN std_logic_vector(7 downto 0);
		flag_byte_recibido : IN std_logic;
		flag_fin_recepcion : IN std_logic;
		ENTRADA1 : IN std_logic;
		ENTRADA2 : IN std_logic;
		ENTRADA3 : IN std_logic;
		ENTRADA4 : IN std_logic;          
		tx_inicio : OUT std_logic;
		SALIDA1 : OUT std_logic;
		SALIDA2 : OUT std_logic;
		SALIDA3 : OUT std_logic;
		SALIDA4 : OUT std_logic;
		datos_completos : OUT std_logic_vector(120 downto 0);
		bytes_a_enviar : OUT integer
		);
END COMPONENT;


COMPONENT UART_ESCLAVO
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		datos_completos : IN std_logic_vector(120 downto 0);
		bytes_a_enviar : IN integer;
		LED_RX_RECIBIDO_ESCLAVO: out STD_LOGIC;
		tx_inicio : IN std_logic;
		rx : IN std_logic;      
		LED_TX_INICIADA_ESCLAVO: out STD_LOGIC;		
		datos_recibidos : OUT std_logic_vector(7 downto 0);
		flag_fin_recepcion : OUT std_logic;
		flag_byte_recibido : OUT std_logic;
		numerobytes_recibidos : OUT integer;
		tx : OUT std_logic
		);
END COMPONENT;


begin


Inst_operaciones_ESCLAVO: operaciones_ESCLAVO PORT MAP(
		clk => clk,
		reset => reset,
		numerobytes_recibidos => numerobytes_recibidos,
		datos_recibidos => datos_recibidos,
		flag_byte_recibido => flag_byte_recibido,
		flag_fin_recepcion => flag_fin_recepcion,
		tx_inicio => tx_inicio,
		SALIDA1 => SALIDA1,
		SALIDA2 => SALIDA2,
		SALIDA3 => SALIDA3,
		SALIDA4 => SALIDA4,
		ENTRADA1 => ENTRADA1,
		ENTRADA2 => ENTRADA2,
		ENTRADA3 => ENTRADA3,
		ENTRADA4 => ENTRADA4,
		datos_completos => datos_completos,
		bytes_a_enviar => bytes_a_enviar
	);


Inst_UART_ESCLAVO: UART_ESCLAVO PORT MAP(
		clk => clk,
		reset => reset,
		datos_completos => datos_completos,
		datos_recibidos => datos_recibidos,
		bytes_a_enviar => bytes_a_enviar,
		tx_inicio => tx_inicio,
		LED_TX_INICIADA_ESCLAVO => LED_TX_INICIADA_ESCLAVO,
		LED_RX_RECIBIDO_ESCLAVO => LED_RX_RECIBIDO_ESCLAVO,
		flag_fin_recepcion => flag_fin_recepcion,
		flag_byte_recibido => flag_byte_recibido,
		numerobytes_recibidos => numerobytes_recibidos,
		rx => rx,
		tx => tx
	);






end Behavioral;

