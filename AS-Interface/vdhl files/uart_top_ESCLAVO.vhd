----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:12:06 08/11/2020 
-- Design Name: 
-- Module Name:    uart_top_ESCLAVO - Behavioral 
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

entity uart_top_ESCLAVO is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           tx_activado : in  STD_LOGIC; --desde operacion para activar transmisor
		   rx_tx: inout STD_LOGIC;
           datos_a_enviar : in  STD_LOGIC_VECTOR (3 downto 0); --desde operacion para transmisor
           esclavo_encendido : in  STD_LOGIC;
           rx_valido : out  STD_LOGIC; --esto va a operacion
           datos_completos : out  STD_LOGIC_VECTOR (10 downto 0));  --a operacion    
end uart_top_ESCLAVO;

architecture Behavioral of uart_top_ESCLAVO is

	signal ticks : std_logic;
	signal reset_cont: std_logic;
	signal rx_activado : std_logic :='0';
	signal reset_cont_rx: std_logic;
	signal reset_cont_tx: std_logic;
	signal rx,tx : std_logic;
	signal rx_fin,tx_fin: std_logic;
	signal tx_activo : STD_LOGIC :='0';
	
	

COMPONENT generador_baudios
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		reset_cont : IN std_logic;          
		ticks : OUT std_logic
		);
END COMPONENT;

COMPONENT receptor_ESCLAVO
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		esclavo_encendido : IN std_logic;
		rx : IN std_logic;
		ticks : IN std_logic;          
		reset_cont_rx : OUT std_logic;
		rx_fin : OUT std_logic;
		rx_valido : OUT std_logic;
		datos_completos : OUT std_logic_vector(10 downto 0)
		);
END COMPONENT;


COMPONENT transmisor_ESCLAVO
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		ticks : IN std_logic;
		tx_activado : IN std_logic;
		datos_a_enviar : IN std_logic_vector(3 downto 0);          
		tx_activo : OUT std_logic;
		reset_cont_tx : OUT std_logic;
		tx : OUT std_logic;
		tx_fin : OUT std_logic
		);
END COMPONENT;


begin

		rx_tx <= tx when tx_activo = '1'
								else 'Z';				
		rx <= rx_tx;

		proceso1: process (clk,reset_cont_rx,reset_cont_tx)
				  begin	
					reset_cont <= reset_cont_rx or reset_cont_tx;
				
				  end process;


	Inst_generador_baudios: generador_baudios PORT MAP(
		clk => clk,
		reset => reset,
		reset_cont => reset_cont,
		ticks => ticks
	);



	Inst_receptor_ESCLAVO: receptor_ESCLAVO PORT MAP(
		clk => clk,
		reset => reset,
		esclavo_encendido => esclavo_encendido,
		rx => rx,
		ticks => ticks,
		reset_cont_rx => reset_cont_rx,
		rx_fin => rx_fin,
		rx_valido => rx_valido,
		datos_completos => datos_completos
	);
	
	
	Inst_transmisor_ESCLAVO: transmisor_ESCLAVO PORT MAP(
		clk => clk,
		reset => reset,
		ticks => ticks,
		tx_activado => tx_activado,
		tx_activo => tx_activo,
		reset_cont_tx => reset_cont_tx,
		tx => tx,
		tx_fin => tx_fin,
		datos_a_enviar => datos_a_enviar
	);
	
	
	
	
end Behavioral;

