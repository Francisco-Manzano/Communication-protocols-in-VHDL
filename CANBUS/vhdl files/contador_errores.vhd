----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:18:06 09/12/2020 
-- Design Name: 
-- Module Name:    contador_errores - Behavioral 
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

entity contador_errores is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           transmisor_activo : in  STD_LOGIC;
           flag_mensaje_aceptado : in  STD_LOGIC;
           error_delimiter_flag : in  STD_LOGIC;
           error_transmisor_flag : in  STD_LOGIC;
           overload_transmisor_flag : in  STD_LOGIC;
           overload_delimiter_flag : in  STD_LOGIC;          
		   bit_sin_relleno: in STD_LOGIC; 
		   BUS_OFF : out STD_LOGIC:='0';
           modulo_errores_pas_flag : out  STD_LOGIC;
           ACK_ERROR : in  STD_LOGIC;
		   flag_bits_sin_relleno: in STD_LOGIC;
		   cuenta_bits_dominantes: in integer;
		   bit_dominante: in STD_LOGIC;
           e : in  integer);
end contador_errores;



architecture Behavioral of contador_errores is



			type mis_estados is (idle,ERROR_FLAG,ERROR_DEL,OVER_FLAG,OVER_DEL);
			signal estado: mis_estados;


signal CONTADOR_TRANSMISOR : integer:=0;
signal CONTADOR_RECEPTOR : integer:=0;
signal modulo_errores_pas_flag_tmp: STD_LOGIC:='0';
signal ack_excepcion: STD_LOGIC:='0';
signal detector_del_error: STD_LOGIC:='0';--INDICA SI SOMOS EL QUE HA DETECTADO EL ERROR ('1'),O HEMOS RESPONDIDO A UN FLAG ERROR('0')
signal sdnsnds: std_logic_vector ( 1 downto 0);

begin


