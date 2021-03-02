----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:18:41 09/02/2020 
-- Design Name: 
-- Module Name:    STUFF_ERROR - Behavioral 
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

entity STUFF_ERROR is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
		   inicio_anticipado: in STD_LOGIC;--si en el 3 bit de intermission detectamos el '0' de START
           inicio_recepcion : in  STD_LOGIC;   --desde el modulo receptor directamente
           flag_bit_recibido : in  STD_LOGIC;  --desde el modulo receptor directamente
		   bit_recibido : in STD_LOGIC;  --desde el modulo receptor directamente
           flag_stuff_error : out  STD_LOGIC:='0'); --hacia operacion
end STUFF_ERROR;

architecture Behavioral of STUFF_ERROR is

			type mis_estados is (idle,calculos,flag_out);
			signal estado_actual : mis_estados;
			
signal bit0_stuff :integer:=0;
signal bit1_stuff : integer:=0;		

begin


		process(clk,reset,inicio_recepcion)
		
		begin
		
		
		if (reset='1' ) then
		
			estado_actual <= idle;
			flag_stuff_error <='0';
			bit0_stuff <= 0;
			bit1_stuff <= 0;
		else 

				if rising_edge (clk) then
				
					case estado_actual is
					
						when idle =>
						
							if (flag_bit_recibido='1') then
							
								estado_actual <=  calculos;
								
								if ( bit_recibido='1') then
								
									bit1_stuff<=  bit1_stuff+1;
									bit0_stuff <= 0;
								else
									bit0_stuff <= bit0_stuff +1;
									bit1_stuff <= 0;
								end if;
							end if;
							
									
						when calculos =>

							if (bit1_stuff=6 or bit0_stuff=6) then
							
								estado_actual <= flag_out;
							else
								estado_actual <= idle;
							end if;
							
						when flag_out =>
						
							flag_stuff_error <= '1';
							
								if (inicio_recepcion='1') then
								
									bit0_stuff <= 0;
									bit1_stuff <= 0;
									estado_actual <= idle;
									flag_stuff_error <='0';
									
								elsif (inicio_anticipado='1') then
									
									bit0_stuff <= 1;
									bit1_stuff <= 0;
									estado_actual <= idle;
									flag_stuff_error <='0';
									
								else
									estado_actual <= flag_out;
								end if;
								
					end case;
				end if;
		end if;			
	
		
		end process;

end Behavioral;

