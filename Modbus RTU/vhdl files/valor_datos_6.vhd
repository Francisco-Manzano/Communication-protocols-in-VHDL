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

entity valor_datos_6 is
			
    Port ( reset : in  STD_LOGIC;
           E : in  STD_LOGIC; 
		   clk : in  STD_LOGIC;  --1hz
		   MENOS : in  STD_LOGIC;
           MAS : in  STD_LOGIC;		  
		   siguiente_registro: in STD_LOGIC;		
		   funcion : in integer;
		   numero_datos : in integer;
		   registro_actual: out integer;
		   valor_dec: out integer:=0);
		   
			  
end valor_datos_6;

architecture Behavioral of valor_datos_6 is

type mem is array (0 to 9) of integer;

signal iteraciones: integer:=0;
signal i: integer:=0;
signal registro : mem:= (others =>0);

constant max : integer := 65535;
 
begin
  
  valor_dec <= registro(i);
  registro_actual <= i+1;
 
  iteracioness:process (funcion,numero_datos)
  
	begin
	
	 if (funcion=15) then
		iteraciones <= numero_datos;
	 elsif (funcion=16) then
		iteraciones <= numero_datos/2;
	 else
		iteraciones <= 0;
	 end if;	 
	 
end process;

 registro_actuall : process (iteraciones,clk,reset,siguiente_registro)
 
	begin
	if (reset='1') then
	 i<=0;
	 else
		if rising_edge(clk) then
		
			if (siguiente_registro='1' and iteraciones>0) then
				if (i=iteraciones-1) then
					i <= 0;
				else 
					i<= i+1;
				end if;
			end if;
		end if;
	end if;	
end process;
	

  process (reset,E,clk,MAS,MENOS)
  
	begin
	
	if (reset = '1')
		then registro <= (others=>0);
    else
	 if rising_edge (clk) then
		if E = '1' then		 	
			if (MAS = '0' and registro(i) < max) then registro(i) <= registro(i) + 1;
			elsif (MAS = '0' and registro(i) = max) then registro(i) <= 0;
			elsif (MENOS = '0' and registro(i) > 0) then registro(i) <= registro(i) -1;
			elsif (MENOS = '0' and registro(i) = 0) then registro(i) <= max ;
			end if;
		  
	    end if;
	  end if;
    end if;
end process;


end Behavioral;
