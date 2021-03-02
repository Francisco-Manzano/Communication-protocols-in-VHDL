----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:07:15 05/06/2020 
-- Design Name: 
-- Module Name:    unidad_control - Behavioral 
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

entity unidad_control is
    Port ( clk : in  STD_LOGIC;  --reloj1hz
           reset : in  STD_LOGIC;
		   switch_comando_siguiente_SR : in  STD_LOGIC;
		   switch_datos_recibidos_SR: in STD_LOGIC;
           switch_inicio_transmision_SR : in  STD_LOGIC;
           comando_actual : out  STD_LOGIC_VECTOR (8 downto 0):=(others=>'0'));
end unidad_control;

architecture Behavioral of unidad_control is

	type mis_estado is (idle,ad_slave,funcion,ad_dato,dato,numero_datos,valor_dato,transmision,datos_recibidos);
	signal estado_actual : mis_estado;

begin

				estado: process (clk,reset,switch_comando_siguiente_SR,switch_inicio_transmision_SR,switch_datos_recibidos_SR)


				begin
				
				if (reset='1') then		
					estado_actual <= idle;
					comando_actual <= "000000000";
				elsif (switch_datos_recibidos_SR='1') then
				   estado_actual <= datos_recibidos;
					comando_actual <= "010000000";	
				elsif (switch_inicio_transmision_SR='1') then
				   estado_actual <= transmision;
					comando_actual <= "001000000";
					
				else
					   if rising_edge (clk) then
							case estado_actual is
								when transmision =>
									if (switch_comando_siguiente_SR='1') then
									estado_actual <= idle;
									comando_actual <= "000000000";
									end if;
								when datos_recibidos =>
									 if (switch_comando_siguiente_SR='1') then
									estado_actual <= idle;
									comando_actual <= "000000000";
								     end if;
								when idle =>
									comando_actual <= "000000000";
									if (switch_comando_siguiente_SR='1') then
									estado_actual <= ad_slave;
									comando_actual <= "000000001";
									end if;
								when	ad_slave =>
									if (switch_comando_siguiente_SR='1') then
									estado_actual <= funcion;
									comando_actual <= "000000010";
									end if;
								when funcion =>
									if (switch_comando_siguiente_SR='1') then
									estado_actual <= ad_dato;
									comando_actual <= "000000100";
									end if;
								when ad_dato =>
									if (switch_comando_siguiente_SR='1') then
									estado_actual <= dato;
									comando_actual <= "000001000";
									end if;	
								when dato =>
									if (switch_comando_siguiente_SR='1') then
									estado_actual <= numero_datos;
									comando_actual <= "000010000";
									end if;
								when numero_datos =>
									if (switch_comando_siguiente_SR='1') then
									estado_actual <= valor_dato;
									comando_actual <= "000100000";
									end if;
								when valor_dato =>
									if (switch_comando_siguiente_SR='1') then
									estado_actual <= ad_slave;
									comando_actual <= "000000001";
									end if;
								end case;
							end if;
						end if;
									
						
				
				
				
				
				
				
				
				
				
				
				end process;
end Behavioral;

