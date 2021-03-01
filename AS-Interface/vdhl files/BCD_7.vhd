----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:37:38 08/13/2020 
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
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           dato_a_mostrar_operativa : in  STD_LOGIC_VECTOR (10 downto 0);
           esclavo_no_conectado : in  boolean; --TRUE PARA EXISTE ESCLAVO    FALSE PARA NO EXISTE ESCLAVO
           senal_desde_controles : in  STD_LOGIC;  --MARCA EL CAMBIO ENTRE DATOS DESDE OPERACION Y DATOS DESDE CONTROLES
           dato_desde_controles : in  STD_LOGIC_VECTOR (4 downto 0);
		    bcd_0 : out STD_LOGIC_VECTOR ( 7 downto 0):="11111111";
			bcd_3 : out STD_LOGIC_VECTOR ( 7 downto 0):="11111111"; --direccion
			bcd_4 : out STD_LOGIC_VECTOR ( 7 downto 0):="11111111"; --direccion
			bcd_5 : out STD_LOGIC_VECTOR ( 7 downto 0):="11111111");      --d o P  
end BCD_7;

architecture Behavioral of BCD_7 is


signal direccion: integer range 1 to 31:=1;
signal dato_a_mostrar_operativa_int : integer range 0 to 15:=0;
signal dato_a_mostrar_controles_int : integer range 0 to 15:=0;
signal led0,led4: integer:=0;
signal led3,valor_bcd_3 : integer :=0;



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


direccion <= to_integer(unsigned(dato_a_mostrar_operativa(9 downto 5)));
dato_a_mostrar_operativa_int <= to_integer(unsigned(dato_a_mostrar_operativa(3 downto 0)));
dato_a_mostrar_controles_int <=to_integer(unsigned(dato_desde_controles(3 downto 0)));

		direccionn: process (clk,reset)
		
		begin
		
		if (reset='1') then
		
			bcd_3<="10111111";
			bcd_4<="10111111";
		else	
				if rising_edge (clk) then
				
				led3 <= direccion mod 16;  --DIRECCION
				valor_bcd_3 <= direccion /16;
				bcd_3 <= entero_a_bcd7 (led3);
													
				led4 <= valor_bcd_3 mod 16; --DIRECCION
				bcd_4 <= entero_a_bcd7(led4);
				end if;
		end if;
		
		end process;

		dato_parametro: process (clk,reset)
		
		begin
			if (reset='1') then
			
			bcd_5<="10111111";
			
			else
					
				if rising_edge (clk) then
			
							if (dato_a_mostrar_operativa(4)='1') then  --D O P
								bcd_5 <= "10001100";  --p
							else
								bcd_5 <= "10100001"; --d
							end if;
				end if;	

			end if;	
		
		end process;
		
			datos_a_mostrarr:process(clk,reset)
			
			begin
				if (reset='1') then
				
				bcd_0 <="10111111";
				else
				
					 if rising_edge (clk) then
		
							if (senal_desde_controles='1') then  --datos desde controles
							
								if ( esclavo_no_conectado = true) then
									led0 <= dato_a_mostrar_controles_int mod 16;
									bcd_0 <= entero_a_bcd7(led0);
								else 
									bcd_0 <= "10111111";
								end if;
								
							elsif ( senal_desde_controles ='0') then   --datos desde operativa
								
								if ( esclavo_no_conectado = true) then
									led0 <= dato_a_mostrar_operativa_int mod 16;
									bcd_0 <= entero_a_bcd7(led0);
								else 
									bcd_0 <= "10111111";
								end if;
							end if;
							
					 end if;		
				end if;

			
			end process;

		


					


end Behavioral;

