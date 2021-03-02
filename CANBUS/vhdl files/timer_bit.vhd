----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:25:12 09/05/2020 
-- Design Name: 
-- Module Name:    timer_bit - Behavioral 
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

entity timer_bit_receptor is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           flag_tiempo_bit : in  STD_LOGIC;
           flag_tiempo_out_receptor : out  STD_LOGIC);
end timer_bit_receptor;

architecture Behavioral of timer_bit_receptor is


		type mis_estados is (timer);
		signal estado: mis_estados;

signal cuenta: integer;				

begin

		contador: process (clk,reset)
		
		begin
		
			if (reset='1') then
			
				estado <= timer;
				cuenta <= 0;
				flag_tiempo_out <= '0';
				
			else 

					if rising_edge(clk) then
					
						case estado is 
						
							when timer =>
							
								flag_tiempo_out <= '0';
							
								if (flag_tiempo_bit='1') then
								
									cuenta <= 0;
									
								elsif(cuenta= 49) then
									cuenta <= 0;
									flag_tiempo_out<= '1';
									
								else
								
									cuenta <= cuenta +1;
								
								end if;	
						end case;
					end if;
			end if;			
		
		end process;


end Behavioral;

