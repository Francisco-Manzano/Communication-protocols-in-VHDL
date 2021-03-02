----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:07:18 09/09/2020 
-- Design Name: 
-- Module Name:    modulo_salidas - Behavioral 
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

entity modulo_salidas_1 is

	GENERIC(ID_OUT: integer:=2);

    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           identificador_recibido : in  STD_LOGIC_VECTOR(10 downto 0);
           RTR_recibido : in  STD_LOGIC;
           flag_mensaje_aceptado : in  STD_LOGIC;
           datos_recibidos : in  STD_LOGIC_VECTOR (63 downto 0);
           SALIDA1 : out  STD_LOGIC;
           SALIDA2 : out  STD_LOGIC);
end modulo_salidas_1;

architecture Behavioral of modulo_salidas_1 is


			type mis_estados is (idle,compara_id,FIN);
			signal estado: mis_estados;
			
			
			
signal  id_output : STD_LOGIC_VECTOR( 10 downto 0);		--id para las salidas			

begin

id_output<=std_logic_vector(to_unsigned(ID_OUT,id_output'length));

		process (clk,reset)
		
		begin
			
			if (reset='1') then
			
				estado <= idle;
				SALIDA1 <= '0';
				SALIDA2 <= '0';
			
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
						
							if (identificador_recibido=id_output) then --y el identificador es igual al nuestro
							
								if (RTR_recibido='0') then --y el RTR es '0' (datos) 
								
									estado <= FIN;
								else
									estado <=idle;
								end if;
							else
								estado <= idle;
							end if;
						
						when FIN =>

							SALIDA1 <= datos_recibidos(56);  --modificamos las salidas segun los valores recibidos
							SALIDA2 <= datos_recibidos(57);
							estado <=idle;
							
						end case;
				end if;
			end if;		
		
		end process;





end Behavioral;

