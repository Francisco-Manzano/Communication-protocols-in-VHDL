----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:33:44 04/22/2020 
-- Design Name: 
-- Module Name:    receptor - Behavioral 
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
--   1750 micro seconds for 3.5 char time, and 750 micro seconds for 1.5 char time para baud rate mayor de 19200
entity receptor is
		generic(
			bits : integer :=8
			);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           ticks : in  STD_LOGIC;
           rx : in  STD_LOGIC; --entrada de datos
			  rx_activado: in STD_LOGIC;--indicador de que se ha transmitido una orden al esclavo y se espera respuesta
           rx_desactivado: out STD_LOGIC:='1';
			  datos : out  STD_LOGIC_VECTOR (bits-1 downto 0);
			  reset_cont_rx: out STD_LOGIC:='0'; --resetea el contador de baudios
			  rx_fin_trama : out STD_LOGIC:= '0'; --bandera de fin de trama testbench
           rx_fin : out  STD_LOGIC:='0'); -- bandera de byte recibido 
end receptor;

architecture Behavioral of receptor is                                                                  
	type mis_estados is (idle,bit_inicio,bit_datos,bit_stop1,bit_stop2,espera,delay,delay2); 
	signal estado_receptor : mis_estados;
	signal dato_temp : std_logic_vector (bits-1 downto 0):=(others=>'0');
	signal ticks16 : unsigned (5 downto 0); -- 16 ticks para recibir cada bit, excepto el de start
	signal numerobytes : integer range 0 to bits; -- bytes  por trama recibida
	signal bit_index : integer range 0 to 7 := 0;
	signal contador_espera : integer range 0 to 40000 := 0; -- mas de 800 us entre bytes indica fin de trama
	signal numerobytes_temp: integer:=0;

begin

		proceso_receptor: process (clk,reset)
		begin
		
			if (reset='1') then
					rx_desactivado<='1';
					estado_receptor <= idle;
					ticks16<= (others=> '0');
					bit_index <= 0;
					reset_cont_rx<='0';
					numerobytes_temp <= 0;
					contador_espera <= 0;
			else
				if rising_edge(clk) then
					if (rx_activado = '1') then
					
						case estado_receptor is
							when idle =>
								datos <= (others=>'0');
								rx_desactivado <='0';
								bit_index <= 0;
								rx_fin <='0';		
								
								ticks16<=(others => '0');
								if (rx='0') then
								numerobytes_temp<=0;
									estado_receptor <= bit_inicio;
									ticks16 <= (others =>'0');
									reset_cont_rx<= '1';
									
								end if;
							when bit_inicio =>
								reset_cont_rx<= '0';
								datos <= (others=>'0');
								if (ticks='1') then
									if (ticks16=7) then
										if (rx='0') then
										estado_receptor <= bit_datos;
										ticks16 <= (others=>'0');
										else
										estado_receptor <= idle;
										end if;
										
									else
										ticks16 <= ticks16+1;
									end if;
								end if;
							when bit_datos =>
									if (ticks='1') then
										if (ticks16=15) then
											ticks16 <= (others=>'0');
											dato_temp(bit_index) <= rx;
											if (bit_index<7) then
												 bit_index <= bit_index+1;
												 estado_receptor <= bit_datos; 
											else
												bit_index <= 0;
												estado_receptor <= bit_stop1;
											end if;
										else
											ticks16 <= ticks16+1;
										end if;
									end if;
							when bit_stop1 =>
									if (ticks='1') then
										if (ticks16=15) then
											ticks16 <= (others=>'0');
											estado_receptor <= bit_stop2;
										else
											ticks16<= ticks16+1;
										end if;
									end if;
							when bit_stop2 =>
									if (ticks='1') then
										if (ticks16=15) then
											ticks16 <= (others=>'0');
											estado_receptor <= espera;
											numerobytes_temp <= numerobytes_temp+1;
											rx_fin <= '1';     
											datos <= dato_temp; --aqui enviamos el dato recibido al modulo uart_top para su analisis
										else
											ticks16<= ticks16+1; 
										end if;
									end if;
							when espera =>
											rx_fin <= '0';
											if (contador_espera < 40000) then  --CONTADOR PARA FIN DE MENSAJE RECIBIDO
												contador_espera <= contador_espera +1;
												reset_cont_rx<= '1';
												if (rx='0') then
													estado_receptor <= bit_inicio;
													reset_cont_rx<= '0';
													contador_espera <= 0;
												end if;
											else
												numerobytes<=numerobytes_temp;
												rx_fin_trama <= '1';
												reset_cont_rx<= '0';
												contador_espera <= 0;
												estado_receptor <= delay;
												rx_desactivado <='1';
											end if;
							when delay =>
											ticks16<= (others=> '0');
				
											if (ticks='1')then
											rx_fin_trama <= '0';
											estado_receptor <= delay2;									
											end if;
							when delay2 =>
											
											estado_receptor <= idle;									
											
							
													
												
								end case;
							end if;
					end if;
			end if;
		
		end process;
		
end Behavioral;

