----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:29:16 08/10/2020 
-- Design Name: 
-- Module Name:    transmisor_ESCLAVO - Behavioral 
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

entity transmisor_ESCLAVO is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
		   ticks : in  STD_LOGIC;
           tx_activado : in  STD_LOGIC;  --VIENE DE OPERACION
		   tx_activo : out STD_LOGIC:='0'; --esta transmitiendo
		   reset_cont_tx: out STD_LOGIC:='0'; --resetea contador de baudios
		   tx : out  STD_LOGIC:='0'; --linea de transmision
		   tx_fin : out  STD_LOGIC:='0'; --señal de mensaje enviado testbench
           datos_a_enviar : in  STD_LOGIC_VECTOR (3 downto 0));
end transmisor_ESCLAVO;

architecture Behavioral of transmisor_ESCLAVO is

	type mis_estado is (idle,bit_inicio,bit_datos,bit_paridad,bit_stop);
	signal estado_transmisor : mis_estado;
	signal datos_temp : std_logic_vector (3 downto 0); -- para evitar problemas de metaestabilidad
	signal ticks16 : unsigned (5 downto 0); -- 16 ticks para enviar cada bit		
	signal bit_index : integer range 0 to 3 :=0; -- 11 bits de datos enviados por mensaje


begin


		proceso_transmisor: process (clk,reset)
			variable paridad: std_logic:='0';
		begin
		
		
					
			if (reset='1') then
					
					estado_transmisor <= idle;
					ticks16 <= (others => '0');
					bit_index <= 0;
					reset_cont_tx <= '0';
					paridad := '0';
					
			else
				if rising_edge(clk) then
			
						
						case estado_transmisor is
						
							when idle =>
								paridad := '0';
								
								tx <= '1'; -- linea en alto para idle
								tx_activo <= '0';
								tx_fin <= '0';	
								bit_index <= 0;	
								ticks16<=(others => '0');
								datos_temp <= datos_a_enviar;
								if (tx_activado = '1') then
									
									tx_activo <= '1';
									reset_cont_tx <= '1';
									estado_transmisor <= bit_inicio;
										
								else
									estado_transmisor <= idle;
								end if;
								
							when bit_inicio =>		
								tx <= '0';  -- linea en bajo para inicio de transmision
								
								reset_cont_tx <= '0';
								
								if (ticks='1') then
									if (ticks16=15) then
									
										for i in 0 to 3 loop
										paridad := paridad xor datos_temp(i);
										end loop;
										
										estado_transmisor <= bit_datos;
										ticks16 <= (others => '0');
										bit_index <= 0;
									else 
										estado_transmisor <= bit_inicio;
										ticks16 <= ticks16+1;
									end if;
								end if;
							
							when bit_datos =>
								tx <= datos_temp(3-bit_index);	
								if (ticks='1') then
										if (ticks16=15) then
											ticks16 <= (others => '0');
											if (bit_index=3) then
												estado_transmisor <= bit_paridad;  
											else
												bit_index <= bit_index+1;
												estado_transmisor <= bit_datos;
											end if;
										else
											ticks16 <= ticks16+1;
										end if;
								end if;
		
		
							when bit_paridad =>
								tx <= paridad;
								if (ticks='1') then
										if (ticks16=15) then
											ticks16 <= (others => '0');
											estado_transmisor <= bit_stop;
										else
											ticks16 <= ticks16+1;
										end if;
								end if;
							
										
							when bit_stop =>
									
									tx <= '1';
									if (ticks='1') then
										if (ticks16=15) then
											estado_transmisor <= idle;
											
											ticks16 <= (others => '0');
											tx_fin <= '1';
											
										else
											ticks16 <= ticks16+1;
										end if;
									end if;
						end case;
				end if;		
		
			end if;
			
		end process;	
		
		
		
		
		
		
		
		
		
		
		
		
		
		








end Behavioral;

