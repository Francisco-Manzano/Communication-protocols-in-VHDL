----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:51:24 08/24/2020 
-- Design Name: 
-- Module Name:    relleno_bits - Behavioral 
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

entity relleno_bits_receptor is  --QUITA EL BIT DE RELLENO DEL MENSAJE RECIBIDO
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           bit_recibido : in  STD_LOGIC;  --desde receptor
           flag_bit_recibido : in  STD_LOGIC;  --desde receptor
           bits_sin_relleno : out  STD_LOGIC;   --MENSAJE REAL SIN BITS DE RELLENO
		   aviso_bit_relleno: out STD_LOGIC; --TB
		   inicio_anticipado: in STD_LOGIC;  --si en el 3 bit de intermission detectamos el '0' de START
		   indicador_error : in STD_LOGIC:='0';  --DESDE OPERACION NOS DICE CUANDO HAY ERROR EN LA TRAMA
		   flag_bit_sin_relleno: out STD_LOGIC; 
           fin_bits : in  STD_LOGIC);  --CUANDO DEJAR DE REALIZAR LA OPERACION ;'1' PARA LA PARTE DEL MENSAJE SIN STUFFING O ERRORES
end relleno_bits_receptor;

architecture Behavioral of relleno_bits_receptor is


		type mis_estados is (idle,bit_out,contador,espera,parte_sin_relleno); 
		signal estado_actual: mis_estados;	

		signal bit0: integer range 0 to 5:=0;
		signal bit1: integer range 0 to 5:=0;		
		signal bit_anterior: std_logic :='0';

begin

			fases_relleno: process (clk,reset)

				begin
				
				if (reset='1') then
				
					estado_actual <= idle;
					flag_bit_sin_relleno <='0';
					bit0 <=0;
					bit1 <=0;
					aviso_bit_relleno <='0';
				else

						if rising_edge(clk) then
						
							
							
								
									case estado_actual is
									
										when idle =>  
										
											if (inicio_anticipado='1') then 
											
												bit1 <= 0;
												bit0 <= 1;
										
											elsif (flag_bit_recibido='1') then  --bandera desde modulo receptor
											
												if (indicador_error='1') then --indicador de error en la trama
												
													bit0<=0;
													bit1<=0;
													estado_actual <=parte_sin_relleno;
											
												elsif (fin_bits='1') then --nos indica cuando estamos en parte del mensaje sin relleno
												
													if (bit0=5 or bit1=5)then --si los ultimos 5 bits antes de la parte sin relleno eran iguales,debemos obviar el siguiente
													
														estado_actual<=espera;
														bit0<=0;
														bit1<=0;
													else	
														bit0<=0;
														bit1<=0;
														estado_actual <=parte_sin_relleno;
													end if;
												else
												estado_actual <= bit_out;
												end if;
											else
												estado_actual <= idle;
												
											end if;
												
										when bit_out =>
										
											if (bit0=5 or bit1=5) then  --si tenemos 5 bit seguidos iguales obviamos el bit recibido
												
												estado_actual<= espera;
												bit0<=0;
												bit1<=0;
											else                      -- si no tenemos 5 bits seguidos iguales, enviamos el bit para su procesamiento

												bits_sin_relleno<= bit_recibido;
												flag_bit_sin_relleno <= '1';
												estado_actual <= contador;
											end if;
												
										when contador =>          --aumentamos en 1 el contador de bit0 o bit1 segun el valor del bit recibido
											
											if (bit_recibido='1') then
											
												bit1 <= bit1 + 1;
												bit0 <=0;
											else
												bit0 <= bit0 + 1;
												bit1 <= 0;
											end if;
											flag_bit_sin_relleno <= '0';
											estado_actual <=espera;
											
										when espera =>     --esperamos a que flag_bit_recibido sea 0 para iniciar un nuevo proceso

											flag_bit_sin_relleno <= '0';											
											if (flag_bit_recibido='0') then
											
												estado_actual<= idle;
											else
												estado_actual <= espera;
											end if;
											
										when parte_sin_relleno =>
										
											bits_sin_relleno<= bit_recibido;
											flag_bit_sin_relleno <= '1';
											estado_actual <= espera;
											

											
									end case;
							
						end if;
				end if;							
									
				
				
				
				end process;

							




end Behavioral;

