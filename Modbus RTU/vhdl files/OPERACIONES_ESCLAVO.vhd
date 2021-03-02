----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:49:53 12/01/2020 
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

entity operaciones_ESCLAVO is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           numerobytes_recibidos : in  integer; --DEL RECEPTOR
           datos_recibidos : in  STD_LOGIC_VECTOR(7 downto 0); --DEL RECEPTOR
           flag_byte_recibido : in  STD_LOGIC; --DEL RECEPTOR
           flag_fin_recepcion : in  STD_LOGIC;--DEL RECEPTOR
           tx_inicio : out  STD_LOGIC:='0';  --AL TRANSMISOR Y
			SALIDA1 : out  STD_LOGIC:='0';
			SALIDA2 : out  STD_LOGIC:='0';
			SALIDA3 : out  STD_LOGIC:='0';
			SALIDA4 : out  STD_LOGIC:='0';
			ENTRADA1: IN std_logic;
			ENTRADA2: IN std_logic;
			ENTRADA3: IN std_logic;
			ENTRADA4: IN std_logic;
           datos_completos : out  STD_LOGIC_VECTOR (120 downto 0):=(others=>'0'); --- AL TRANSMISOR
           bytes_a_enviar : out  integer); --AL TRANSMISOR
end operaciones_ESCLAVO;

architecture Behavioral of operaciones_ESCLAVO is

type arrayy_datos is array (0 to 10) of std_logic;
signal array_salidas : arrayy_datos;
signal array_entradas : arrayy_datos:=(others=>'0');

type mis_estado is (idle, transmision1,transmision2,transmision3,transmision4,transmision5); --CRC receptor
signal estado_actual : mis_estado;

type mis_estados is (idle,almacena_datos,CRC_giro); --SACA DATOS DEL VECTOR
signal vector_datos : mis_estados;

type mis_estados2 is (idle,compara_direccion_esc,compara_CRC);  --COMPARA DIRECCION DE ESCLAVO Y CRC
signal estado_comparador : mis_estados2;

type mis_estados3 is (idle,funcion5,funcion15,funcion_15_2);  -- ACTIVA SALIDAS
signal activa_salidas : mis_estados3;

type mis_estados5 is (idle,excepcion1,excepcion2,respuesta_excepcion);  -- EXCEPCIONES
signal estado_excepcion : mis_estados5;

type mis_estados4 is (idle,caso_excepcion,id_y_funcion,bytes_a_seguir,entrada_salida,entrada_salida_1_2,entrada_salida_2,entrada_salida_3,entrada_salida_4,direccion_primer_dato,activa_CRC_TRANSMISOR);  -- prepara respuesta para transmisor
signal prepara_respuesta : mis_estados4;



constant DIRECCION_MIA: std_logic_vector (7 downto 0):="00000001";


signal datos_recibidos_totales : STD_LOGIC_VECTOR (120 downto 0):= (others => '0');
signal datos_recibidos_totales_TMP : STD_LOGIC_VECTOR (120 downto 0):= (others => '0');
signal CRC_temp: UNSIGNED (15 downto 0):= (others=> '0');
signal bitperdido : std_logic:='0';
signal bytescrc,i,cont: integer:=0;
constant A001 : std_logic_vector (15 downto 0) := "1010000000000001";	


signal e : integer range 0 to 113; --guarda datos

signal CRC_RECIBIDO: STD_LOGIC_VECTOR (15 downto 0):= (others=> '0');
signal CRC_receptor_CALCULADO: UNSIGNED (15 downto 0):= (others=> '0');
signal FLAG_CRC_RECEPTOR_CALCULADO: std_logic;
signal funcion_recibida: std_logic_vector(7 downto 0);
signal funcion_recibida_int : integer;
signal bits_totales_recibidos: integer:=1;

signal direccion_recibida_mem: STD_LOGIC_VECTOR (15 downto 0):= (others=> '0'); --direccion en memoria
signal direccion_recibida_mem_int : integer;
signal valor_recibido: STD_LOGIC_VECTOR (63 downto 0):= (others=> '0');   --dato recibido
signal bobinas_a_modificar: STD_LOGIC_VECTOR (15 downto 0):=(others=>'0');
signal bobinas_a_modificar_int: integer;
signal b: integer;
signal registros_a_modificar: STD_LOGIC_VECTOR (15 downto 0):=(others =>'0');
signal direccion_recibida_esclavo: STD_LOGIC_VECTOR (7 downto 0):= (others=> '0'); --direccion del esclavo
signal flag_salidas_modificadas: STD_LOGIC;

