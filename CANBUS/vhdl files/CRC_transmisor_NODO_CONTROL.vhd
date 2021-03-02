----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:16:45 09/06/2020 
-- Design Name: 
-- Module Name:    CRC_transmisor - Behavioral 
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

entity CRC_transmisor_NODO_CONTROL is  --NODO 1 
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
		   ID_a_enviar : in STD_LOGIC_VECTOR( 10 downto 0);
		   mensaje_en_espera: in STD_LOGIC;
		   RTR_A_ENVIAR: in STD_LOGIC;
		   CRC_transmisor_ready: out STD_LOGIC:='0';
           byte_datos : in  STD_LOGIC_VECTOR (7 downto 0); 
           CRC_OUT : out  STD_LOGIC_VECTOR (14 downto 0):=(others=>'0'));
end CRC_transmisor_NODO_CONTROL;

architecture Behavioral of CRC_transmisor_NODO_CONTROL is

		type mis_estados is (idle,CRC_calculo,fin,bit_desplazado);
		signal estado_actual : mis_estados;
	
signal CRC_TEMP: STD_LOGIC_VECTOR ( 14 downto 0):= (others =>'0'); 
signal mensaje_completo: STD_LOGIC_VECTOR (26 downto 0):="000000000000000000100000000";  --suponemos 1 byte de datos SIEMPRE
signal byte_datos_previo : STD_LOGIC_VECTOR (7 downto 0);

signal i :integer :=0;
signal cuenta_total: integer:=0;

signal CRCNXT : STD_LOGIC :='0';

constant poli : STD_LOGIC_VECTOR(14 downto 0):="100010110011001"; --4599


begin

mensaje_completo(7 downto 0) <= byte_datos(7 downto 0);
mensaje_completo(25 downto 15) <= ID_a_enviar;
mensaje_completo(14) <= RTR_A_ENVIAR;

cuenta_total <= 27 when RTR_A_ENVIAR='0'
					else 19	;

		process(clk,reset) 
		
		begin
		
			if (reset ='1') then
			
				CRC_TEMP <= (others=>'0');
				CRCNXT <= '0';
				estado_actual <= idle;				
				i <=0;
				CRC_OUT <= (others => '0');
				CRC_transmisor_ready <= '0';
				 
				
			else
				
					if rising_edge (clk) then
					
						case estado_actual is
						
						when idle =>
						
							CRC_transmisor_ready <= '0';
										
							if (mensaje_en_espera='1'and i <cuenta_total) then
							
								estado_actual <= CRC_calculo;
				
							elsif (i=cuenta_total and mensaje_en_espera='0') then
								
								i <= 0;
								CRC_TEMP <= (others=>'0');
								CRCNXT <= '0';	
								CRC_OUT	<= (others=>'0');	
								CRC_transmisor_ready <= '1';
								
							end if;
							
						when CRC_calculo =>
							CRCNXT <= mensaje_completo(26-i) xor CRC_TEMP(14);
							CRC_TEMP(14 downto 1) <= CRC_TEMP(13 downto 0);  --SHIFT LEFT 1
							CRC_TEMP (0) <= '0';
							estado_actual <= bit_desplazado;
							
						when bit_desplazado =>

							if (CRCNXT='1') then
							
								CRC_TEMP <= CRC_TEMP xor poli;
								estado_actual <= fin;	
							else
								estado_actual <= fin;
							end if;
							
						when fin =>
						
							i <= i+1;
							
							if ( i=cuenta_total-1) then
								CRC_OUT <= CRC_TEMP;
								estado_actual <= idle;
							else
								estado_actual <= CRC_calculo;
							end if;	
								
							
		

						end case;
					end if;
				end if;		
				
		
		
		end process;
		
		
		

end Behavioral;