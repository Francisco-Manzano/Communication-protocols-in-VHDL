----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:30:59 08/20/2020 
-- Design Name: 
-- Module Name:    CRC - Behavioral 
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

entity CRC_receptor is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
		   flag_CRC_calc : in STD_LOGIC; --desde operacion para calcular el crc
		   flag_CRC_recibido: in STD_LOGIC; --flag crc recibido en la transmision
		   inicio_anticipado : in STD_LOGIC; -- si se inicia la transmision en el tercer bit de intermission
		   nuevo_stream_datos: in STD_LOGIC; --NUEVA TRANSMISION RECIBIDA
		   bit_CRC_in : in STD_LOGIC ; --bit para el calculo del CRC
           flag_CRC_error : out  STD_LOGIC:='0'); --flag de error de CRC
end CRC_receptor;

architecture Behavioral of CRC_receptor is

		type mis_estados is (idle,CRC_calculo,crc_copia,bit_desplazado);
		signal estado_actual : mis_estados;
	
signal CRC_TEMP: STD_LOGIC_VECTOR ( 14 downto 0):= (others =>'0');  
signal  CRC_RECIBIDO :STD_LOGIC_VECTOR (14 downto 0):="000000000000000";-- crc de la transmision recibida

signal i :integer :=0;

signal CRCNXT : STD_LOGIC :='0';

constant poli : STD_LOGIC_VECTOR(14 downto 0):="100010110011001"; --4599


begin

		process(clk,reset,nuevo_stream_datos) 
		
		begin
		
			if (reset ='1' or nuevo_stream_datos='1') then
			
				CRC_TEMP <= (others=>'0');
				CRCNXT <= '0';
				estado_actual <= idle;
				flag_CRC_error <= '0';
				i <=0;
				CRC_RECIBIDO<= (others=>'0');
			else
				
					if rising_edge (clk) then
					
						case estado_actual is
						
						when idle =>
										
							if (flag_CRC_calc='1') then
							
								estado_actual <= CRC_calculo;
								
							elsif (flag_CRC_recibido='1') then

								estado_actual <=  crc_copia;
							
							elsif ( inicio_anticipado='1') then

								flag_CRC_error <= '0';
								
							elsif (i=15) then
								
								i <= 0;
								CRCNXT <= '0';
								CRC_TEMP <= (others=>'0');
								CRC_RECIBIDO<= (others=>'0');

								if (CRC_RECIBIDO/=CRC_TEMP) then
								
									flag_CRC_error <= '1';
								else
									flag_CRC_error <= '0';
								end if;	
								
							end if;
							
						when CRC_calculo =>
							CRCNXT <= bit_CRC_in xor CRC_TEMP(14);
							CRC_TEMP(14 downto 1) <= CRC_TEMP(13 downto 0);  --SHIFT LEFT 1
							CRC_TEMP (0) <= '0';
							estado_actual <= bit_desplazado;
							
						when bit_desplazado =>

							if (CRCNXT='1') then
							
								CRC_TEMP <= CRC_TEMP xor poli;
								estado_actual <= idle;	
							else
								estado_actual <= idle;
							end if;
							
						when crc_copia =>
						
							i <= i+1;
							CRC_RECIBIDO(14- i) <= bit_CRC_in;			
							estado_actual <= idle;
		

						end case;
					end if;
				end if;		
				
		
		
		end process;
		
		
		
	



end Behavioral;

