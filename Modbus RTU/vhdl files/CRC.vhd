----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:22:40 05/14/2020 
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

entity CRC is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
		   inicio_transmision: in STD_LOGIC;
           dato : in  integer;  --por aqui entran los parametros
		   numero_datos: in integer; --numero de bytes que tenemos si funcion 15 o 16
		   registro_actual : in integer;
		   flag_crcdone : out STD_LOGIC:= '0';
		   bytes_totales : out integer:=0;
		   LED_CRC: out std_logic:='0';
		   CRC_out : out unsigned(15 downto 0);  --para ver el CRC en el BCD
           trama_out : out  STD_LOGIC_VECTOR (120 downto 0):= (others =>'0'); --salida de datos hacia la uart
		   comando_actual: in STD_LOGIC_VECTOR (8 downto 0);
           funcion : in  integer);
end CRC;

architecture Behavioral of CRC is

type mis_estado is (idle, transmision1,transmision2,transmision3,transmision4,transmision5);
signal estado_actual : mis_estado;


signal ad_slave1,funcion2,numerodatos5: std_logic_vector (7 downto 0):= (others=>'0');
signal ad_dato3,datos4: std_logic_vector( 15 downto 0):= (others =>'0');
signal valordatos6_1B: STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
signal valordatos6_2B: STD_LOGIC_VECTOR (15 downto 0):=(others=>'0');
signal CRC_temp: unsigned (15 downto 0):= (others=> '0');
signal datos_temp,datos : STD_LOGIC_VECTOR (110 downto 0):= (others => '0');
signal bytescrc,bytescrcfin,i,cont: integer:=0;
signal contador:integer range 0 to 5000000:=0;
signal bitperdido : std_logic:='0';
constant A001 : std_logic_vector (15 downto 0) := "1010000000000001";



begin



   obtener_datos: process (comando_actual,inicio_transmision,dato,clk)
   
	begin
	
	if rising_edge(clk) then
	
		if (inicio_transmision='0')then
			
			if ( comando_actual="000000001") then
			datos_temp(7 downto 0) <= std_logic_vector(to_unsigned(dato, ad_slave1'length));
		    elsif ( comando_actual="000000010") then
			datos_temp(15 downto 8) <= std_logic_vector(to_unsigned(dato, funcion2'length));
			elsif ( comando_actual="0000000100") then
			datos_temp(31 downto 16) <= std_logic_vector(to_unsigned(dato, ad_dato3'length)); 
			elsif ( comando_actual="0000001000") then
			datos_temp(47 downto 32) <= std_logic_vector(to_unsigned(dato, datos4'length));  
			elsif ( comando_actual="0000010000") then
			datos_temp(55 downto 48) <= std_logic_vector(to_unsigned(dato, numerodatos5'length));
			elsif ( comando_actual="0000100000") then
				if (funcion=15) then
					datos_temp(56+7+(registro_actual-1)*8 downto 56+(registro_actual-1)*8) <= std_logic_vector(to_unsigned(dato, valordatos6_1B'length));
				elsif (funcion=16) then
					datos_temp(56+15+(registro_actual-1)*16 downto 56+(registro_actual-1)*16) <= std_logic_vector(to_unsigned(dato, valordatos6_2B'length));
				end if;
			end if;
	
			if (funcion=15 or funcion=16) then
		
					bytescrcfin <= 7 + numero_datos;
				else
					bytescrcfin <= 6;
			
			end if;
			
		end if;
			
	end if;
	
	end process;

   inicio_t: process (clk,reset,inicio_transmision)
	
	begin			
	    
		if (reset='1') then
		CRC_temp <= (others=>'0');
		estado_actual <=idle;
		bytes_totales<=0;
		contador<=0;		
		else
		
			if rising_edge (clk) then
				
				    case estado_actual is
					
						when idle =>
							CRC_temp <= (others=>'1');
							datos <= (others=>'0');
							contador<=0;
							cont <= 0;
							bytes_totales<=0;
							if (inicio_transmision='1') then
								if (contador<500000) then
									contador<= contador+1;
								else
									contador<=0;
									bytes_totales<= bytescrcfin+2;
									estado_actual<= transmision1;
									datos(15 downto 0) <= datos_temp(15 downto 0);
									datos(23 downto 16) <= datos_temp(31 downto 24);
									datos(31 downto 24) <= datos_temp(23 downto 16);
									datos(39 downto 32) <= datos_temp(47 downto 40);								
									datos(47 downto 40) <= datos_temp(39 downto 32);
									datos(110 downto 48) <= datos_temp(110 downto 48); 
								end if;	
							end if;
							
						when transmision1 =>
						
								for i in 0 to 7 loop
							      CRC_temp(i) <= CRC_temp (i) xor datos (i+cont);
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
							if ( bytescrc= bytescrcfin) then
								flag_crcdone<='1';
								CRC_out <= CRC_temp;
								trama_out((bytescrcfin*8)-1 downto 0) <= datos ((bytescrcfin*8)-1 downto 0);
								trama_out((bytescrcfin*8)+7 downto (bytescrcfin*8))<= std_logic_vector(CRC_temp(7 downto 0));
								trama_out((bytescrcfin*8)+15 downto (bytescrcfin*8)+8)<= std_logic_vector(CRC_temp(15 downto 8));
								estado_actual<= transmision5;
							elsif (cont mod 8= 0) then
								estado_actual <= transmision1;
							else
								estado_actual <= transmision2;
							end if;
						when transmision5 =>
							flag_crcdone <='0';
							LED_CRC <='1';
							if (inicio_transmision='0') then
								bytescrc <=0;
								datos <= (others =>'0');
								if (contador<500000) then
									contador<=contador+1;
								else
									LED_CRC<='0';	
									contador<=0;
									estado_actual <= idle;
								end if;
								
								
							end if;
					
						
					end case;
					
			end if;
		end if;
	
		
	end process;

end Behavioral;

