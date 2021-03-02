----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:07:30 05/06/2020 
-- Design Name: 
-- Module Name:    BCD_7 - Behavioral 
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

entity BCD_7 is
    Port ( clk : in  STD_LOGIC;  --clk 50Mhz
          valor : in  integer;
		  CRC_in : in unsigned (15 downto 0);
		  registro_actual : in integer;
		  excepcion: in STD_LOGIC;
		  salida_datos,dato_actual : in integer; 
		  comando_actual : in STD_LOGIC_VECTOR ( 8 downto 0);
		  bcd_0 : out STD_LOGIC_VECTOR ( 7 downto 0);
		  bcd_1 : out STD_LOGIC_VECTOR ( 7 downto 0);
		  bcd_2 : out STD_LOGIC_VECTOR ( 7 downto 0);
		  bcd_3 : out STD_LOGIC_VECTOR ( 7 downto 0);
		  bcd_4 : out STD_LOGIC_VECTOR ( 7 downto 0);
		  bcd_5 : out STD_LOGIC_VECTOR ( 7 downto 0));
           
end BCD_7;

architecture Behavioral of BCD_7 is

signal led0,led1,led2,led3,valor_bcd0,valor_bcd1,valor_bcd2,valor_bcd3,crc_int: integer:=0;



function entero_a_bcd7 (
    entero : in integer)
    return std_logic_vector is
      variable v_TEMP : std_logic_vector(7 downto 0):="11111111";
  begin
  
  case entero is
  
   when 0 => v_TEMP  := "11000000"; -- "0"     
   when 1 => v_TEMP  := "11111001"; -- "1" 
   when 2 => v_TEMP  := "10100100"; -- "2" 
   when 3 => v_TEMP  := "10110000"; -- "3" 
   when 4 => v_TEMP  := "10011001"; -- "4" 
   when 5 => v_TEMP  := "10010010"; -- "5" 
   when 6 => v_TEMP  := "10000010"; -- "6" 
   when 7 => v_TEMP  := "11111000"; -- "7" 
   when 8 => v_TEMP  := "10000000"; -- "8"     
   when 9 => v_TEMP  := "10010000"; -- "9" 
   when 10 => v_TEMP := "10100000"; -- a
   when 11 => v_TEMP := "10000011"; -- b
   when 12 => v_TEMP := "11000110"; -- C
   when 13 => v_TEMP := "10100001"; -- d
   when 14 => v_TEMP := "10000110"; -- E
   when 15 => v_TEMP := "10001110"; -- F
   when others => v_TEMP := "10111111"; -- -
   
   end case;
   
  return v_TEMP;
  end entero_a_bcd7;
  
 
 

begin

crc_int <= to_integer(CRC_in);

	indicador_comando_actual:process (comando_actual,registro_actual)
	
 begin
				
   case comando_actual is
  
	when "000000001" => bcd_5 <= "11111001"; bcd_4 <= "11111111";
	when "000000010" => bcd_5 <= "10100100"; bcd_4 <= "11111111";
	when "000000100" => bcd_5 <= "10110000"; bcd_4 <= "11111111";
	when "000001000" => bcd_5 <= "10011001"; bcd_4 <= "11111111";
	when "000010000" => bcd_5 <= "10010010"; bcd_4 <= "11111111";
	when "000100000" => bcd_5 <= "10000010"; bcd_4 <= entero_a_bcd7(registro_actual);
	when "001000000" => bcd_5 <= "11000110"; bcd_4 <= "11111111";  --CRC
	when "010000000" => bcd_5 <= "10100001";  
	when others    => bcd_5 <= "10111111"; bcd_4 <= "11111111";
	
  end case;
  
  end process;



      
	process (clk,comando_actual)
	
		begin
			
			if rising_edge (clk) then
			
				if (comando_actual="010000000" and excepcion='1') then
				
				led0 <= salida_datos mod 16;
				bcd_0 <= entero_a_bcd7 (led0);
				bcd_1 <= "10000110";	
				bcd_2 <= "10000110";
				bcd_3 <= "10000110";
			
				elsif (comando_actual="010000000") then
			
				led0 <= salida_datos mod 16;
				valor_bcd0 <= salida_datos/16;
				bcd_0 <= entero_a_bcd7 (led0);
				
				led1 <= valor_bcd0 mod 16;
				valor_bcd1 <= valor_bcd0/16;
				bcd_1 <= entero_a_bcd7 (led1);
				
				led2 <= valor_bcd1 mod 16;
				valor_bcd2 <= valor_bcd1/16;
				bcd_2 <= entero_a_bcd7 (led2);
				
				led3 <= valor_bcd2 mod 16;
				valor_bcd3 <= valor_bcd2/16;
				bcd_3 <= entero_a_bcd7 (led3);
			
				elsif (comando_actual="001000000") then  --AÑADIR 1 BIT MAS A COMANDO_ACTUAL PARA VER DATOS RECIBIDOS
				
				led0 <= crc_int mod 16;
				valor_bcd0 <= crc_int/16;
				bcd_0 <= entero_a_bcd7 (led0);
				
				led1 <= valor_bcd0 mod 16;
				valor_bcd1 <= valor_bcd0/16;
				bcd_1 <= entero_a_bcd7 (led1);
				
				led2 <= valor_bcd1 mod 16;
				valor_bcd2 <= valor_bcd1/16;
				bcd_2 <= entero_a_bcd7 (led2);
				
				led3 <= valor_bcd2 mod 16;
				valor_bcd3 <= valor_bcd2/16;
				bcd_3 <= entero_a_bcd7 (led3);
			
				else
				
				led0 <= valor mod 16;
				valor_bcd0 <= valor/16;
				bcd_0 <= entero_a_bcd7 (led0);
				
				led1 <= valor_bcd0 mod 16;
				valor_bcd1 <= valor_bcd0/16;
				bcd_1 <= entero_a_bcd7 (led1);
				
				led2 <= valor_bcd1 mod 16;
				valor_bcd2 <= valor_bcd1/16;
				bcd_2 <= entero_a_bcd7 (led2);
				
				led3 <= valor_bcd2 mod 16;
				valor_bcd3 <= valor_bcd2/16;
				bcd_3 <= entero_a_bcd7 (led3);
				
				end if;
			
			else
			
			end if;
				
	
		end process;
	  
end Behavioral;



