----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:41:41 08/10/2020 
-- Design Name: 
-- Module Name:    receptor_ESCLAVO - Behavioral 
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

entity receptor_ESCLAVO is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
		   esclavo_encendido : in STD_LOGIC;  --ON/OFF DEL ESCLAVO
           rx : in  STD_LOGIC; --entrada de datos
		   ticks : in  STD_LOGIC;
		   reset_cont_rx: out STD_LOGIC:='0'; --resetea el contador de baudios     
		   rx_fin : out  STD_LOGIC:='0'; -- bandera de datos recibido
		   rx_valido: out STD_LOGIC:='0';  --ACTIVA OPERACION PARA COMPROBAR DIRECCION
		   datos_completos : out  STD_LOGIC_VECTOR (10 downto 0)); --datos para operacion
           
end receptor_ESCLAVO;

architecture Behavioral of receptor_ESCLAVO is

	type mis_estados is (idle,bit_inicio,bit_datos,bit_paridad,bit_stop1,paridad_check,delay0,delay,delay2); 
	signal estado_receptor : mis_estados;
	signal dato_temp : std_logic_vector (10 downto 0):=(others=>'0');
	signal ticks16 : unsigned (5 downto 0); -- 16 ticks para recibir cada bit, excepto el de start
	signal bit_index : integer range 0 to 10 := 0;
	signal paridad_recibida: std_logic :='0';
	signal contador_espera : integer range 0 to 2100 := 0; --7 bit times, 42 us por si responde otro esclavo,no activar este
	signal contador2 : integer range 0 to 200 := 0;  --espera a que el maestro deje de transmitir
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
					dato_temp <= (others=>'0');
					contador_espera <=0;
					datos_completos <= (others => '0');
					contador2 <=0;

			else
				if rising_edge(clk) then	
				
					if ( esclavo_encendido='1') then
			
					case estado_receptor is
					
							when idle =>
								contador_espera <=0;
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
								dato_temp <= (others=>'0');
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
											dato_temp(10-bit_index) <= rx;
											if (bit_index<10) then
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
											datos_completos <= dato_temp; 
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
										for i in 0 to 10 loop
											paridad_calculada := paridad_calculada xor dato_temp(i);
										end loop;
										estado_receptor <= delay;
			
							when delay =>
							
											if (paridad_calculada=paridad_recibida) then
												rx_valido <= '1';
											else
												rx_valido <= '0';
											end if;
										  estado_receptor<=delay2;
							
							when delay2 =>
											
										rx_valido <= '0';	
										if (contador_espera<2100) then
											
											contador_espera <= contador_espera +1;
										else	
											ticks16<= (others=> '0');
											estado_receptor <= idle;
											contador_espera<=0;
										end if;
					end case;
					
					end if;
						
						
				end if;
			
			end if;
		
		end process;	
			
			
			
			
			
			
			
			
			



end Behavioral;

