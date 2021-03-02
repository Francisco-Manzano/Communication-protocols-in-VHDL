----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:15:05 05/19/2020 
-- Design Name: 
-- Module Name:    recepcion_datos - Behavioral 
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

entity recepcion_datos is
    Port ( clk : in  STD_LOGIC;
		   clk1hz: in STD_LOGIC;
           reset : in  STD_LOGIC;
		   MAS : in STD_LOGIC;
           datos_recibidos : in  STD_LOGIC_VECTOR (7 downto 0);
		   CRC_done: in STD_LOGIC;
           rx_fin : in  STD_LOGIC; -- bandera de byte recibido 
           rx_fin_trama : in  STD_LOGIC; --bandera de fin de trama
		   dato_actual: out integer;
		   excepcion: out STD_LOGIC;  --BANDERA DE EXCEPCION
		   salida_datos: out integer);
end recepcion_datos;

architecture Behavioral of recepcion_datos is

type mem is array (0 to 9) of integer;
signal registro : mem:= (others =>0);

type mis_estados is (idle,inicio); 
signal estado_datos_rx : mis_estados;


signal datos_recibidos_int: STD_LOGIC_VECTOR(120 downto 0):=(others=>'0');
signal temp: STD_LOGIC_VECTOR(15 downto 0):=(others=>'0');
signal i,numero_bytes,funcion: integer:=0;
signal ii: integer:=1;


begin

numero_bytes <= to_integer(unsigned(datos_recibidos_int(23 downto 16)));
funcion <= to_integer(unsigned(datos_recibidos_int(15 downto 8)));
dato_actual<= ii;

	process (clk,reset,CRC_done,rx_fin,rx_fin_trama)
				
		begin
				
			if (reset='1') then
				datos_recibidos_int<=(others=>'0');
				estado_datos_rx<= idle;
				i<=0;		
			else	
				if rising_edge (clk) then	
					case estado_datos_rx is
						when idle =>
							i<=0;
							if (CRC_done='1') then
							estado_datos_rx<=inicio;
							end if;
						when inicio =>
							if (rx_fin='1')then
								datos_recibidos_int(i+7 downto i) <= datos_recibidos;
								i<= i+8;
								estado_datos_rx<=inicio;
							elsif (rx_fin_trama='1') then
								estado_datos_rx<=idle;
							end if;
					end case;							
				end if;			
			end if;				
			
		end process;
			
			
			
	 process(reset,funcion,clk,datos_recibidos_int)
		begin
			if (reset='1') then
				registro<=(others=>0);
			else 	
					if rising_edge (clk) then
						if (datos_recibidos_int(15)='1') then --EXCEPCIONES
								salida_datos <= to_integer(unsigned(datos_recibidos_int(23 downto 16)));
								excepcion<='1';
						else
							salida_datos <= registro(ii); --DATOS NORMALES
							excepcion<='0';
						end if;
						
						if (funcion=1 or funcion=2) then
							registro(ii) <= to_integer(unsigned(datos_recibidos_int(31+(ii-1)*8 downto 24+(ii-1)*8))); --SACAMOS 1 BYTE POR CICLO	
						elsif(funcion=3 or funcion=4) then
							temp(15 downto 8)<= datos_recibidos_int(31+(ii-1)*16 downto 24+(ii-1)*16);
							temp(7 downto 0)<= datos_recibidos_int(39+(ii-1)*16 downto 32+(ii-1)*16);
							registro(ii) <= to_integer(unsigned(temp)); --SACAMOS 2 BYTES POR CICLO
						elsif (funcion=5) then 
							temp(15 downto 8)<= datos_recibidos_int(39+(ii-1)*16 downto 32+(ii-1)*16);
							temp(7 downto 0)<= datos_recibidos_int(47+(ii-1)*16 downto 40+(ii-1)*16);
							registro(ii) <= to_integer(unsigned(temp)); --SACAMOS 2 BYTES POR CICLO
						end if;			
							
					end if;
			end if;
				
		end process;


	datos : process(clk1hz,funcion,reset)
		begin
			if (reset='1') then
				ii<=1;
			else	
				
				if rising_edge (clk1hz) then
				
						if (funcion=1 or funcion=2) then
							if (MAS = '0' and ii < numero_bytes) then ii <= ii + 1;
							elsif (MAS = '0' and ii = numero_bytes) then ii <= 1;	
							end if;
						elsif(funcion=3 or funcion=4) then
							if (MAS = '0' and ii < numero_bytes/2) then ii <= ii + 1;
							elsif (MAS = '0' and ii = numero_bytes/2) then ii <= 1;
							end if;
						end if;	
				end if;			
			end if;		
		
		
		end process;

end Behavioral;

