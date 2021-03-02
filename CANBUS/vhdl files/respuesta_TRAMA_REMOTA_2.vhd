----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:39:14 09/09/2020 
-- Design Name: 
-- Module Name:    respuesta_TRAMA_REMOTA - Behavioral 
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

entity respuesta_TRAMA_REMOTA_2 is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           identificador_recibido : in  STD_LOGIC_VECTOR (10 downto 0);
           RTR_RECIBIDO : in  STD_LOGIC;
           flag_mensaje_aceptado : in  STD_LOGIC;
           mensaje_en_espera : out  STD_LOGIC;
           transmisor_activo : in  STD_LOGIC);
end respuesta_TRAMA_REMOTA_2;




architecture Behavioral of respuesta_TRAMA_REMOTA_2 is

			
			type mis_estados is (idle,compara_id,FIN);
			signal estado: mis_estados;
			
			
constant id_input : STD_LOGIC_VECTOR( 10 downto 0):="00000000011";		--id para las entradas
																--este nodo responde a la trama remota que solicita sus entradas

begin

		process (clk,reset)
		
		begin
			
			if (reset='1') then
			
				estado <= idle;	
				mensaje_en_espera <='0';	
			
			else
			
				if rising_edge(clk) then
				
						case estado is 
						
						when idle =>
						
							if (flag_mensaje_aceptado='1') then --si el mensaje no contiene errores...
							
								estado <= compara_id;
							else
								estado <= idle;
								
							end if;

						when compara_id =>

							if (identificador_recibido=id_input) then --y el identificador es igual al nuestro

								if (RTR_recibido='1') then --y el RTR es '1' (remota) 
	
									estado <= FIN;
									mensaje_en_espera <= '1'; --activamos flag de mensaje a enviar
								else
									estado <= idle;
								end if;
							else
								estado <= idle;
							end if;
						
						when FIN =>

							if (transmisor_activo='1' and flag_mensaje_aceptado='1') then --esperamos a que finalize el siguiente mensaje
																						--si somos el transmisor del mensaje significa que hemos
																						--enviado el mensaje en espera y volvemos a idle
								estado <= idle;
								mensaje_en_espera <= '0';
							else

								estado <= FIN;
							end if;

						end case;
				end if;
			end if;
			

		end process;
		






end Behavioral;