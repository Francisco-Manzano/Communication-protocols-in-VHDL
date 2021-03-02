----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:29:09 09/14/2020 
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
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           dato_desde_operacion : in  STD_LOGIC_VECTOR (7 downto 0);
           ID_A_MOSTRAR : in  STD_LOGIC_VECTOR (10 downto 0);
           SALIDA_INTRODUCIDA : in  STD_LOGIC_VECTOR (7 downto 0);
		   mostrar_entrada_salida: in STD_LOGIC;
           visualizar_modificar : in  STD_LOGIC;
           bcd_0 : out STD_LOGIC_VECTOR ( 7 downto 0):="11111111"; --salida/entrada
		   bcd_2 : out STD_LOGIC_VECTOR ( 7 downto 0):="11111111"; --VER/MODIFICAR_SOLICITAR
		   bcd_4 : out STD_LOGIC_VECTOR ( 7 downto 0):="11111111"; -- ENTRADA/SALIDA
		   bcd_5 : out STD_LOGIC_VECTOR ( 7 downto 0):="11111111"); -- ID
end BCD_7;

architecture Behavioral of BCD_7 is


--ID PARA LAS SALIDAS DE LOS DOS NODOS	
	constant ID_outputs_nodo2: STD_LOGIC_VECTOR (10 downto 0):="00000000100";	-- ID 4		
	constant ID_outputs_nodo1: STD_LOGIC_VECTOR (10 downto 0):="00000000010";	-- ID 2	
	
--ID PARA LAS ENTRADAS DE LOS DOS NODOS	
	constant ID_inputs_nodo2:	 STD_LOGIC_VECTOR (10 downto 0):="00000000011";	-- ID 3	
	constant ID_inputs_nodo1:	 STD_LOGIC_VECTOR (10 downto 0):="00000000001";	-- ID 1

signal ID: integer range 0 to 15:=1;
signal dato_operaciones : integer range 0 to 15:=0;
signal dato_botonera: integer range 0 to 15:=0;

signal led5: integer:=0;
signal led0: integer:=0;

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

ID <= to_integer(unsigned(ID_A_MOSTRAR));
dato_operaciones <= to_integer(unsigned(dato_desde_operacion));
dato_botonera <= to_integer(unsigned(SALIDA_INTRODUCIDA));


	direccionn: process (clk,reset)
		
		begin
		
			if (reset='1') then
			
				bcd_5<="10111111";
				led5 <= 0;
				
			else	
				if rising_edge (clk) then
					
				  led5 <= ID mod 16;  --DIRECCION					
			      bcd_5 <= entero_a_bcd7 (led5);
				
				end if;
			end if;
		
		end process;

	E_S : process (clk,reset)
		
		begin
		
			if (reset='1') then
			
				bcd_4<="10111111";
			
				
			else	
				if rising_edge (clk) then
					
					if (mostrar_entrada_salida='1') then  --ENTRADA O SALIDA DE LOS NODOS
							bcd_4 <= "10010010";  --SALIDA
					else
							bcd_4 <= "10000110"; --ENTRADA 
					end if;
				
				
				end if;
			end if;
		
		end process;

	VER_MODIFICAR : process (clk,reset)
		
		begin
		
			if (reset='1') then
			
				bcd_2<="10111111";
			
				
			else	
				if rising_edge (clk) then
					
					if (visualizar_modificar='1') then  --ENTRADA O SALIDA DE LOS NODOS
							bcd_2 <= "11001000";  --SALIDA
					else
							bcd_2 <= "10111111"; --ENTRADA
					end if;
				
				
				end if;
			end if;
		
		end process;	


	datos_a_mostrarr:process(clk,reset)
			
			begin
				if (reset='1') then
				
				bcd_0 <="10111111";
				else
				
					 if rising_edge (clk) then  --
		
							if (visualizar_modificar='1') then  --datos desde controles
							
									led0 <= dato_botonera mod 16;
									bcd_0 <= entero_a_bcd7(led0);
															
							else 
							
								if (mostrar_entrada_salida='1') then --SALIDAS
																
									if ( ID_A_MOSTRAR=ID_outputs_nodo1 OR ID_A_MOSTRAR=ID_outputs_nodo2) then
									
										led0 <= dato_operaciones mod 16;
										bcd_0 <= entero_a_bcd7(led0);
										
									else 
										bcd_0 <= "10111111";
									end if;
									
								else  --ENTRADAS
								
									if ( ID_A_MOSTRAR=ID_inputs_nodo1 OR ID_A_MOSTRAR=ID_inputs_nodo2) then
									
										led0 <= dato_operaciones mod 16;
										bcd_0 <= entero_a_bcd7(led0);
										
									else 
										bcd_0 <= "10111111";
									end if;	
									
										
								end if;
							end if;
							
					 end if;		
				end if;

			
			end process;	

end Behavioral;

