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
           tx_inicio : in  STD_LOGIC; --señal desde el modulo crc
           datos : in  STD_LOGIC_VECTOR (120 downto 0);
		   tx_activo : out STD_LOGIC:='0'; --esta transmitiendo
		   reset_cont_tx: out STD_LOGIC; --resetea contador de baudios
		   rx_activado: out STD_LOGIC:='0'; --activa rx para respuesta
	       rx_desactivado: in STD_LOGIC;
		   bytes_totales: in integer;  --SEÑAL DESDE EL CRC
           tx : out  STD_LOGIC:='0'; --linea de transmision
           tx_fin : out  STD_LOGIC); --señal de byte enviado testbench
end transmisor;

architecture Behavioral of transmisor is
	type mis_estado is (idle,bit_inicio,bit_datos,delay,bit_stop1,bit_stop2);
	signal estado_transmisor : mis_estado;
	signal datos_temp : std_logic_vector (120 downto 0); -- para evitar problemas de metaestabilidad
	signal ticks16 : unsigned (5 downto 0); -- 16 ticks para enviar cada bit
	signal bit_index : integer range 0 to 7 :=0; -- 8 bits de datos enviados por cada ciclo
	signal byte_actual: integer:=0;
	signal byte_a_transmitir : std_logic_vector(7 downto 0); --el byte que estoy transmitiendo
	signal i : integer range 0 to 2500 :=0;
	signal contador_espera : integer range 0 to 5000000 := 0; --espera para respuesta del esclavo
	

begin

		proceso_transmisor: process (clk,reset)
		begin
			if (reset='1') then
					rx_activado<='0';
					estado_transmisor <= idle;
					ticks16 <= (others => '0');
					bit_index <= 0;
					byte_actual <=0;
					reset_cont_tx <= '0';
				
			else
				if rising_edge(clk) then
					--if (rx_desactivado='1') then
				
						case estado_transmisor is
							when idle =>
								i<= 0;
								contador_espera<=0;
								tx <= '1'; -- linea en alto para idle
								tx_activo <= '0';
								tx_fin <= '0';
								rx_activado <='0'; 
								byte_actual <=0;
								bit_index <= 0;
								ticks16<=(others => '0');
							
								if (tx_inicio = '1') then
								datos_temp <= datos;
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
								byte_a_transmitir <=datos_temp(i+7 downto i+0);
								if (ticks='1') then
									
									if (ticks16=15) then
										
										estado_transmisor <= bit_datos;
										ticks16 <= (others => '0');
										bit_index <= 0;
									else 
										estado_transmisor <= bit_inicio;
										ticks16 <= ticks16+1;
									end if;
								end if;
							
							when bit_datos =>
								tx_activo <= '0';
								tx <= byte_a_transmitir(bit_index);
								
								if (ticks='1') then
										if (ticks16=15) then
											ticks16 <= (others => '0');
											if (bit_index=7) then
												estado_transmisor <= bit_stop1;  
											else
												bit_index <= bit_index+1;
												estado_transmisor <= bit_datos;
											end if;
										else
											ticks16 <= ticks16+1;
										end if;
								end if;
							
							when bit_stop1 =>
									
									tx <= '1';
									if (ticks='1') then
										if (ticks16=15) then
											estado_transmisor <= bit_stop2;
											ticks16 <= (others => '0');
											
										else
											ticks16 <= ticks16+1;
										end if;
									end if;
							when bit_stop2 =>
									tx <= '1';
									if (ticks='1') then
										if (ticks16=15) then
											estado_transmisor <= delay;
											ticks16 <= (others => '0');
											tx_fin <= '1';
											byte_actual <= byte_actual+1;
										else
											ticks16 <= ticks16+1;
										end if;
									end if;		
							when delay =>                    
									tx_fin <= '0';
									bit_index <= 0;
									if (contador_espera < 5000) then  
										contador_espera <= contador_espera +1;
									else
										contador_espera <=0;
										if (byte_actual=bytes_totales) then  
											tx_activo <= '0';
											rx_activado <='1'; 			--ACTIVA RECEPTOR UART A LA ESPERA DE RESPUESTA DEL ESCLAVO
												
											if (contador_espera<5000000) then
												contador_espera<=contador_espera+1;
											else
												rx_activado<='0';
												contador_espera<=0;
												estado_transmisor <= idle;
											end if;
											
										else
											estado_transmisor <= bit_inicio;
											ticks16<=(others => '0');
											bit_index <= 0;
											i <= i+8;
											reset_cont_tx <= '1';		
										end if;	
									end if;	

							end case;

						end if;
					--end if;
				end if;
								
				end process;
						
										
								
					
end Behavioral;

