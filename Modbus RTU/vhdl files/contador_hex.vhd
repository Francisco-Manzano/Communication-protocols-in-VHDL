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

entity contador_hex is
			
    Port ( reset : in  STD_LOGIC;
           E : in  STD_LOGIC;
           clk : in  STD_LOGIC;  --1hz
		   valor_dec: out integer:=0;
		   MENOS : in  STD_LOGIC;
           MAS : in  STD_LOGIC);
			  
end contador_hex;

architecture Behavioral of contador_hex is

 signal cnt_sig: integer:=0;
 constant max : integer := 65535;
 
begin

  valor_dec <= cnt_sig;
  process (reset,E,clk,MAS,MENOS)
  
	begin
	
	if (reset = '1')
	  then cnt_sig <= 0;
	 else
	 if rising_edge (clk) then
   	 if E = '1' then			  
	     if (MAS = '0' and cnt_sig < max) then cnt_sig <= cnt_sig + 1;
		  elsif (MAS = '0' and cnt_sig = max) then cnt_sig <= 0;
	     elsif (MENOS = '0' and cnt_sig > 0) then cnt_sig <= cnt_sig -1;
		  elsif (MENOS = '0' and cnt_sig = 0) then cnt_sig <= max ;
	     end if;
		  
	    end if;
	 end if;
	 end if;
end process;


end Behavioral;
