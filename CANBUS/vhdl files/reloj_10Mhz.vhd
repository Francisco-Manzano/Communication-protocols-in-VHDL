-- Engineer: 
-- 
-- Create Date:    12:18:12 08/09/2020 
-- Design Name: 
-- Module Name:    clk_1hz - Behavioral 
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

entity reloj_10Mhz is
	GENERIC(
    clk_freq : INTEGER := 5);  --reloj 10Mhz    100 ns periodo
	 
     Port (clk,reset: in STD_LOGIC;
	  relojj_10Mhz : out STD_LOGIC);
end reloj_10Mhz;

architecture Behavioral of reloj_10Mhz is

signal q_interna: integer range 0 to clk_freq :=0;
signal salida_aux: std_logic:= '0';


begin

relojj_10Mhz <= salida_aux;

process
	 begin
	      wait until clk = '1';
			 if reset = '1' then

			 q_interna <= 0; salida_aux <= '0';
			 
			 elsif q_interna = clk_freq -1 then

			 salida_aux <= not salida_aux;
			 q_interna <= 0;
			 
			 else
			salida_aux <= '0';	--ESTAMOS USANDO EL RISING EDGE cada 100 ns;el falling edge no importa
			q_interna <= q_interna +1;
			
			end if;
end process;			


end Behavioral;