signal datos_a_enviar: STD_LOGIC_VECTOR(120 downto 0):=(others => '0');
signal dato:  STD_LOGIC_VECTOR(120 downto 0):=(others => '0');
signal dato_sin_signo: unsigned(120 downto 0):= (others => '0');

signal CRC_RECIBIDO_FLAG: std_logic:='0';
signal flag_mensaje_valido: std_logic:='0';
signal FLAG_CRC_TRANSMISOR: STD_LOGIC:='0';
signal flag_CRC_VALIDO: std_logic:='0';
signal bytes_crc_transmisor: integer;
signal d: integer;

signal mensaje_excepcion : std_logic_vector (23 downto 0);
signal flag_excepcion : std_logic;


COMPONENT CRC_TRANSMISOR_ESCLAVO
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		datos : IN std_logic_vector(120 downto 0);
		flag_CRC_transmisor : IN std_logic;
		bytes_CRC_transmisor : IN integer;          
		datos_out : OUT std_logic_vector(120 downto 0);
		bytes_totales_mensaje : OUT integer;
		tx_inicio : OUT std_logic
		);
	END COMPONENT;


begin

Inst_CRC_TRANSMISOR_ESCLAVO: CRC_TRANSMISOR_ESCLAVO PORT MAP(
		clk => clk,
		reset => reset,
		datos => dato,
		datos_out => datos_completos,
		flag_CRC_transmisor => flag_CRC_TRANSMISOR,
		bytes_CRC_transmisor => bytes_crc_transmisor,
		bytes_totales_mensaje => bytes_a_enviar,
		tx_inicio => tx_inicio
	);
		
direccion_recibida_mem_int <= to_integer(unsigned(direccion_recibida_mem));
bobinas_a_modificar_int <= to_integer(unsigned(bobinas_a_modificar));

SALIDA1 <= array_salidas(0);
SALIDA2 <= array_salidas(1);
SALIDA3 <= array_salidas(2);
SALIDA4 <= array_salidas(3);

array_entradas(0) <= ENTRADA1;
array_entradas(1) <= ENTRADA2;
array_entradas(2) <= ENTRADA3;
array_entradas(3) <= ENTRADA4;


