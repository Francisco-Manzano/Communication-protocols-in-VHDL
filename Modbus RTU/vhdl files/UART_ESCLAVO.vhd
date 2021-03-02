----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:58:06 12/01/2020 
-- Design Name: 
-- Module Name:    UART_ESCLAVO - Behavioral 
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

entity UART_ESCLAVO is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           datos_completos : in  STD_LOGIC_VECTOR (120 downto 0);
		   datos_recibidos: out STD_LOGIC_VECTOR (7 downto 0);
		   bytes_a_enviar: in integer;
		   tx_inicio: in STD_LOGIC;
		   LED_TX_INICIADA_ESCLAVO: out STD_LOGIC;
		   LED_RX_RECIBIDO_ESCLAVO: out STD_LOGIC;
		   flag_fin_recepcion: out STD_LOGIC;
		   flag_byte_recibido: out STD_LOGIC;
		   numerobytes_recibidos: out integer;
           rx : in  STD_LOGIC;
           tx : out  STD_LOGIC:='1');
end UART_ESCLAVO;

architecture Behavioral of UART_ESCLAVO is


	signal ticks : std_logic;
	signal reset_cont: std_logic;
	signal reset_cont_rx: std_logic;
	signal reset_cont_tx: std_logic;
	signal tx_activo,tx_fin: std_logic;
	signal tx_int: std_logic;


	COMPONENT generador_baudios
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		reset_cont : IN std_logic;          
		ticks : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT RECEPTOR_ESCLAVO
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		rx : IN std_logic;
		ticks : IN std_logic;          
		flag_byte_recibido : OUT std_logic;
		flag_fin_recepcion : OUT std_logic;
		numerobytes : OUT integer;
		LED_RX_RECIBIDO_ESCLAVO: out STD_LOGIC;
		datos : OUT std_logic_vector(7 downto 0);
		reset_cont_rx : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT TRANSMISOR_ESCLAVO
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		datos_a_enviar : IN std_logic_vector(120 downto 0);
		tx_inicio : IN std_logic;
		bytes_totales : IN integer;
		ticks : IN std_logic;    
		LED_TX_INICIADA_ESCLAVO: out STD_LOGIC;
		tx_activo : OUT std_logic;
		reset_cont_tx : OUT std_logic;
		tx : OUT std_logic;
		tx_fin : OUT std_logic
		);
	END COMPONENT;
	
	

begin

			tx <= tx_int when tx_activo = '1'
								 else 'Z';				
			

			proceso1: process (clk,reset_cont_rx,reset_cont_tx)
			begin	
				reset_cont <= reset_cont_rx or reset_cont_tx;
				
			end process;

	
	Inst_generador2_baudios: generador_baudios PORT MAP(
		clk => clk,
		reset => reset,
		reset_cont => reset_cont,
		ticks => ticks
	);
	
	
	Inst_RECEPTOR_ESCLAVO: RECEPTOR_ESCLAVO PORT MAP(
		clk => clk,
		reset => reset,
		rx => rx,
		LED_RX_RECIBIDO_ESCLAVO => LED_RX_RECIBIDO_ESCLAVO,
		flag_byte_recibido => flag_byte_recibido,
		flag_fin_recepcion => flag_fin_recepcion,
		numerobytes => numerobytes_recibidos,
		datos => datos_recibidos,
		reset_cont_rx => reset_cont_rx,
		ticks => ticks
	);
	
	
	Inst_TRANSMISOR_ESCLAVO: TRANSMISOR_ESCLAVO PORT MAP(
		clk => clk,
		reset => reset,
		datos_a_enviar => datos_completos,
		tx_inicio => tx_inicio,
		tx_activo => tx_activo,
		LED_TX_INICIADA_ESCLAVO => LED_TX_INICIADA_ESCLAVO,
		reset_cont_tx => reset_cont_tx,
		bytes_totales => bytes_a_enviar,
		tx => tx_int,
		tx_fin => tx_fin,
		ticks => ticks
	);

end Behavioral;

