----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:30:08 12/02/2020 
-- Design Name: 
-- Module Name:    CRC_TRANSMISOR_ESCLAVO - Behavioral 
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

entity CRC_TRANSMISOR_ESCLAVO is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           datos : in  STD_LOGIC_VECTOR (120 downto 0); --MENSAJE SIN CRC
           datos_out : out  STD_LOGIC_VECTOR (120 downto 0):=(others=>'0'); --MENSAJE COMPLETO CON CRC
           flag_CRC_transmisor : in  STD_LOGIC; --INICIO DE CRC
           bytes_CRC_transmisor : in  integer; --DESDE OPERACION PARA CALCULAR CRC
           bytes_totales_mensaje : out  integer; --PARA TX
           tx_inicio : out  STD_LOGIC); --BANDERA DE INICIO DE MENSAJE
end CRC_TRANSMISOR_ESCLAVO;

architecture Behavioral of CRC_TRANSMISOR_ESCLAVO is

type mis_estado is (idle, transmision1,transmision2,transmision3,transmision4,transmision5,transmision6,transmision7,transmision8); --CRC TRANSMISOR
signal estado_actual : mis_estado;


signal datos_recibidos_totales : STD_LOGIC_VECTOR (120 downto 0):= (others => '0');
signal datos_recibidos_totales_TMP : STD_LOGIC_VECTOR (120 downto 0):= (others => '0');
signal CRC_temp: UNSIGNED (15 downto 0):= (others=> '0');
signal bitperdido : std_logic:='0';
signal bytescrc,i,cont: integer:=0;
constant A001 : std_logic_vector (15 downto 0) := "1010000000000001";	
signal datos_tmp: std_logic_vector (120 downto 0):=(others=>'0');
SIGNAL FLAG_CRC_TRANSMISOR_calculado: STD_LOGIC;
signal CRC_TRANSMISOR_CALCULADO: STD_LOGIC_VECTOR(15 downto 0):=(others=>'0');
			
begin





calcula_CRC_TRANSMISOR: process (clk,reset)  
		
		begin
		
			if (reset='1') then
			
				CRC_temp <= (others=>'0');
				cont <= 0;
				bytescrc <=0;
				FLAG_CRC_TRANSMISOR_calculado <= '0';
				CRC_TRANSMISOR_CALCULADO <=(others=>'0');
				tx_inicio <='0';
				
			else
			
			if rising_edge (clk) then
			
					 case estado_actual is
					
						when idle =>
						
							datos_tmp <= datos;
						
							if (flag_CRC_transmisor = '1' ) then
							
								estado_actual<= transmision1;
							else
								estado_actual<= idle;
							end if;
							
							CRC_temp <= (others=>'1');
							cont <= 0;
							bytescrc <=0;
							tx_inicio <='0';
							
							
						when transmision1 =>
						
							for i in 0 to 7 loop
							     CRC_temp(i) <= CRC_temp (i) xor datos_tmp (i+cont);
							end loop;
																
							estado_actual <= transmision2;

						when transmision2 =>
						
							CRC_temp <= shift_right(unsigned(CRC_temp), 1);
							bitperdido <= CRC_temp(0);
							cont <= cont+1;
							estado_actual <= transmision3;	

						when transmision3 =>
							if (bitperdido='1') then
								for i in 0 to 15 loop
							      CRC_temp(i) <= CRC_temp (i) xor A001 (i);
								end loop;
							end if;	
							if (cont mod 8 = 0) then
								bytescrc <= bytescrc +1;							
							end if;
							estado_actual<= transmision4;

						when transmision4 =>
						
							if ( bytescrc= bytes_CRC_transmisor) then							
								FLAG_CRC_TRANSMISOR_calculado <='1';																
								estado_actual<= transmision5;
							elsif (cont mod 8= 0) then
								estado_actual <= transmision1;
							else
								estado_actual <= transmision2;
							end if;
						
						when transmision5 =>
							CRC_TRANSMISOR_CALCULADO <= std_logic_vector(CRC_temp);
							FLAG_CRC_TRANSMISOR_calculado <='0';	
							estado_actual <= transmision6;
							
						when transmision6 =>

							CRC_TRANSMISOR_CALCULADO(15 downto 8) <= CRC_TRANSMISOR_CALCULADO(7 downto 0);
							CRC_TRANSMISOR_CALCULADO(7 downto 0) <= CRC_TRANSMISOR_CALCULADO(15 downto 8);
							estado_actual <= transmision7;
							
						when transmision7 =>
						
								datos_tmp(bytes_CRC_transmisor*8+7 downto bytes_CRC_transmisor*8) <= CRC_TRANSMISOR_CALCULADO(7 downto 0);
								datos_tmp(bytes_CRC_transmisor*8+15 downto bytes_CRC_transmisor*8+8) <= CRC_TRANSMISOR_CALCULADO(15 downto 8);
							
							estado_actual <= transmision8;
							
						when transmision8 =>

							bytes_totales_mensaje <= bytes_CRC_transmisor+2;
							datos_out <= datos_tmp;
							tx_inicio <='1';
							
							estado_actual <= idle;
							
							
					end case;
					
				end if;
		end if;
	
		
	end process;





end Behavioral;

