----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:35:48 04/19/2020 
-- Design Name: 
-- Module Name:    uart_transmisor - Behavioral 
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

entity transmisor is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           ticks : in  STD_LOGIC;
           tx_inicio : in  STD_LOGIC; --señal desde operacion
           datos : in  STD_LOGIC_VECTOR (10 downto 0);
		   tx_activo : out STD_LOGIC:='0'; --esta transmitiendo testbench
		   reset_cont_tx: out STD_LOGIC:='0'; --resetea contador de baudios
		   rx_activado: out STD_LOGIC:='0'; --activa rx para respuesta
		   rx_valido: in STD_LOGIC:='0';  --indica si se recibio respuesta del esclavo
           tx : out  STD_LOGIC:='0'; --linea de transmision
		   esclavo_off : out std_logic_vector (1 downto 0):= "00"; --señal a operacion 
           tx_fin : out  STD_LOGIC:='0'); --señal de mensaje enviado testbench
end transmisor;

architecture Behavioral of transmisor is
	type mis_estado is (idle,bit_inicio,bit_datos,bit_paridad,delay,bit_stop);
	signal estado_transmisor : mis_estado;
	signal datos_temp : std_logic_vector (10 downto 0); -- para evitar problemas de metaestabilidad
	signal ticks16 : unsigned (5 downto 0); -- 16 ticks para enviar cada bit
	signal bit_index : integer range 0 to 10 :=0; -- 11 bits de datos enviados por mensaje
	signal contador_espera : integer range 0 to 3000 := 0; --10 bit times, 60 us
	

begin

		proceso_transmisor: process (clk,reset)
			variable paridad: std_logic:='0';
		begin
			
			if (reset='1') then
					rx_activado<='0';
					estado_transmisor <= idle;
					ticks16 <= (others => '0');
					bit_index <= 0;
					reset_cont_tx <= '0';
					paridad := '0';
					esclavo_off <= "00";
			else
				if rising_edge(clk) then
					
				
						case estado_transmisor is
							when idle =>
								paridad := '0';
								contador_espera<=0;
								tx <= '1'; -- linea en alto para idle
								tx_activo <= '0';
								tx_fin <= '0';
								rx_activado <='0'; 
								bit_index <= 0;
								esclavo_off <= "00";
								ticks16<=(others => '0');
								datos_temp <= datos;
								if (tx_inicio = '1') then
									
									reset_cont_tx <= '1';
									estado_transmisor <= bit_inicio;
										
								else
									estado_transmisor <= idle;
								end if;
								
							when bit_inicio =>	

								
								
								tx <= '0';  -- linea en bajo para inicio de transmision
								tx_activo <= '1';
								reset_cont_tx <= '0';
								contador_espera<=0;
								
								if (ticks='1') then
									if (ticks16=15) then
									
										for i in 0 to 10 loop
										paridad := paridad xor datos_temp(i);
										end loop;
										
										estado_transmisor <= bit_datos;
										ticks16 <= (others => '0');
										bit_index <= 0;
									else 
										estado_transmisor <= bit_inicio;
										ticks16 <= ticks16+1;
									end if;
								end if;
							
							when bit_datos =>
								tx <= datos_temp(10-bit_index);	
								if (ticks='1') then
										if (ticks16=15) then
											ticks16 <= (others => '0');
											if (bit_index=10) then
												estado_transmisor <= bit_paridad;  
											else
												bit_index <= bit_index+1;
												estado_transmisor <= bit_datos;
											end if;
										else
											ticks16 <= ticks16+1;
										end if;
								end if;
							
							when bit_paridad =>
								tx <= paridad;
								if (ticks='1') then
										if (ticks16=15) then
											ticks16 <= (others => '0');
											estado_transmisor <= bit_stop;
										else
											ticks16 <= ticks16+1;
										end if;
								end if;
							
										
							when bit_stop =>
									
									tx <= '1';
									if (ticks='1') then
										if (ticks16=15) then
											estado_transmisor <= delay;
											ticks16 <= (others => '0');
											tx_fin <= '1';
											
										else
											ticks16 <= ticks16+1;
										end if;
									end if;
							
							when delay =>  
															--ESPERA RESPUESTA DEL ESCLAVO
									rx_activado <='1'; 						
									tx_fin <= '0';
									bit_index <= 0;
									if (contador_espera < 3000) then  
										contador_espera <= contador_espera +1;
										if (rx_valido = '1') then
											estado_transmisor <= idle;
											esclavo_off <= "10";
											contador_espera <=0;
										end if;	
									else
										esclavo_off <= "01";
										contador_espera <=0;
										estado_transmisor <= idle;										
									end if;	

							end case;

						end if;
					
				end if;
								
				end process;
						
										
								
					
end Behavioral;

