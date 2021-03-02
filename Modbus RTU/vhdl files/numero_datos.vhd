----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:34:57 05/11/2020 
-- Design Name: 
-- Module Name:    numero_datos - Behavioral 
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

entity numero_datos is
			
    Port ( reset : in  STD_LOGIC;
		   clk: in STD_LOGIC;	
           E : in  STD_LOGIC;
		   funcion : in integer;
		   dato : in integer;
		   valor_dec: out integer:=0); --NUMERO DE BYTES QUE TENEMOS SI FUNCION=15 O FUNCION=16
		  
			  
end numero_datos;

architecture Behavioral of numero_datos is

signal valor_int : integer;
 
begin
  
  process (reset,E,funcion,dato)
  
	begin
	
	 if (funcion=15 and dato mod 8 >0) then	
		valor_dec <= (dato/8)+1;
	 elsif (funcion=15) then
		valor_dec <= dato/8;	
	 elsif (funcion=16) then
		valor_dec <= dato*2;
	 else
		valor_dec <= 0;
	 end if;
	 
end process;


end Behavioral;

