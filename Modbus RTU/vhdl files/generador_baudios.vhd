----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:06:16 04/19/2020 
-- Design Name: 
-- Module Name:    generador_baudios - Behavioral 
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

entity generador_baudios is
	generic (
		baudios : integer := 115200;
		frecuencia : integer := 50*10**6 -- 50 MHz
		);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  reset_cont: in STD_LOGIC;
           ticks : out  STD_LOGIC);
end generador_baudios;

architecture Behavioral of generador_baudios is
	signal contador : integer range 0 to frecuencia/(baudios*16);
begin
	proceso: process (clk,reset,reset_cont)
	begin
			if (reset='1' or reset_cont='1') then
					contador <= 0;
			else
				if rising_edge (clk) then
					if (contador=(frecuencia/((baudios*16)))-1) then
						ticks <= '1';
						contador <= 0;
					else
						ticks <= '0';
						contador <= contador+1;
					end if;
				end if;
			end if;
	end process;

end Behavioral;