funcion_recibida_int <= to_integer(unsigned(funcion_recibida));	

	
		almacenar_datos: process(clk,reset) -- 3º SE OBTIENEN LOS DATOS SEGUN FUNCION 
		begin
		
			if (reset='1') then
		
			CRC_RECIBIDO<=(others=>'0');
			direccion_recibida_mem<=(others=>'0'); 
			direccion_recibida_esclavo<=(others=>'0');
			valor_recibido <= (others=>'0');
			vector_datos <= idle;
			CRC_RECIBIDO_FLAG <= '0';
			bobinas_a_modificar <= (others=>'0');
			registros_a_modificar <=(others=>'0');
			bits_totales_recibidos <= 1;
			
			else
			
				if rising_edge(clk) then
				
					case vector_datos is
					
						when idle =>
						
							bits_totales_recibidos <= (numerobytes_recibidos*8)-1;
							CRC_RECIBIDO_FLAG <= '0';
						
							if (FLAG_CRC_RECEPTOR_CALCULADO='1') then
							
								vector_datos <=almacena_datos;
								datos_recibidos_totales <= datos_recibidos_totales_TMP;
								
								
							end if;

						when almacena_datos =>
						
							if (funcion_recibida_int < 7) then
							
								direccion_recibida_esclavo <= datos_recibidos_totales(7 downto 0);
								direccion_recibida_mem(15 downto 8) <= datos_recibidos_totales(23 downto 16);
								direccion_recibida_mem(7 downto 0) <= datos_recibidos_totales(31 downto 24);							
								valor_recibido(15 downto 8) <= datos_recibidos_totales( 39 downto 32);
								valor_recibido(7 downto 0) <= datos_recibidos_totales( 47 downto 40);
								CRC_RECIBIDO <= datos_recibidos_totales (63 downto 48); 
								vector_datos <= CRC_giro;
																
							elsif 	(funcion_recibida_int = 15) then 
							
								direccion_recibida_esclavo <= datos_recibidos_totales(7 downto 0);	
								direccion_recibida_mem(15 downto 8) <= datos_recibidos_totales(23 downto 16);
								direccion_recibida_mem(7 downto 0) <= datos_recibidos_totales(31 downto 24);
								CRC_RECIBIDO <= datos_recibidos_totales (79 downto 64);								
								bobinas_a_modificar(15 downto 8) <= datos_recibidos_totales (39 downto 32);
								bobinas_a_modificar(7 downto 0) <= datos_recibidos_totales (47 downto 40);
								valor_recibido(7 downto 0) <= datos_recibidos_totales (63 downto 56); --VALOR DE LAS BOBINAS SOLO ADMITE 1 BYTE
								vector_datos<= CRC_giro;
								
							elsif 	(funcion_recibida_int = 16) then 

									
									valor_recibido(31 downto 0) <= datos_recibidos_totales (47 downto 16);
									CRC_RECIBIDO <= datos_recibidos_totales (15 downto 0);	
									vector_datos<= CRC_giro;
									registros_a_modificar <= datos_recibidos_totales(47 downto 32);
									direccion_recibida_mem(15 downto 8) <= datos_recibidos_totales(23 downto 16);
									direccion_recibida_mem(7 downto 0) <= datos_recibidos_totales(31 downto 24);
									direccion_recibida_esclavo <= datos_recibidos_totales(7 downto 0);	
																				 
							end if;	
						
						when CRC_giro =>
						
								
								vector_datos <= idle;
								CRC_RECIBIDO_FLAG <= '1';
						
					end case;
							
				end if;
			end if;
				
		end process;
		
		modificar_salidas: process (clk,reset)  -- 6? SE MODIFICAN LAS SALIDAS (FUNCIONES 5 Y 15)
		
		begin
		
		if (reset='1') then
		
			array_salidas <= (others=>'0');
			b <= 0;
			flag_salidas_modificadas<= '0';
			else 
			
			if rising_edge(clk) then
			
				case activa_salidas is
				
					when idle =>
			
						flag_salidas_modificadas<= '0';
						if	(flag_mensaje_valido='1' and funcion_recibida_int=5) then		
				
								activa_salidas <= funcion5;
								
						elsif (flag_mensaje_valido='1' and funcion_recibida_int=15) then			
											
								activa_salidas <= funcion15;
						end if;
					
					when funcion5 =>

							if (valor_recibido(15)='1') then
							
								array_salidas(direccion_recibida_mem_int) <= '1';
							else							
								array_salidas(direccion_recibida_mem_int) <= '0';
							end if;
							flag_salidas_modificadas<= '1';
							activa_salidas <= idle;
							
					when funcion15 =>
					
							array_salidas(direccion_recibida_mem_int + b) <= valor_recibido(b);
							b <= b+1;
							activa_salidas <= funcion_15_2;
					
					when funcion_15_2 =>

							if ( b=bobinas_a_modificar) then
							
								b<=0;
								flag_salidas_modificadas<= '1';
								activa_salidas<=idle;
							else
								activa_salidas <= funcion15;
							end if;
				end case;
			end if;		
		end if;			
							
				
		end process;
		
		prepara_respuesta_transmision: process (clk,reset) -- 7? SE prepara la respuesta del esclavo
		
		
		
		begin
			
			if (reset='1') then
			
			flag_CRC_TRANSMISOR <='0';
			datos_a_enviar <= (others=>'0');
			d <= 0;
			bytes_crc_transmisor <= 0;
			
		else
		
			if rising_edge(clk) then
			
				case prepara_respuesta is
				
				when idle =>
				
					flag_CRC_TRANSMISOR <=  '0';
					
					if (flag_mensaje_valido='1') then
					
						prepara_respuesta <= id_y_funcion;
						
					elsif (flag_excepcion='1') then

						prepara_respuesta <= caso_excepcion;
						
					end if;	
					
				when id_y_funcion =>
	
							dato (7 downto 0) <= direccion_recibida_esclavo;
							dato (15 downto 8) <= funcion_recibida ;	
					
					if (funcion_recibida_int=1 or funcion_recibida_int=2) then
					
						prepara_respuesta <=bytes_a_seguir;
						
					elsif (funcion_recibida_int=5 or funcion_recibida_int=15) then
					
						prepara_respuesta <= direccion_primer_dato;
					else
						prepara_respuesta <= idle;
					end if;

				when bytes_a_seguir =>
					
							dato (23 downto 16) <= "00000001";
					
						prepara_respuesta <= entrada_salida;
						
				when entrada_salida =>
				
					if (d= 8) then
					
						prepara_respuesta <=entrada_salida_1_2;
						d <= 0;
					
					elsif (funcion_recibida_int=1) then									
					
							dato(24+d) <= array_salidas(d); 
							d <= d+1;	
						
					elsif (funcion_recibida_int=2) then
									
							dato(24+d) <= array_entradas(d); 
							d <= d+1;	
					
					end if;
				when entrada_salida_1_2 =>
				
						dato_sin_signo <=unsigned(dato);
						prepara_respuesta<=entrada_salida_2;
						
				when entrada_salida_2 =>

					dato_sin_signo(31 downto 24) <= shift_right(unsigned(dato_sin_signo(31 downto 24) ), direccion_recibida_mem_int);
					prepara_respuesta <= entrada_salida_3;
					
				when entrada_salida_3 =>
				
				dato_sin_signo(31 downto 24+to_integer(unsigned(valor_recibido)))<= (others=>'0');
				bytes_crc_transmisor <= 4;
				prepara_respuesta <= entrada_salida_4;
				
				when entrada_salida_4 =>
				
					dato <= std_logic_vector(dato_sin_signo);
					prepara_respuesta <= activa_CRC_TRANSMISOR;
					
				when direccion_primer_dato	=>  --DIRECCION DE MEMORIA Y DATO DE RESPUESTA ORDEN 5 Y 15
				
					prepara_respuesta <= activa_CRC_TRANSMISOR;
					bytes_crc_transmisor <= 6;
					for i in 0 to 7 loop
					
						dato (16+i) <= direccion_recibida_mem(i+8);
						dato (16+i+8) <= direccion_recibida_mem(i);
					
					end loop;
					
					if (funcion_recibida_int=5) then
					
						if (valor_recibido(15)='1') then
						
							dato (47 downto 32) <= X"00FF";
						else
							dato (47 downto 32) <= X"0000";
						end if;
					
					elsif (funcion_recibida_int=15) then
					
						for i in 0 to 15 loop
						
						dato(32+i) <= bobinas_a_modificar(i);
						
						end loop;
					
					end if;	
					
				when caso_excepcion =>

					dato <= (others=>'0');
					dato (23 downto 0) <= mensaje_excepcion;
					bytes_CRC_transmisor <= 3;
					prepara_respuesta <=activa_CRC_TRANSMISOR;
					
				when activa_CRC_TRANSMISOR =>
				
						flag_CRC_TRANSMISOR <= '1';
						prepara_respuesta <= idle;
			
				end case;	
			end if;
		end if;	
				
					
		end process;
		
		
		excepciones: process (clk,reset) -- 5? COMPRUEBA EXCEPCIONES
		begin
		
		if (reset='1') then
		
			flag_mensaje_valido <='0';
			estado_excepcion<= idle;
			mensaje_excepcion <=(others => '0');
			flag_excepcion <= '0';
		
		else
		
			if rising_edge(clk) then
			
				case estado_excepcion is
				
				
					when idle =>
					
						flag_excepcion <= '0';
						flag_mensaje_valido <='0';		
						if ( flag_CRC_VALIDO='1') then
							
							mensaje_excepcion(7 downto 0) <= direccion_recibida_esclavo;
							mensaje_excepcion (15 downto 8) <= funcion_recibida;
							mensaje_excepcion (15) <= '1';
							
							estado_excepcion <= excepcion1;
						else
							estado_excepcion <=idle;
						end if;
					
					when excepcion1 =>

						if (funcion_recibida_int=3 or funcion_recibida_int=4) then
						
							estado_excepcion <= respuesta_excepcion;
							mensaje_excepcion (23 downto 16) <= X"01";
							
						elsif (funcion_recibida_int > 5 and funcion_recibida_int<15) then	
						
							estado_excepcion <= respuesta_excepcion;
							mensaje_excepcion (23 downto 16) <= X"01";
							
						elsif (funcion_recibida_int > 15) then
							
							estado_excepcion <= respuesta_excepcion;
							mensaje_excepcion (23 downto 16) <= X"01";
							
						else 
							estado_excepcion <= excepcion2;
						end if;
							
					when excepcion2 =>

						if (funcion_recibida_int =1 or funcion_recibida_int =2)then
						
							if (direccion_recibida_mem_int+ to_integer(unsigned(valor_recibido)) > 8) then
								
								estado_excepcion <= respuesta_excepcion;
								mensaje_excepcion (23 downto 16) <= X"02";
							else
								estado_excepcion <= idle;
								flag_mensaje_valido <='1';
							end if;
							
								
						elsif 	(funcion_recibida_int =5) then
						
							if (direccion_recibida_mem_int > 7) then
							
								estado_excepcion <= respuesta_excepcion;
								mensaje_excepcion (23 downto 16) <= X"02";
							else
								estado_excepcion <= idle;
								flag_mensaje_valido <='1';
							end if;
							
						elsif (funcion_recibida_int =15) then
						
							if (direccion_recibida_mem_int+ to_integer(unsigned(bobinas_a_modificar)) > 8) then
							
								estado_excepcion <= respuesta_excepcion;
								mensaje_excepcion (23 downto 16) <= X"02";
							else
								estado_excepcion <= idle;
								flag_mensaje_valido <='1';
							end if;
						else
							estado_excepcion <= idle;
							flag_mensaje_valido <='1';
						end if;
							
					when respuesta_excepcion =>
					
						flag_excepcion <= '1';
						estado_excepcion <= idle;
						
				end case;
			end if;
		end if;		

						
						
						
		
		
		end process;
		
			
		
		guarda_datos: process (clk,reset)  --1 SE GUARDAN LOS DATOS Y LA FUNCION RECIBIDA
		
		begin
		
			if (reset='1') then
			
				datos_recibidos_totales_TMP <=(others=>'0');	
				e <= 0;	
				funcion_recibida <= (others=>'0');
			
			else
			
				if rising_edge (clk) then
				
					if (flag_byte_recibido= '1') then
						
						datos_recibidos_totales_TMP(e+7 downto e) <= datos_recibidos;
						e <= e +8;
						funcion_recibida <= datos_recibidos_totales_TMP (15 downto 8);
				
					elsif (flag_fin_recepcion = '1') then	
					
						e <= 0;												
					
					end if;	
				end if;
			end if;		


		end process;
		
		compara_direccion_CRC: process (clk,reset)	-- 4 SE COMPARA DIRECCION Y CRC
		begin
		
		if (reset='1') then
		
			estado_comparador <= idle;
			flag_CRC_VALIDO <= '0';
			
		else 

			if rising_edge(clk) then
			
				case estado_comparador is
				
					when idle =>
				
						flag_CRC_VALIDO <= '0';
						
						if (CRC_RECIBIDO_FLAG='1') then
						
							estado_comparador <= compara_direccion_esc;
						end if;
							
					when compara_direccion_esc =>
					
						if (DIRECCION_MIA = direccion_recibida_esclavo) then
						
							estado_comparador <= compara_CRC;
							
						else

							estado_comparador <= idle;
						end if;

					when compara_CRC =>

						if ( CRC_RECIBIDO = std_logic_vector(CRC_receptor_CALCULADO)) then
						
								flag_CRC_VALIDO <= '1';
								estado_comparador <= idle;
								
						else
								estado_comparador <=idle;
						end if;
						
				end case;	
			end if;
		end if;	
		
		
		end process;
					
		calcula_CRC_receptor: process (clk,reset)  --2 SE CALCULA EL CRC
		
		begin
		
			if (reset='1') then
			
				CRC_temp <= (others=>'0');
				CRC_receptor_CALCULADO <= (others=>'0');
				cont <= 0;
				bytescrc <=0;
				FLAG_CRC_RECEPTOR_CALCULADO <='0';	
				
			else
			
			if rising_edge (clk) then
			
					 case estado_actual is
					
						when idle =>
						
							if (flag_fin_recepcion = '1' ) then
							
								estado_actual<= transmision1;
							else
								estado_actual<= idle;
							end if;
							
							CRC_temp <= (others=>'1');
							cont <= 0;
							bytescrc <=0;
							
							
							
						when transmision1 =>
						
							for i in 0 to 7 loop
							     CRC_temp(i) <= CRC_temp (i) xor datos_recibidos_totales_TMP (i+cont);
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
						
							if ( bytescrc= numerobytes_recibidos-2) then							
								FLAG_CRC_RECEPTOR_CALCULADO <='1';																
								estado_actual<= transmision5;
							elsif (cont mod 8= 0) then
								estado_actual <= transmision1;
							else
								estado_actual <= transmision2;
							end if;
						
						when transmision5 =>
							CRC_receptor_CALCULADO <= CRC_temp;
							FLAG_CRC_RECEPTOR_CALCULADO <='0';	
							estado_actual <= idle;
								
					
					end case;
					
				end if;
		end if;
	
		
	end process;





end Behavioral;

