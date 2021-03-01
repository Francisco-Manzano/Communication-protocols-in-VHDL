
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

entity unidad_operativa is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
		   management : in  STD_LOGIC;  --indica si se ha introducido algun PARAMETRO manualmente
		   dato_anadido : in STD_LOGIC; --indica si se ha introducido algun DATO manualmente
           dir_introducida : IN  STD_LOGIC_VECTOR (4 downto 0); --usuario ---
           dato_introducido : in  STD_LOGIC_VECTOR (4 downto 0); --usuario ---
		   dato_o_parametro : IN STD_LOGIC; --SEÑAL PARA ENVIAR AL BCD ARRAY DE DATOS O PARAMETROS ---
		   esclavo_no_conectado : OUT boolean:=false;  --PARA EL BCD
		   dato_a_mostrar : out STD_LOGIC_VECTOR (10 downto 0); --dato para el BCD 7s ---
           dato_completo : out  STD_LOGIC_VECTOR (10 downto 0); -- mensaje para el transmisor
           esclavo_off : in  STD_LOGIC_VECTOR (1 downto 0); --10 para detectado    01 para NO detectado (procede de la uart)
		   tx_inicio : out STD_LOGIC:='0';  -- inicio de uart_transmisor
		   fase_ciclica_datos : out STD_LOGIC:='0'; --TESTBENCH
		   fase_ciclica_iniciacion: out STD_LOGIC:='0'; --TESTBENCH
           dato_recibido : in  STD_LOGIC_VECTOR (3 downto 0)); --desde el uart_receptor
end unidad_operativa;

architecture Behavioral of unidad_operativa is


-- estados para las distintas fase del protocolo
	type mis_estados is (idle,iniciacion,deteccion1,deteccion2,deteccion3,deteccion4, activacion1,activacion2,datos1,datos2,
						mantenimiento1,mantenimiento2,iniciacion2,iniciacion3,iniciacion4,comprobacion,iniciacion5,iniciacion6); 
	signal estado_iniciacion : mis_estados;


-- estados para introduccion manual de dato/parametro
	type estados_introduccion is (inicio,p_recibido,d_recibido,d_recibido_fin,p_recibido_fin);
	signal manual : estados_introduccion;
	


--ARRAY PARA ESCLAVOS ACTIVOS	
  
	type arrays is array (1 to 31) of boolean;
	signal esclavo : arrays ;

--ARRAYS PARA ELEMENTOS DEL ESCLAVO
	
	type arrays2 is array (1 to 31) of std_logic_vector (3 downto 0);
	signal dato : arrays2 ;  --:=(others => "0000")
	signal ID_CODE : arrays2:=(others => "0000");
	signal IO_CODE : arrays2:=(others => "0000");
	signal parametro : arrays2:=(others => "1111") ;
	
--PARA DATO INTRODUCIDO MANUALMENTE

	signal param_finalizado,dato_finalizado : STD_LOGIC:= '0';
	signal dato_temp : arrays2 ;  --

--SEÑALES QUE MARCAN LA FASE DE GESTION
	
	signal management_temp,dato_anadido_temp : STD_LOGIC :='0';  -- INDICA QUE SE HA INTRODUCIDO UN PARAMETRO O DATO MANUALMENTE

------------------------------------------------------------------------	
	signal index: unsigned (4 downto 0):= "00001"; --de 1 a 31   31 POR CLICO PARA DATA_EXCHANGE
	
	--INCLUSION DE SUBORDINADOS
	signal index2: unsigned (4 downto 0):= "00000"; --de 0 a 31  1 POR CICLO PARA BUSCAR NUEVOS ESCLAVOS
	
	
	
	-- SEÑALES PARA NUEVOS ESCLAVOS DETECTADOS
	signal ID_CODE_temp : STD_LOGIC_VECTOR ( 3 downto 0):="0000";
	signal IO_CODE_temp : STD_LOGIC_VECTOR ( 3 downto 0):="0000";
	signal esclavo_temp : integer range 0 to 31:=0;  --DIRECCION DEL NUEVO ESCLAVO DETECTADO
	signal nuevo_esclavo_detectado : STD_LOGIC_VECTOR(1 downto 0):="00"; --AFECTA A LA FASE DE GESTION E INICIACION2
	signal esclavo_defectuoso : integer range 0 to 31:=0; -- DIRECCION DEL ESCLAVO DEFECTUOSO	
							  

