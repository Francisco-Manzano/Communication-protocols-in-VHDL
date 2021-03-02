----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:12:02 04/19/2020 
-- Design Name: 
-- Module Name:    uart_top - Behavioral 
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

entity uart_top is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
		   tx: out STD_LOGIC;
		   rx : in STD_LOGIC;
           --rx_tx : inout  STD_LOGIC; --entrada/salida de datos RS485
		   tx_inicio: in STD_LOGIC;  -- señal desde el modulo CRC
		   tx_activo: out STD_LOGIC; --TX ESTA TRANSMITIENDO
		   tx_fin: out STD_LOGIC;  --señal de byte enviado testbench
		   rx_fin: out STD_LOGIC; -- bandera de byte recibido 
		   bytes_totales: in integer; --ESTO SALE DE LA CRC MENSAJE+CRC=BYTES
           datos : in  STD_LOGIC_VECTOR (120 downto 0); -- MENSAJE + CRC A ENVIAR
		   datos_recibidos: out STD_LOGIC_VECTOR ( 7 downto 0); -- byte desde el modulo receptor
		   rx_fin_trama: out STD_LOGIC);  --bandera de fin de trama testbench
end uart_top;

architecture Behavioral of uart_top is

	signal ticks : std_logic;
	signal reset_cont: std_logic;
	signal rx_activado : std_logic;
	signal rx_desactivado : std_logic;
	signal reset_cont_rx: std_logic;
	signal reset_cont_tx: std_logic;
	-- signal rx : std_logic;
	-- signal tx : std_logic;
	
	
	COMPONENT generador_baudios
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		reset_cont : IN std_logic;          
		ticks : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT transmisor
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		ticks : IN std_logic;
		tx_inicio : IN std_logic;
		datos : IN std_logic_vector(120 downto 0);         
		tx_activo : OUT std_logic;
		reset_cont_tx : OUT std_logic;
		rx_activado : OUT std_logic;
		rx_desactivado : IN std_logic; 
		bytes_totales: in integer;
		tx : OUT std_logic;
		tx_fin : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT receptor
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		ticks : IN std_logic;
		rx : IN std_logic;
		rx_activado : IN std_logic;          
		rx_desactivado : OUT std_logic;
		datos : OUT std_logic_vector(7 downto 0);
		reset_cont_rx : OUT std_logic;
		rx_fin_trama : OUT std_logic;
		rx_fin : OUT std_logic
		);
	END COMPONENT;


begin
--
		
		
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

Inst_transmisor: transmisor PORT MAP(
		clk => clk,
		reset => reset,
		ticks => ticks,
		tx_inicio => tx_inicio,
		datos => datos,
		tx_activo => tx_activo,
		reset_cont_tx => reset_cont_tx,
		rx_activado => rx_activado,
		rx_desactivado => rx_desactivado,
		bytes_totales => bytes_totales,
		tx => tx,
		tx_fin => tx_fin 
	);


Inst_receptor: receptor PORT MAP(
		clk => clk,
		reset => reset,
		ticks => ticks,
		rx => rx,
		rx_activado => rx_activado,
		rx_desactivado => rx_desactivado,
		datos => datos_recibidos,
		rx_fin_trama => rx_fin_trama,
		reset_cont_rx => reset_cont_rx,
		rx_fin => rx_fin
	);
	
	
end Behavioral;

