
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

entity controles is
    Port ( 
           clk_1_hz : in  STD_LOGIC;
           reset : in  STD_LOGIC;    --SWITCH
           MAS : in  STD_LOGIC;     --BOTON activo a nivel bajo
           MENOS : in  STD_LOGIC;   --BOTON  activo a nivel bajo
           VISUALIZAR_ANADIR : in  STD_LOGIC; --SWITCH
           DATOS_PARAMETROS : in  STD_LOGIC;  --SWITCH
           OKAY : in  STD_LOGIC;              --SWITCH
		   dato_o_parametro : out STD_LOGIC :='0'; --INDICA A LA UNIDAD_OPERATIVA QUE ARRAY ENVIAR AL BCD
           dato_o_parametro_manual : out  STD_LOGIC_VECTOR (1 downto 0); --PARA FASE DE GESTION (MANUAL) ("01" para dato); "10" para parametro
		   luz_manual : out STD_LOGIC :='0'; --DATO/PARAMETRO INTRODUCIDO
		   senal_para_bcd : out STD_LOGIC :='0';   --INDICA AL BCD SI MOSTRAR LOS ARRAYS DE LA UNIDAD OP. O EL DATO QUE ESTAMOS INTRODUCIENDO
           dir_introducida : out  STD_LOGIC_VECTOR (4 downto 0):="00001";
           dato_introducido : out  STD_LOGIC_VECTOR (4 downto 0));
end controles;

architecture Behavioral of controles is

	type estado_botones is (mostrar_datos,mostrar_parametros,introd_dato,introd_dato2,introd_parametro,introd_parametro2);

	signal estado_actual : estado_botones;
	signal cnt_sig : integer range 1 to 31 :=1;
	signal cnt_manual : integer range 0 to 15;

begin



			estado: process (reset,clk_1_hz)
			
			procedure contador_index (masS : in STD_LOGIC;
									  menosS :in STD_LOGIC;	
									  signal cuenta : inout integer range 1 to 31) is
									  
			constant max: integer :=31;
			
			begin

				if (masS = '0' and cuenta < max) then cuenta <= cuenta + 1;
				elsif (masS = '0' and cuenta = max) then cuenta <= 1;
				elsif (menosS = '0' and cuenta > 1) then cuenta <= cuenta -1;
				elsif (menosS = '0' and cuenta = 1) then cuenta <= 31 ;
			    end if;
			
			end procedure;
			
			
			begin
			
				if (reset = '1') then 
					
					dir_introducida <= "00001";
					dato_introducido <="00000";
					dato_o_parametro <='0';
					dato_o_parametro_manual <= "00";
					estado_actual <= mostrar_datos;
					senal_para_bcd <='0';
					luz_manual <='0';
					cnt_sig <= 1;
					cnt_manual <=0;
				else
					
						if rising_edge (clk_1_hz) then
						
							case estado_actual is
							
								when mostrar_datos =>  --LE INDICA A OPERATIVA QUE MUESTRE ARRAY DE DATOS POR BCD
									
									dato_o_parametro <= '0'; 
									contador_index(MAS,MENOS,cnt_sig);
									dir_introducida <= std_logic_vector(to_unsigned(cnt_sig,5));
									
									if ( VISUALIZAR_ANADIR = '1') then
									
										estado_actual <= introd_dato;
									
									elsif ( DATOS_PARAMETROS ='1') then

										estado_actual <= mostrar_parametros;
										
									end if;	
										
								when mostrar_parametros =>  --LE INDICA A OPERATIVA QUE MUESTRE ARRAY DE PARAMETROS POR BCD

									dato_o_parametro <= '1'; 
									contador_index(MAS,MENOS,cnt_sig);
									dir_introducida <= std_logic_vector(to_unsigned(cnt_sig,5));
									
									if  ( DATOS_PARAMETROS ='0') then
									
										estado_actual <= mostrar_datos;
									
									elsif (	VISUALIZAR_ANADIR = '1') then
										
										estado_actual <= introd_parametro;
									end if;
										
								when introd_dato => --LE INDICA AL BCD QUE VISUALICE ESTOS DATOS
									
									dir_introducida <= std_logic_vector(to_unsigned(cnt_sig,5));
									senal_para_bcd <= '1';
									dato_introducido(4) <= '0';
									dato_introducido(3 downto 0) <= std_logic_vector(to_unsigned(cnt_manual,4));
									
									if (VISUALIZAR_ANADIR ='0') then
									
										estado_actual <= mostrar_datos;
										senal_para_bcd <= '0';
										dato_introducido <="00000";
										cnt_manual <= 0;
										
									elsif (OKAY ='1') then
									
										estado_actual <= introd_dato2;
										dato_o_parametro_manual <="01";
										luz_manual <='1';
									
									elsif (MAS = '0' and cnt_manual < 15) then cnt_manual <= cnt_manual + 1;
									elsif (MAS = '0' and cnt_manual = 15) then cnt_manual <= 0;
									elsif (MENOS = '0' and cnt_manual > 0) then cnt_manual <= cnt_manual -1;
									elsif (MENOS = '0' and cnt_manual = 0) then cnt_manual <= 15 ;
									end if;
									
								when introd_dato2 =>
								
									dato_o_parametro_manual <="00";

									if (VISUALIZAR_ANADIR ='0') then
									
										estado_actual <= mostrar_datos;
										luz_manual <='0';
										senal_para_bcd <= '0';
										dato_introducido <="00000";
										cnt_manual <= 0;
										
									end if;
									
								when introd_parametro => --LE INDICA AL BCD QUE VISUALICE ESTOS PARAMETROS
								
									dir_introducida <= std_logic_vector(to_unsigned(cnt_sig,5));
									senal_para_bcd <= '1';
									dato_introducido(4) <= '1';
									dato_introducido(3 downto 0) <= std_logic_vector(to_unsigned(cnt_manual,4));
									
									if (VISUALIZAR_ANADIR ='0') then
									
										estado_actual <= mostrar_parametros;
										senal_para_bcd <= '0';
										dato_introducido <="00000";
										cnt_manual <= 0;
										
									elsif (OKAY ='1') then
									
										estado_actual <= introd_parametro2;
										dato_o_parametro_manual <="10";
										luz_manual <='1';
									
									elsif (MAS = '0' and cnt_manual < 15) then cnt_manual <= cnt_manual + 1;
									elsif (MAS = '0' and cnt_manual = 15) then cnt_manual <= 0;
									elsif (MENOS = '0' and cnt_manual > 0) then cnt_manual <= cnt_manual -1;
									elsif (MENOS = '0' and cnt_manual = 0) then cnt_manual <= 15 ;
									end if;
									
								when introd_parametro2 =>

									dato_o_parametro_manual <="00";

									if (VISUALIZAR_ANADIR ='0') then
									
										estado_actual <= mostrar_parametros;
										luz_manual <='0';
										senal_para_bcd <= '0';
										dato_introducido <="00000";
										cnt_manual <= 0;
										
									end if;	
									
							end case;
							
						end if;
						
				end if;				
									
									
								
									
							
							
			
			
			end process;
			





end Behavioral;

