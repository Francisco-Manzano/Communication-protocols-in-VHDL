library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
--use IEEE.STD_LOGIC_ARITH.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity relojj_1hz is
	GENERIC(
    clk_freq : INTEGER := 10*10**6);  --reloj 50Mhz/2 VALOR REAL 50*10**6    
	 
     Port (clk,reset: in STD_LOGIC;
	  reloj1hz : out STD_LOGIC);
end relojj_1hz;

architecture Behavioral of relojj_1hz is

signal q_interna: integer range 0 to clk_freq :=0;
signal salida_aux: std_logic:= '0';


begin

reloj1hz <= salida_aux;

process
	 begin
	      wait until clk = '1';
			 if reset = '1' then q_interna <= 0; salida_aux <= '0';
				elsif q_interna = clk_freq -1 then salida_aux <= not salida_aux;q_interna <= 0;
				else q_interna <= q_interna +1;
			end if;
end process;			


end Behavioral;