begin

		visualizacion: process (clk,dato_o_parametro)
			begin
			
			if rising_edge (clk) then
			
				if (dato_o_parametro='0') then  --mostrar datos por el bcd
				
					esclavo_no_conectado <= esclavo(to_integer(unsigned(dir_introducida)));
					dato_a_mostrar(10) <='0';
					dato_a_mostrar(4) <='0';
					dato_a_mostrar(9 downto 5) <= dir_introducida;
					dato_a_mostrar(3 downto 0) <= dato(to_integer(unsigned(dir_introducida)));
					
				elsif 	(dato_o_parametro='1') then  --mostrar parametros por el bcd
				
					dato_a_mostrar(10) <='0';
					dato_a_mostrar(4) <='1';
					esclavo_no_conectado <= esclavo(to_integer(unsigned(dir_introducida)));
					dato_a_mostrar(9 downto 5) <= dir_introducida;
					dato_a_mostrar(3 downto 0) <= parametro(to_integer(unsigned(dir_introducida)));
				
				end if;
			end if;	
			
			end process;
		

	   parametro_in : process (clk,reset)
	   
		begin
			
			if (reset='1') then
			
				dato_temp<= (others=>"0000");
				manual <= inicio;
				
			else 

				if rising_edge (clk) then
				
						case manual is
				
							when inicio =>
				
								if  (management='1') then  --AVISO DE PARAMETRO INTRODUCIDO
								
									management_temp <= '1';
									manual <= p_recibido;
									
								elsif (dato_anadido='1') then  --AVISO DE DATO INTRODUCIDO
								
									dato_anadido_temp <='1';		
									dato_temp(to_integer(unsigned(dir_introducida))) <= dato_introducido( 3 downto 0);
									manual <= d_recibido;
								
								else 
									management_temp <= '0';
									manual <= inicio;
									dato_temp<= (others=>"0000");
								
								end if;	
					
							when p_recibido =>
								
								if (param_finalizado='1') then
									management_temp <='0';
									manual <= p_recibido_fin;
									
								else
									manual <= p_recibido;
									
								end if;
							when p_recibido_fin =>
							
									if (management='0') then
										manual<=inicio;
									else
										manual <= p_recibido_fin;
									end if;
										
							
							when d_recibido =>
							

								if (dato_finalizado='1') then
								
									dato_anadido_temp <='0';
									dato_temp(to_integer(unsigned(dir_introducida)))<="0000";
									manual <= d_recibido_fin;
											
								else
									manual <= d_recibido;
									
								end if;	
								
							when d_recibido_fin =>
							
								if (dato_anadido='0') then
									manual <= inicio;
											
								else
									manual <= d_recibido_fin;	
								end if;	
						end case;
				end if;	
			end if;
		
		end process;
	

		fases: process (clk,reset,esclavo_off)
		
		
			procedure contador_index (estado_siguiente : mis_estados;
							  estado_anterior : mis_estados;
							   signal cuenta : inout unsigned( 4 downto 0)) is
			begin
	
			if (cuenta = 31) then
				estado_iniciacion <= estado_siguiente;
				cuenta <= "00001";
				else	
				cuenta <= cuenta +1;
				estado_iniciacion <= estado_anterior;
			end if;
			end procedure;
		
			begin
			
			if (reset='1') then
			
				nuevo_esclavo_detectado <= "00";
				estado_iniciacion <= idle;
				dato_completo <= (others => '0');
				ID_CODE_temp <="0000";
				IO_CODE_temp <="0000";
				esclavo_temp <= 0;
				esclavo_defectuoso <= 0;
				param_finalizado <='0';
				dato_finalizado <='0';
				index <= "00001";
				ID_CODE <= (others => "0000");
				IO_CODE <= (others => "0000");
				esclavo <= (others => false);
				index2 <= "00000";
				fase_ciclica_datos <='0';
				dato <= (others=>"0000");
				fase_ciclica_iniciacion <='0';
			else
			
					if rising_edge(clk) then
		
						
						
							case estado_iniciacion is
								
								when idle =>
								
									estado_iniciacion <= iniciacion;
									
								when iniciacion =>  --VALORES POR DEFECTO
								
									esclavo <= (others=>false);
									dato <= (others=>"0000");
									parametro <= (others=>"1111");
									estado_iniciacion <= deteccion1;
									dato_completo <= (others=>'0');
									
								when deteccion1 =>  -- FUNCION ID_CODE PARA DETECTAR ESCLAVOS
									
									dato_completo <= (10=> '1',4 => '1',0 => '1',  others=>'0'); --CB=1 I=10001
									dato_completo( 9 downto 5) <=  std_logic_vector(index);
									tx_inicio <= '1';
									estado_iniciacion <= deteccion2;
									
								when deteccion2 =>  --AQUI SOLICITAMOS EL ID_CODE DEL ESCLAVO
								
									tx_inicio <= '0';
									if (esclavo_off = "00") then  --MIENTRAS NO HAY RESPUESTA PERMANECE AQUI
											
										estado_iniciacion <= deteccion2;
									
									elsif ( esclavo_off = "10" ) then  --SI SE DETECTA EL ESCLAVO
										
										ID_CODE(to_integer(index)) <= dato_recibido;  --ID_CODE DEL ESCLAVO
										esclavo(to_integer(index)) <= true;
										estado_iniciacion <= deteccion3;
									
									elsif (esclavo_off = "01" ) then  --SI NO SE DETECTA EL ESCLAVO
										
										esclavo(to_integer(index)) <= false;
										
										contador_index(activacion1,deteccion1,index);
									
										
									end if;	
								
								when deteccion3 =>  --AQUI SOLICITAMOS EL IO_CODE DEL ESCLAVO
								
									dato_completo <= (10=> '1',4 => '1', others=>'0'); --CB=1 I=10000
									dato_completo( 9 downto 5) <=  std_logic_vector(index);
									tx_inicio <= '1';
									estado_iniciacion <= deteccion4;
									
								when deteccion4 =>	
									
									tx_inicio <= '0';
									if (esclavo_off = "00") then  --MIENTRAS NO HAY RESPUESTA PERMANECE AQUI		
										estado_iniciacion <= deteccion4;
									
									elsif ( esclavo_off = "10" ) then  --SI SE DETECTA EL ESCLAVO	
										IO_CODE(to_integer(index)) <= dato_recibido;  --IO_CODE DEL ESCLAVO
	
										contador_index(activacion1,deteccion1,index);
										
										
									elsif (esclavo_off = "01" ) then  --SI NO SE DETECTA EL ESCLAVO		
										esclavo(to_integer(index)) <= false;
										ID_CODE(to_integer(index)) <= "0000";
										
										contador_index(activacion1,deteccion1,index);
												
									end if;	
							
								when activacion1 =>  --ENVIAMOS PARAMETROS POR DEFECTO PARA ACTIVAR LOS ESCLAVOS RECONOCIDOS
									
									if ( esclavo(to_integer(index)) = false) then
									
										contador_index(datos1,activacion1,index);
									
									else		
			
										dato_completo (4) <= '1'; --I4=1
										dato_completo (10) <= '0'; --CB=0
										dato_completo (3 downto 0) <= parametro(to_integer(index)); --CB=0 	
										dato_completo( 9 downto 5) <=  std_logic_vector(index);
										tx_inicio <= '1';
										estado_iniciacion <= activacion2;			
									end if;		
								
								when activacion2 =>
								
									tx_inicio <= '0';	
									if ( esclavo_off = "00" ) then   --ESPERAMOS LA RESPUESTA DEL ESCLAVO
										estado_iniciacion <=  activacion2;
									else 
									
										contador_index(datos1,activacion1,index);
									
										
										
									end if;
									
								
								when datos1 =>   --FUNCION DATA_EXCHANGE
									
									fase_ciclica_datos <= '1';
								
									if ( esclavo(to_integer(index)) = false) then
										
										contador_index(mantenimiento1,datos1,index);
										
									else	
									
										if(dato_anadido_temp='1') then
										
											if ( index=unsigned(dir_introducida)) then  
											
												dato_completo <= (10 => '0',4 => '0',others=>'0'); --CB=0 I4=0
												dato_completo( 3 downto 0) <= dato_temp(to_integer(index)); 
												dato_completo( 9 downto 5) <=  std_logic_vector(index);
												dato_finalizado<='1';
												tx_inicio <= '1';											
												estado_iniciacion <=  datos2;
											else	
												dato_completo <= (10 => '0',4 => '0',others=>'0'); --CB=0 I4=0
												dato_completo( 3 downto 0) <= dato(to_integer(index)); 
												dato_completo( 9 downto 5) <=  std_logic_vector(index);
												tx_inicio <= '1';
												estado_iniciacion <=  datos2;
											end if;
										else		
										
											dato_completo <= (10 => '0',4 => '0',others=>'0'); --CB=0 I4=0
											dato_completo( 3 downto 0) <= dato(to_integer(index)); 
											dato_completo( 9 downto 5) <=  std_logic_vector(index);
											tx_inicio <= '1';
											estado_iniciacion <=  datos2;
										
											
										end if;
									end if;
									
								when datos2 =>
								
									dato_finalizado<='0';
									
									tx_inicio <= '0';
									
									if (esclavo_off = "00") then  --MIENTRAS NO HAY RESPUESTA PERMANECE AQUI		
										estado_iniciacion <= datos2;
									
									elsif ( esclavo_off = "10" ) then		--SI SE DETECTA EL ESCLAVO	
									
										dato(to_integer(index)) <= dato_recibido;  -- DATOS RECIBIDOS DEL ESCLAVO
	
										contador_index(mantenimiento1,datos1,index);
										
										
									elsif (esclavo_off = "01" ) then  --SI NO SE DETECTA EL ESCLAVO		
										esclavo(to_integer(index)) <= false;
										dato(to_integer(index)) <= "0000";
										esclavo_defectuoso <= to_integer(index); --GUARDAMOS LA DIRECCION DEL ESCLAVO ROTO PARA COMPARAR CON UN POSIBLE NUEVO ESCLAVO IDENTICO
										contador_index(mantenimiento1,datos1,index);		
										-- MANTENEMOS ID_CODE Y IO_CODE POR SI APARECE UN NUEVO ESCLAVO (DIR "00000")IGUAL A ESTE
									end if;
									
								when mantenimiento1 =>
										
										fase_ciclica_datos <='0';
										param_finalizado <='0';
								
									
										if (nuevo_esclavo_detectado ="01") then --REQUERIMOS EL IO_CODE(fase2) (read IO_CODE)
										
												dato_completo(10) <= '1';
												dato_completo(9 downto 5) <= std_logic_vector(to_unsigned(esclavo_temp,5)); --direccion del nuevo esclavo detectado
												dato_completo(4 downto 0) <= "10000";
												tx_inicio <= '1';
												
												estado_iniciacion <= iniciacion4;
										
										elsif (nuevo_esclavo_detectado ="10")then ----SOLO SI ES "00000"  (PARA NUEVO ESCLAVO DETECTADO) (fase3)
										
												
												dato_completo(10) <= '0';
												dato_completo(9 downto 5) <= "00000"; --direccion "00000"
												dato_completo(4 downto 0) <= std_logic_vector(to_unsigned(esclavo_defectuoso,5));
												tx_inicio <= '1';
												estado_iniciacion <= iniciacion5;
												
												
										elsif (nuevo_esclavo_detectado ="11")then --- ENVIA PARAMETROS (PARA ACTIVAR NUEVO ESCLAVO DETECTADO)  (fase4)
										
												dato_completo(10) <= '0';
												dato_completo(9 downto 5) <= std_logic_vector(to_unsigned(esclavo_temp,5)); --direccion asignada en fase1
												dato_completo(4 downto 0) <= "11111";
												tx_inicio <= '1';
												estado_iniciacion <= iniciacion6;		
										
											
								
										elsif (management_temp='1') then --SI SE HA INTRODUCIDO UN PARAMETRO
									
												
												dato_completo(10) <= '0';
												dato_completo(9 downto 5) <= dir_introducida;
												dato_completo(4 downto 0) <= dato_introducido;
												tx_inicio <= '1';
												estado_iniciacion <= mantenimiento2;	
									
										else
											
											estado_iniciacion <= iniciacion2;
												
										end if;
										
								when mantenimiento2	=> --para write_parameter 
									tx_inicio <= '0';
									param_finalizado <='1';
									if (esclavo_off = "00") then  --MIENTRAS NO HAY RESPUESTA PERMANECE AQUI		
										estado_iniciacion <= mantenimiento2;
										
									else	
										parametro(to_integer(unsigned(dir_introducida))) <=dato_recibido; --PARAMETRO RECIBIDO DESDE EL ESCLAVO
										estado_iniciacion <= iniciacion2;
								
									end if;	
															
								
								when iniciacion2 => --ID_CODE PARA DETECTAR NUEVOS ESCLAVOS
								
									param_finalizado <='0';
									fase_ciclica_iniciacion <= '1';
								
									if (index2 ="00000") then
									
										dato_completo <= (10=> '1',4 => '1',0 => '1',  others=>'0'); --CB=1 I=10001
										dato_completo( 9 downto 5) <=  std_logic_vector(index2);
										tx_inicio <= '1';
										estado_iniciacion <= iniciacion3;
									
									else
									
											if (esclavo(to_integer(index2))= true) then
											
													if (index2 = 31) then	
														index2 <= "00000";
													else	
														index2 <= index2 +1;
													end if;
												estado_iniciacion <= iniciacion2;
											else	
					
												dato_completo <= (10=> '1',4 => '1',0 => '1',  others=>'0'); --CB=1 I=10001
												dato_completo( 9 downto 5) <=  std_logic_vector(index2);
												tx_inicio <= '1';
												estado_iniciacion <= iniciacion3;
											end if;
								
									end if;
						
						
						
						
								when iniciacion3 => --  --ESPERAMOS PARA VER SI HAY RESPUESTA DE UN NUEVO ESCLAVO
								
									fase_ciclica_iniciacion <= '0';
									tx_inicio <= '0';	
									if (esclavo_off = "00") then  --MIENTRAS NO HAY RESPUESTA PERMANECE AQUI
											
										estado_iniciacion <= iniciacion3;
									
									elsif ( esclavo_off = "10" ) then  --SI SE DETECTA EL ESCLAVO
										
										ID_CODE_temp <= dato_recibido;  --ID_CODE DEL ESCLAVO NUEVO
										esclavo_temp <= to_integer(index2) ;          --DIRECCION DEL ESCLAVO NUEVO
										estado_iniciacion <= datos1;
										nuevo_esclavo_detectado <="01";		
									
									elsif (esclavo_off = "01" ) then  --SI NO SE DETECTA EL ESCLAVO
										
										estado_iniciacion <= datos1;
											if (index2 = 31) then	
												index2 <= "00000";
											else	
												index2 <= index2 +1;
											end if;
									end if;		
										
								when iniciacion4 => --GUARDAMOS EL IO_CODE DEL ESCLAVO NUEVO

									tx_inicio <= '0';	
									if (esclavo_off = "00") then  --MIENTRAS NO HAY RESPUESTA PERMANECE AQUI
											
										estado_iniciacion <= iniciacion4;
									
									else
									
										IO_CODE_temp <= dato_recibido;  --IO_CODE DEL ESCLAVO NUEVO
										if (esclavo_temp=0) then  --SI LA DIRECCION ES "00000"
											nuevo_esclavo_detectado <="10";	
											estado_iniciacion <= comprobacion;
										else
											nuevo_esclavo_detectado <="11";	--SI LA DIRECCION ES DISTINTA DE "00000"
											estado_iniciacion <= datos1;
										end if;
										
										
									end if;									
								
								when comprobacion =>
										
										
									if ( ID_CODE(esclavo_defectuoso) = ID_CODE_temp) then
									
										if ( IO_CODE(esclavo_defectuoso) = IO_CODE_temp) then
										
											nuevo_esclavo_detectado <= "10";
											estado_iniciacion <= datos1;		
										else
											estado_iniciacion <= datos1;
											nuevo_esclavo_detectado <= "00";
											ID_CODE_temp <="0000";
											IO_CODE_temp <="0000";
											if (index2 = 31) then	
												index2 <= "00000";
											else	
												index2 <= index2 +1;
											end if;
										end if;
									
									else
										estado_iniciacion <= datos1;
										ID_CODE_temp <="0000";
										IO_CODE_temp <="0000";
										nuevo_esclavo_detectado <= "00";
										if (index2 = 31) then	
											index2 <= "00000";
										else	
											index2 <= index2 +1;
										end if;
									end if;
									
								
								when iniciacion5 =>  --ESPERAMOS RESPUESTA DE CAMBIO DE DIRECCION DEL ESCLAVO "00000"
								
									tx_inicio <= '0';	
									if (esclavo_off = "00") then  --MIENTRAS NO HAY RESPUESTA PERMANECE AQUI
											
										estado_iniciacion <= iniciacion5;
										
									else	
									
										if ( dato_recibido = "0110" ) then  --SI LA RESPUESTA DEL ESCLAVO ES VALIDA
										
											estado_iniciacion <= datos1;
											nuevo_esclavo_detectado <="11";
											esclavo_temp <= esclavo_defectuoso;	
									
										else                                 --SI LA RESPUESTA NO ES VALIDA
											nuevo_esclavo_detectado <="00";	
											estado_iniciacion <= datos1;
											ID_CODE_temp <="0000";
											IO_CODE_temp <="0000";
											
											if (index2 = 31) then	
												index2 <= "00000";
											else	
												index2 <= index2 +1;
											end if;
										end if;	
									end if;
									
								
							
								
								
								when iniciacion6 =>
								
									tx_inicio <= '0';	
									if (esclavo_off = "00") then  --MIENTRAS NO HAY RESPUESTA PERMANECE AQUI
											
										estado_iniciacion <= iniciacion6;
									
									else
									
										esclavo(esclavo_temp) <= true;
										ID_CODE(esclavo_temp) <= ID_CODE_temp;
										IO_CODE(esclavo_temp) <= IO_CODE_temp;
										nuevo_esclavo_detectado <="00";
										ID_CODE_temp <= "0000";
										IO_CODE_temp <=	"0000";	
										esclavo_temp <= 0;
										
											if (index2 = 31) then	
												index2 <= "00000";
											else	
												index2 <= index2 +1;
											end if;
										estado_iniciacion <= datos1;
									end if;
									
									
							end case;
							
						
						
					end if;
					
			end if;		
			
			end process;

		
				
			
			

end Behavioral;

