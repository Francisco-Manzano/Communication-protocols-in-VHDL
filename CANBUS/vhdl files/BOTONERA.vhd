----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:47:15 09/13/2020 
-- Design Name: 
-- Module Name:    BOTONERA - Behavioral 
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

entity BOTONERA is
    Port ( clk1hz : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           ENTRADA_SALIDA : in  STD_LOGIC;
           MODIFICAR_SOLICITAR : in  STD_LOGIC;		   
           ACEPTAR : in  STD_LOGIC;
           MAS : in  STD_LOGIC;
           MENOS : in  STD_LOGIC;
		   visualizar_modificar : out  STD_LOGIC; -- '1'AVISA AL BCD para que muestre el valor que se esta introduciendo
		   mostrar_entrada_salida: out STD_LOGIC; --'0' para entrada ; '1' para salida A OPERACION 
           ID_A_ENVIAR : out  STD_LOGIC_VECTOR (10 downto 0); --A OPERACION Y BCD
           RTR_A_ENVIAR : out  STD_LOGIC;  --A OPERACION
		   introduccion_finalizada: out STD_LOGIC:='0';--MARCA QUE SE HA INTRODUCIDO EL MENSAJE NUEVO A OPERACION
           SALIDA_INTRODUCIDA : out  STD_LOGIC_VECTOR (7 downto 0));--A OPERACION Y BCD
end BOTONERA;

architecture Behavioral of BOTONERA is

			type estado_botones is (ver_entradas,ver_salidas,modif_salida,modif_salida_2,pedir_entrada,pedir_entrada_2);
			
			signal estado_actual : estado_botones;
			signal cnt_sig : integer range 0 to 15 ; --direccion
			signal cnt_manual : integer range 0 to 15; --valor para salidas
			
			

begin
				
					process(clk1hz,reset)
					
					
					procedure contador_index (masS : in STD_LOGIC;
									  menosS :in STD_LOGIC;	
									  signal cuenta : inout integer range 0 to 15) is
										  
					constant max: integer :=15;
						
					begin

						if (masS = '0' and cuenta < max) then cuenta <= cuenta + 1;
						elsif (masS = '0' and cuenta = max) then cuenta <= 0;
						elsif (menosS = '0' and cuenta > 0) then cuenta <= cuenta -1;
						elsif (menosS = '0' and cuenta = 0) then cuenta <= 15 ;
						end if;
					
					end procedure;
					
					begin
															
						if (reset='1') then

							ID_A_ENVIAR <= (others=>'0');
							RTR_A_ENVIAR <= '0';
							SALIDA_INTRODUCIDA <= (others=>'0');
							mostrar_entrada_salida <='0';
							estado_actual <= ver_entradas;
							cnt_sig <=0;
							cnt_manual <=0;
							introduccion_finalizada<='0';
					
						else
							
								if rising_edge(clk1hz) then
										
										
										case estado_actual is
										
										
											when ver_entradas =>
											
												ID_A_ENVIAR <=std_logic_vector(to_unsigned(cnt_sig,11));
												contador_index(MAS,MENOS,cnt_sig);
												mostrar_entrada_salida <='0';
												visualizar_modificar <='0';
											
												if (ENTRADA_SALIDA='1') then
												
													estado_actual<= ver_salidas;
													mostrar_entrada_salida <='1';
												
												elsif (MODIFICAR_SOLICITAR='1') then

													estado_actual <= pedir_entrada;
													
												end if;
													
											when ver_salidas =>		
											
												ID_A_ENVIAR <=std_logic_vector(to_unsigned(cnt_sig,11));
												contador_index(MAS,MENOS,cnt_sig);
												mostrar_entrada_salida <='1';	
												visualizar_modificar <='0';
												
												if (ENTRADA_SALIDA='0') then
												
													estado_actual<= ver_entradas;
													mostrar_entrada_salida <='0';
												
												elsif (MODIFICAR_SOLICITAR='1') then

													estado_actual <= modif_salida;
													visualizar_modificar <='1';
												end if;

									
											when modif_salida =>
											
												ID_A_ENVIAR <=std_logic_vector(to_unsigned(cnt_sig,11));												
												visualizar_modificar <='1';												
												SALIDA_INTRODUCIDA <= std_logic_vector(to_unsigned(cnt_manual,8));
												mostrar_entrada_salida <='1';	
												contador_index(MAS,MENOS,cnt_manual);
												RTR_A_ENVIAR<='0';
												
												if (MODIFICAR_SOLICITAR='0') then

													estado_actual <= ver_salidas;
													visualizar_modificar <='0';
													SALIDA_INTRODUCIDA <= (others =>'0');
													cnt_manual <= 0;
													
												elsif (ACEPTAR='1') then
												
													estado_actual <= modif_salida_2;
													introduccion_finalizada<='1';
													
												end if;
												
											when modif_salida_2 =>
										
												if (MODIFICAR_SOLICITAR='0') then
												
													introduccion_finalizada<='0';	
													SALIDA_INTRODUCIDA <=(others =>'0');
													estado_actual <= ver_salidas;
													cnt_manual <= 0;
												end if;

											when pedir_entrada =>
													
												ID_A_ENVIAR <=std_logic_vector(to_unsigned(cnt_sig,11));
												contador_index(MAS,MENOS,cnt_sig);
												RTR_A_ENVIAR<='1';
												mostrar_entrada_salida <='0';												
												
												if (MODIFICAR_SOLICITAR='0') then

													estado_actual <= ver_entradas;												
													
												elsif (ACEPTAR='1') then
												
													estado_actual <= pedir_entrada_2;
													introduccion_finalizada<='1';
													
												end if;
								
											when pedir_entrada_2 =>
											
													
										
												if (MODIFICAR_SOLICITAR='0') then
												
													introduccion_finalizada<='0';
													SALIDA_INTRODUCIDA <=(others =>'0');
													estado_actual <= ver_salidas;	
													
												end if;		
		
										end case;
								end if;
						end if;
								
				end process;			
		
		
		
		
		
		
			

end Behavioral;

