----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:12:30 09/07/2020 
-- Design Name: 
-- Module Name:    BIT_ERROR - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BIT_ERROR is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           flag_BIT_error : out  STD_LOGIC;
           bit_recibido : in  STD_LOGIC;
           bit_enviado : in  STD_LOGIC;
           flag_bit_recibido : in  STD_LOGIC);
end BIT_ERROR;

architecture Behavioral of BIT_ERROR is

			type mis_estados is (idle,flag_on,error_out);
			signal estado : mis_estados;

signal cuenta : integer;


begin

		process (clk,reset)
	
		begin
			
			if (reset='1') then
			
				flag_BIT_error<='0';
				estado <=idle;
				cuenta <= 0;
				
			else

					if rising_edge (clk) then
					
						case estado is
						
							when idle =>
							
								if (flag_bit_recibido='1') then
								
									estado <= flag_on;
								end if;
							
							when flag_on =>


								if (bit_recibido/=bit_enviado) then
								
									flag_BIT_error <= '1';
									estado <=error_out;
								else
									estado <=idle;
									flag_BIT_error <='0';
								end if;

							when error_out =>

								if (cuenta= 25) then
								
									cuenta <=0;
									estado <= idle;
								else
									cuenta <= cuenta+1;
									end if;
						end case;
					end if;
			end if;
		
		end process;

end Behavioral;

