----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:22:59 09/15/2020 
-- Design Name: 
-- Module Name:    CANBUS_TOP - Behavioral 
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

entity CANBUS_TOP is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           TX : OUT  STD_LOGIC;
           RX : in  STD_LOGIC;
		   LEDS_SIN_USAR: OUT  STD_LOGIC_VECTOR(4 downto 0):=(others=>'0');
           ENTRADA1_NODO1 : in  STD_LOGIC;
           ENTRADA2_NODO1 : in  STD_LOGIC;
           ENTRADA1_NODO2 : in  STD_LOGIC;
           ENTRADA2_NODO2 : in  STD_LOGIC;
           SALIDA1_NODO1 : out  STD_LOGIC;
           SALIDA2_NODO1 : out  STD_LOGIC;
           SALIDA1_NODO2 : out  STD_LOGIC;
           SALIDA2_NODO2 : out  STD_LOGIC;
           ENTRADA_SALIDA : in  STD_LOGIC;
           MAS : in  STD_LOGIC;
           MENOS : in  STD_LOGIC;
		   indicador_errorr:out STD_LOGIC;
		   MODIFICAR_SOLICITAR : in  STD_LOGIC;
		   ERROR_OUT: out STD_LOGIC;
           ACEPTAR : in  STD_LOGIC;
           BCD_0 : out  STD_LOGIC_VECTOR (7 downto 0);
           BCD_2 : out  STD_LOGIC_VECTOR (7 downto 0);
           BCD_4 : out  STD_LOGIC_VECTOR (7 downto 0);
           BCD_5 : out  STD_LOGIC_VECTOR (7 downto 0)
           );
end CANBUS_TOP;




architecture Behavioral of CANBUS_TOP is


COMPONENT NODO_1_TOP
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		rx : IN std_logic;
		ENTRADA1 : IN std_logic;
		ENTRADA2 : IN std_logic;          
		tx : OUT std_logic;
		SALIDA1 : OUT std_logic;
		SALIDA2 : OUT std_logic
		);
END COMPONENT;


COMPONENT NODO_2_TOP
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		rx : IN std_logic;
		ENTRADA1 : IN std_logic;
		ENTRADA2 : IN std_logic;          
		tx : OUT std_logic;
		SALIDA1 : OUT std_logic;
		SALIDA2 : OUT std_logic
		);
END COMPONENT;


COMPONENT NODO_CONTROL
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		rx : IN std_logic;
		ENTRADA_SALIDA : IN std_logic;
		MAS : IN std_logic;
		MENOS : IN std_logic;
		indicador_errorr:out STD_LOGIC;
		MODIFICAR_SOLICITAR : IN std_logic;
		ACEPTAR : IN std_logic;          
		tx : OUT std_logic;
		bcd_0 : OUT std_logic_vector(7 downto 0);
		bcd_2 : OUT std_logic_vector(7 downto 0);
		bcd_4 : OUT std_logic_vector(7 downto 0);
		bcd_5 : OUT std_logic_vector(7 downto 0)
		);
END COMPONENT;

signal tx_1,tx_2,tx_control: STD_LOGIC;
signal tx_out: std_logic;


begin


tx_out<= tx_1 and tx_2 and tx_control;
TX <= tx_out;

Inst_NODO_1_TOP: NODO_1_TOP PORT MAP(
		clk => clk,
		reset => reset,
		rx => RX,
		tx => tx_1,
		ENTRADA1 => ENTRADA1_NODO1,
		ENTRADA2 => ENTRADA2_NODO1,
		SALIDA1 => SALIDA1_NODO1,
		SALIDA2 => SALIDA2_NODO1
	);



Inst_NODO_2_TOP: NODO_2_TOP PORT MAP(
		clk => clk,
		reset => reset,
		rx => RX,
		tx => tx_2,
		ENTRADA1 => ENTRADA1_NODO2,
		ENTRADA2 => ENTRADA2_NODO2,
		SALIDA1 => SALIDA1_NODO2,
		SALIDA2 => SALIDA2_NODO2
	);



Inst_NODO_CONTROL: NODO_CONTROL PORT MAP(
		clk => clk,
		reset => reset,
		rx => RX,
		tx => tx_control,
		ENTRADA_SALIDA => ENTRADA_SALIDA,
		MAS => MAS,
		indicador_errorr=>ERROR_OUT,
		MENOS => MENOS,
		bcd_0 => BCD_0,
		bcd_2 => BCD_2,
		bcd_4 => BCD_4,
		bcd_5 => BCD_5,
		MODIFICAR_SOLICITAR => MODIFICAR_SOLICITAR,
		ACEPTAR => ACEPTAR
	);
	
	
	
end Behavioral;