modulo_errores_pas_flag <=modulo_errores_pas_flag_tmp;


		cuenta: process(clk,reset)
		
		begin
		
			if (reset='1') then
			
				modulo_errores_pas_flag_tmp <='0';
				BUS_OFF <='0';
				
			else 
			
				if rising_edge(clk) then
			
					if (CONTADOR_TRANSMISOR >255) then

						BUS_OFF <= '1';

					elsif (CONTADOR_TRANSMISOR>127 or CONTADOR_RECEPTOR >127) then --CAMBIO A ERROR ACTIVO/PASIVO REGLA 9

						modulo_errores_pas_flag_tmp <='1'; --PASAMOS A ERROR PASIVO
										
					elsif (CONTADOR_TRANSMISOR<=127 or CONTADOR_RECEPTOR <=127) then		
								
						modulo_errores_pas_flag_tmp <='0'; --PASAMOS A ERROR ACTIVO
				
					end if;
				end if;
			end if;
			
		end process;
		
		
		
		
		
			
			process( clk,reset)
			
			begin
	

			if (reset='1') then
			
				detector_del_error<='0';
				CONTADOR_TRANSMISOR <=0;
				CONTADOR_RECEPTOR <=0;
				estado <=idle;
				
				ack_excepcion <='0';
				
				
			else
			
				
					if rising_edge (clk) then
					
						case estado is
						
							when idle =>
							
								if (ACK_ERROR='1') then
								
									ack_excepcion <='1';
									estado<= ERROR_FLAG;
							
								elsif (error_transmisor_flag='1') then  
								
									if (transmisor_activo='0') then -- +1 EN EL CONTADOR_RECEPTOR SI SOMOS RECEPTOR
								
										CONTADOR_RECEPTOR <= CONTADOR_RECEPTOR+1; --REGLA 1
										estado <= ERROR_FLAG;
									else
										estado <=ERROR_FLAG;
									end if;	
								
								elsif (overload_transmisor_flag='1') then
								
										estado <= OVER_FLAG;
								
								elsif (flag_mensaje_aceptado='1') then --MENSAJE VALIDO ==> RESTAMOS 1 AL CONTADOR

									if (transmisor_activo='1' and CONTADOR_TRANSMISOR>0) then --REGLA 7
									
										CONTADOR_TRANSMISOR <= CONTADOR_TRANSMISOR-1;
										
									elsif ( transmisor_activo='0') then --REGLA 8
									
										if (CONTADOR_RECEPTOR>0 and CONTADOR_RECEPTOR<128) then
										
											CONTADOR_RECEPTOR <= CONTADOR_RECEPTOR-1;
											
										elsif (	CONTADOR_RECEPTOR>127) then
										
											CONTADOR_RECEPTOR <= 119;
										end if;
									end if;
									
								
										
								end if;

							when ERROR_FLAG =>
							
								if (cuenta_bits_dominantes=7 and bit_sin_relleno='0') then  --REGLA 2
								
									if (detector_del_error='0' and modulo_errores_pas_flag_tmp='0') then
										
										if (transmisor_activo='0') then 
										
											CONTADOR_RECEPTOR <= CONTADOR_RECEPTOR+8;
											detector_del_error<='1';
										end if;
									end if;
								
								elsif (error_transmisor_flag='1' and modulo_errores_pas_flag_tmp='0') then --REGLAS 4 Y 5
								
										detector_del_error<='0';
								
										if (transmisor_activo='1') then
										
											CONTADOR_TRANSMISOR <= CONTADOR_TRANSMISOR +8;
										else
											CONTADOR_RECEPTOR <=  CONTADOR_RECEPTOR+8;
										end if;
										
								elsif	( error_delimiter_flag='1') then
								
										ack_excepcion<='0';
										detector_del_error <='0';
										estado <= ERROR_DEL;
								
										if (modulo_errores_pas_flag_tmp='1' and ack_excepcion='1') then --EXCEPCION 3.1
										
											if (bit_dominante='0') then-- no hemos recibido ningun '0' en la bandera PASIVA
											
												estado <=ERROR_DEL;
											else
												CONTADOR_TRANSMISOR <= CONTADOR_TRANSMISOR+8; --REGLA 3
											end if;
											
										elsif (transmisor_activo='1') then
										
											CONTADOR_TRANSMISOR <= CONTADOR_TRANSMISOR+8; --REGLA 3
											estado <= ERROR_DEL;
											
										end if;
								
								elsif (flag_bits_sin_relleno='1') then --REGLA 6
								
										if (modulo_errores_pas_flag_tmp='0' and (cuenta_bits_dominantes-6)mod 8=0) then
										
											if (cuenta_bits_dominantes/=0) then
											
										
												if (transmisor_activo='1') then
												
													CONTADOR_TRANSMISOR <= CONTADOR_TRANSMISOR+8;
												else
													CONTADOR_RECEPTOR <= CONTADOR_RECEPTOR +8;
												end if;
											end if;
												
										elsif (modulo_errores_pas_flag_tmp='1' and cuenta_bits_dominantes mod 8=0) then	
										
											if (cuenta_bits_dominantes/=0) then

												if (transmisor_activo='1') then
												
													CONTADOR_TRANSMISOR <= CONTADOR_TRANSMISOR+8;
												else
													CONTADOR_RECEPTOR <= CONTADOR_RECEPTOR +8;
												end if;
											end if;
										end if;
									
								end if;
								
							when ERROR_DEL =>
							
								if (error_transmisor_flag='1') then  
								
									if (transmisor_activo='0') then -- +1 EN EL CONTADOR_RECEPTOR SI SOMOS RECEPTOR
								
										CONTADOR_RECEPTOR <= CONTADOR_RECEPTOR+1; --REGLA 1
										estado <= ERROR_FLAG;
									else
										estado <=ERROR_FLAG;
									end if;	
									
								elsif (overload_transmisor_flag='1') then
								
									estado <= OVER_FLAG;

								elsif ( e=8 and bit_sin_relleno='1') then

									estado <= idle;
									
								end if;			

							when OVER_FLAG =>
							
								if (error_transmisor_flag='1' and modulo_errores_pas_flag_tmp='0') then --REGLAS 4 Y 5
								
										if (transmisor_activo='1') then
										
											CONTADOR_TRANSMISOR <= CONTADOR_TRANSMISOR +8;
										else
											CONTADOR_RECEPTOR <=  CONTADOR_RECEPTOR+8;
										end if;
										
										estado <= ERROR_FLAG;	
			
								elsif (overload_delimiter_flag='1') then
								
										estado <= OVER_DEL;
										
								elsif (flag_bits_sin_relleno='1') then --REGLA 6
								
									if (modulo_errores_pas_flag_tmp='0' and (cuenta_bits_dominantes-6)mod 8=0) then
										
											if (transmisor_activo='1') then
												
												CONTADOR_TRANSMISOR <= CONTADOR_TRANSMISOR+8;
											else
												CONTADOR_RECEPTOR <= CONTADOR_RECEPTOR +8;
											end if;
									end if;
								
								end if;		

							when OVER_DEL =>	
							
								if (error_transmisor_flag='1') then  
								
									if (transmisor_activo='0') then -- +1 EN EL CONTADOR_RECEPTOR SI SOMOS RECEPTOR
								
										CONTADOR_RECEPTOR <= CONTADOR_RECEPTOR+1; --REGLA 1
										estado <= ERROR_FLAG;
									else
										estado <=ERROR_FLAG;
									end if;
			
								elsif (overload_transmisor_flag='1') then
								
									estado <= OVER_FLAG;
									
								elsif ( e=8 and bit_sin_relleno='1') then

									estado <= idle;
								end if;	

							end case;
						end if;
				end if;
		end process;
	
end Behavioral;

