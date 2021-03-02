----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:44:11 09/07/2020 
-- Design Name: 
-- Module Name:    timer_bit_receptor - Behavioral 
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
           flag_tiempo_bit : in  STD_LOGIC;--cuando se recibe un flanco de bajada en el receptor
           timer_ON : out  STD_LOGIC); -- bandera de inicio del bit
end timer_bit_receptor;

architecture Behavioral of timer_bit_receptor is

		type mis_estados is (timer);
		signal estado: mis_estados;

signal cuenta: integer;		
signal sdsds: std_logic_vector (1 downto 0);

begin


		contador: process (clk,reset)
		
		begin
		
			if (reset='1') then
			
				estado <= timer;
				cuenta <= 0;
				timer_ON <= '0';
				
			else 

					if rising_edge(clk) then
					
						case estado is 
						
							when timer =>
							
								timer_ON <= '0';
							
								if (flag_tiempo_bit='1') then
								
									cuenta <= 0;
									timer_ON<= '0';
									
								elsif(cuenta= 49) then
									cuenta <= 0;
									timer_ON<= '1';
									
								else
								
									cuenta <= cuenta +1;
								
								end if;	
						end case;
					end if;
			end if;			
		
		end process;



end Behavioral;

