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
--   
entity receptor is
		
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           ticks : in  STD_LOGIC;
           rx : in  STD_LOGIC; --entrada de datos desde el esclavo
		   rx_activado: in STD_LOGIC;			  --indicador de que se ha transmitido una orden al esclavo y se espera respuesta
		   datos : out  STD_LOGIC_VECTOR (3 downto 0):=(others => '0'); --datos a operacion
		   reset_cont_rx: out STD_LOGIC:='0'; --resetea el contador de baudios
           rx_fin : out  STD_LOGIC:='0'; -- bandera de datos recibido
			rx_valido: out STD_LOGIC:='0'); --señal de recepcion valida
end receptor;

architecture Behavioral of receptor is                                                                  
	type mis_estados is (idle,bit_inicio,bit_datos,bit_paridad,bit_stop1,delay0,paridad_check,delay); 
	signal estado_receptor : mis_estados;
	signal dato_temp : std_logic_vector (3 downto 0):=(others=>'0');
	signal ticks16 : unsigned (5 downto 0); -- 16 ticks para recibir cada bit, excepto el de start
	signal bit_index : integer range 0 to 3 := 0;
	signal paridad_recibida: std_logic :='0';
	signal contador2 : integer range 0 to 200 := 0;  --espera a que el esclavo deje de transmitir
	
	


begin

		proceso_receptor: process (clk,reset)
			variable paridad_calculada: std_logic:= '0';
		begin
			
			if (reset='1') then
					paridad_recibida <= '0';
					paridad_calculada := '0';
					estado_receptor <= idle;
					ticks16<= (others=> '0');
					bit_index <= 0;
					reset_cont_rx<='0';
					rx_valido <= '0';
					datos <= (others=>'0');
					contador2 <=0;
					
			else
				if rising_edge(clk) then
					if (rx_activado = '1') then
					
						case estado_receptor is
							when idle =>
								paridad_recibida <= '0';
								paridad_calculada :='0';	
								rx_valido <= '0';
								bit_index <= 0;
								rx_fin <='0';		
								ticks16<=(others => '0');
								if (rx='0') then
								
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
											dato_temp(3-bit_index) <= rx;
											if (bit_index<3) then
												 bit_index <= bit_index+1;
												 estado_receptor <= bit_datos; 
											else
												bit_index <= 0;
												estado_receptor <= bit_paridad;
											end if;
										else
											ticks16 <= ticks16+1;
										end if;
									end if;
							when bit_paridad =>
									if (ticks='1') then
										if (ticks16=15) then
											ticks16 <= (others=>'0');
											paridad_recibida<=rx;
											estado_receptor <= bit_stop1;
										else
											ticks16<= ticks16+1;
										end if;
									end if;
							when bit_stop1 =>
									if (ticks='1') then
										if (ticks16=15) then
											ticks16 <= (others=>'0');
											estado_receptor <= delay0;
											rx_fin <= '1';     
											datos <= dato_temp; 
										else
											ticks16<= ticks16+1; 
										end if;
									end if;
									
							when delay0 =>

									if ( contador2 < 200 ) then
										
										contador2 <= contador2+1;
									else
										contador2<=0;
										estado_receptor<= paridad_check;
									end if;	
									
							when paridad_check =>
											rx_fin <= '0';
											for i in 0 to 3 loop
											paridad_calculada := paridad_calculada xor dato_temp(i);
											end loop;
											estado_receptor <= delay;
							when delay =>
											if (paridad_calculada=paridad_recibida) then
												rx_valido <= '1';
											else
												rx_valido <= '0';
											end if;
											ticks16<= (others=> '0');
											estado_receptor <= idle;
							
													
												
								end case;
							end if;
					end if;
			end if;
		
		end process;
		
end Behavioral;

