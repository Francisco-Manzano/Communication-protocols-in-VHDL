----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:53:57 08/11/2020 
-- Design Name: 
-- Module Name:    unidad_operativa_ESCLAVO - Behavioral 
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

entity unidad_operativa_ESCLAVO is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           rx_valido : in  STD_LOGIC; --viene del uart receptor
           datos_completos : in  STD_LOGIC_VECTOR (10 downto 0); --viene del uart receptor
           tx_activado : out  STD_LOGIC;  --activa el transmisor para respuesta
		   esclavo_encendido : in  STD_LOGIC;
		   ENTRADA1: in STD_LOGIC;
		   ENTRADA2 : in STD_LOGIC;
		   SALIDA1 :out STD_LOGIC:='0';
		   SALIDA2: out STD_LOGIC:='0';
           datos_a_enviar : out  STD_LOGIC_VECTOR (3 downto 0));
end unidad_operativa_ESCLAVO;

architecture Behavioral of unidad_operativa_ESCLAVO is


constant IO : STD_LOGIC_VECTOR (3 downto 0):= "0011"; --FREE CONFIG
constant ID : STD_LOGIC_VECTOR (3 downto 0):= "1111";

signal valores_in : STD_LOGIC_VECTOR (1 downto 0) :="00";  --VALORES DE LAS ENTRADAS DEL ESCLAVO
signal parametros :  STD_LOGIC_VECTOR (3 downto 0) :="1111";
signal direccion : STD_LOGIC_VECTOR (4 downto 0) := "00011";  --direccion 3
signal direccion_valida : STD_LOGIC:='0';
signal status_bits : STD_LOGIC_VECTOR (3 downto 0):= "1010";
signal esclavo_activado :STD_LOGIC :='0';  --DESPUES DE LA PRIMERA RECEPCION DE PARAMETROS



	type mis_estados is (idle,comandos,comandos2,datos_parametros_dir,parametros2,fin);
	signal estado_actual : mis_estados;
	
	type comprobar is (idle1,check);
	signal estado_check : comprobar;





begin
			
	

			comprobacion: process (clk,reset) --COMPRUEBA DIRECCION RECIBIDA CON LA QUE TIENE
			
				begin
				
				if (reset='1') then
				 estado_check <= idle1;
				 
				else

					if rising_edge (clk) then
					
						case estado_check is
						
							when idle1 =>
							
								if (rx_valido='1')then
								
									if (datos_completos(9 downto 5)=direccion) then
									
										estado_check <= check;
										direccion_valida <= '1';
										
									else
										estado_check <=idle1;
									end if;
								end if;	
							
							when check =>
		
								direccion_valida <= '0';	
								estado_check <=idle1;
							
						end case;
					end if;
				end if;		
										
	
				end process;

				fases: process (clk,reset)  --FASES DEL ESCLAVO
				
				begin
				
				if (reset='1' or esclavo_encendido='0') then
				
					estado_actual <= idle;
					valores_in <= "00";
					parametros <= "1111";
					SALIDA1 <= '0';
					SALIDA2 <= '0';
					datos_a_enviar <="0000";
					
				else

							if rising_edge(clk) then
							
								case estado_actual is
								
									when idle =>

											valores_in(1) <= ENTRADA2;
											valores_in(0) <= ENTRADA1;
									
										if (direccion_valida='1') then
										
											if ( datos_completos(10)='1') then
										
												estado_actual <= comandos;	
											else
												estado_actual <= datos_parametros_dir;
											end if;	
											
										end if;	
										
									when comandos =>	--COMANDOS  
									
										case datos_completos(4 downto 0) is
											
											when "11100" =>  --RESET_SLAVE

											 SALIDA1<= '0';	
											 SALIDA2<= '0';	
											 parametros <="1111";
											 datos_a_enviar<="0110";
											 tx_activado <= '1';
											 estado_actual <= comandos2;
											 
											when "00000" =>  --DELETE ADDRESS

											direccion <="00000";
											datos_a_enviar<="0000";
											tx_activado <= '1';
											estado_actual <= comandos2;
											
											when "10000" =>   -- READ_IO
											
											datos_a_enviar<=IO;
											tx_activado <= '1';
											estado_actual <= comandos2;
											
											when "10001" =>    --READ_ID_CODE
											
											datos_a_enviar<=ID;
											tx_activado <= '1';
											estado_actual <= comandos2;
											
											when "11110" =>   --READ_STATUS
											
											datos_a_enviar<=status_bits;
											tx_activado <= '1';
											estado_actual <= comandos2;
											
											when "11111" =>   --READ_RESET_STATUS
											
											datos_a_enviar<=status_bits;
											status_bits <="0000";
											tx_activado <= '1';
											estado_actual <= comandos2;
											
											when others => 
											
											estado_actual <= idle;
											
										end case;
										
									when comandos2 =>

										   tx_activado <= '0';
										   estado_actual <= idle;
							
										
									when datos_parametros_dir =>  
										
										if ( datos_completos(9 downto 5)="00000") then  --ADDRESS ASSIGNMENT
										
											direccion <= datos_completos(4 downto 0);
											tx_activado <= '1';
											datos_a_enviar <= "0110";
											estado_actual <= fin;
											
										elsif ( datos_completos(4)='1') then      --PARAMETROS
												
												parametros <= datos_completos(3 downto 0);
												estado_actual <= parametros2;
												esclavo_activado <='1';
												
										elsif (	datos_completos(4)='0') then    --DATOS
										
											if (esclavo_activado='1') then

												SALIDA1<= datos_completos(0);
												SALIDA2<= datos_completos(1);
												datos_a_enviar(3 downto 2)<= valores_in;
												datos_a_enviar(1 downto 0)<=datos_completos(1 downto 0);
												tx_activado <= '1';
												estado_actual <= fin;
											else

												estado_actual<=idle;
											end if;	
												
										end if;		

									when parametros2 => 

										datos_a_enviar <= parametros;
										tx_activado <= '1';
										estado_actual <= fin;

											
									when fin =>	
									
									    tx_activado <='0';
										estado_actual<= idle;
											
									
										
								end case;
								
							end if;			
									
									
				end if;	


				end process;





















end Behavioral;

