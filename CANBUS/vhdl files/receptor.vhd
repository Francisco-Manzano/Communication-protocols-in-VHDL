----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:46:18 08/24/2020 
-- Design Name: 
-- Module Name:    receptor - Behavioral 
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

entity receptor is
    Port ( clk10Mhz : in  STD_LOGIC; --100ns periodo
		   clk : in STD_LOGIC;	
           reset : in  STD_LOGIC;
           rx : in  STD_LOGIC;
		   bus_idle: in STD_LOGIC;  --desde operacion para que receptor vuelva a idle
		   inicio_recepcion: out STD_LOGIC:='0'; --va a operacion para indicar mensaje entrante
		   flag_bit_recibido : out STD_LOGIC:='0'; 
		   flag_tiempo_bit : out STD_LOGIC:= '0'; --marca el inicio de cada bit recibido
		   flag_test : out STD_LOGIC :='0'; --TB PARA COMPROBAR SI PHASE_SEG_2 SE ACORTA AL DETECTAR BIT EDGE
		   flag_test_2 : out STD_LOGIC :='0'; --TB PARA COMPROBAR SI PHASE_SEG_1 SE ALARGA AL DETECTAR BIT EDGE
           bit_recibido : out  STD_LOGIC:='1');
		   
end receptor;

architecture Behavioral of receptor is


    type mis_estados is (idle,sync_seg_estado,prop_seg_estado,phase_seg1_estado,phase_seg2_estado); 
	signal estado_sinc : mis_estados;
	
	--BIT TIME 1 us  
	-- TIME QUANTUM 100 ns
	
	signal  sync_seg : integer :=5;
	signal prop_seg: integer :=25;  --5 time quanta  segun valores calculados
	signal phase_seg1: integer :=10;  --2 time quanta segun valores calculados 
	signal phase_seg2: integer :=10;  --2 time quanta segun valores calculados
	signal i: integer :=0;
	signal flag_inicio_bit,flag_sync_seg_fin : STD_LOGIC :='0';  --TB
	signal rx_delay : std_logic := '0'; 
	signal rx_falling : std_logic;
	signal sdsdsdsd: std_logic_vector (5 downto 0);

begin

rx_delay <= rx when rising_edge(clk) ; 
rx_falling <=  rx_delay and not rx;  --transicion de '1' a '0'


		sincronizacion : process (clk,reset,bus_idle)
		
			begin
			
					if (reset ='1' or bus_idle='1') then
					
					estado_sinc <= idle;
					i <= 0;
					sync_seg <= 5;
					phase_seg1 <= 10;
					phase_seg2 <= 10;
					prop_seg <= 25;
					flag_bit_recibido <= '0';
					flag_sync_seg_fin <= '0';
					flag_tiempo_bit <= '0';
					flag_test <= '0';
					flag_test_2 <= '0';
					inicio_recepcion <= '0';
					
					
					else 
					
					
					
							if rising_edge (clk) then
							
								case estado_sinc is
								
									when idle =>
								
										if (rx_falling ='1') then
											inicio_recepcion <= '1';
											estado_sinc <=sync_seg_estado;
											flag_tiempo_bit <= '1';
										
										end if;
										
									when sync_seg_estado =>  --1 time quanta 100 ns
									
										inicio_recepcion <= '0';
										flag_test <= '0';		
										flag_tiempo_bit <= '0';
										
										if (sync_seg=1) then
											sync_seg <= 5;
											estado_sinc <=prop_seg_estado;
											flag_sync_seg_fin <= '1';
										else
											sync_seg<= sync_seg-1;
										end if;	
										
									when prop_seg_estado =>  -- 5 time quanta 500 ns
										flag_test_2 <= '1';
										flag_sync_seg_fin <= '0';
										flag_tiempo_bit <= '0';
									
										if (rx_falling ='1') then --si hay retraso en el bit edge ( deberia cambiar en sync_seg)
											flag_test_2 <= '0';
											flag_tiempo_bit <= '1';
											prop_seg <= prop_seg -1;
											phase_seg1 <= phase_seg1 + i+1;  --anadimos tantos time quanta a phase_seg1 como se haya retrasado
											
										elsif (prop_seg=1) then
											flag_test_2 <= '0';
											estado_sinc <= phase_seg1_estado;
											i <=0;
											prop_seg <= 25;
										else
											
											prop_seg <= prop_seg -1;
											if (i<10) then --maximo retraso para el bit sample
											
												i <= i+1;
											end if;
										end if;
										
										
									when phase_seg1_estado => -- 2 time quanta 200 ns
											
										if (phase_seg1=1) then
										
											estado_sinc <= phase_seg2_estado;
											phase_seg1 <= 10;
											flag_bit_recibido <= '1';
											bit_recibido <= rx; 
										else
											phase_seg1 <= phase_seg1 -1;
											flag_test <= '1';
										end if;
											
									when phase_seg2_estado => -- 2 time quanta 200 ns
									
											flag_test <= '0';				
											flag_bit_recibido <= '0';
											
											if (bus_idle='1') then
											
												estado_sinc <= idle;
												phase_seg2 <=10;
												
												
											elsif (rx_falling ='1') then --si hay adelanto en el bit edge (deberia cambiar en sync_seg)
												flag_tiempo_bit <= '1';
												estado_sinc <=sync_seg_estado;  --pasamos directamente a sync_seg
												phase_seg2 <= 10;
											
											elsif (phase_seg2= 1) then
											
												estado_sinc <=sync_seg_estado;
												phase_seg2 <= 10;
												
											else

												phase_seg2 <= phase_seg2-1;
												
											end if;	
								end case;
							end if;		
										
					end if;
		
			end process;
			


end Behavioral;

