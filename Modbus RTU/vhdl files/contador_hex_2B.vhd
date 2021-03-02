----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:56:57 05/05/2020 
-- Design Name: 
-- Module Name:    contador_hex - Behavioral 
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

entity contador_hex_2B is
			
    Port ( reset : in  STD_LOGIC;
           E : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  valor_dec: out integer:=0;
           valor_vector : out  STD_LOGIC_VECTOR (15 downto 0);
           UP_DOWN : in  STD_LOGIC);
			  
end contador_hex_2B;

architecture Behavioral of contador_hex_2B is

 signal cnt_sig: integer;
 constant max : integer := 65535;
 
begin

  valor_dec <= cnt_sig;
  valor_vector <= std_logic_vector(to_unsigned(cnt_sig,valor_vector'length)); 
  process (reset,E,clk,UP_DOWN)
  
	begin
	
	if (reset = '1')
	  then cnt_sig <= 0;
	 else
	 if rising_edge (clk) then
   	 if E = '1' then
	     if (UP_DOWN = '1' and cnt_sig < max) then cnt_sig <= cnt_sig + 1;
		  elsif (UP_DOWN = '1' and cnt_sig = max) then cnt_sig <= 0;
	     elsif (UP_DOWN = '0' and cnt_sig > 0) then cnt_sig <= cnt_sig -1;
		  elsif (UP_DOWN = '0' and cnt_sig = 0) then cnt_sig <= max ;
	     end if;
		  
	    end if;
	 end if;
	 end if;
end process;


end Behavioral;
