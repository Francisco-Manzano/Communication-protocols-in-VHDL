----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:23:01 08/25/2020 
-- Design Name: 
-- Module Name:    operaciones - Behavioral 
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

entity operaciones_NODO_CONTROL is

	
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
		   
		   introduccion_finalizada: in STD_LOGIC;--desde botonera
		   SALIDA_INTRODUCIDA : in STD_LOGIC_VECTOR(7 downto 0); -- --desde botonera
		   mostrar_entrada_salida: in STD_LOGIC; --desde botonera
		   ID_A_ENVIAR : in  STD_LOGIC_VECTOR (10 downto 0);--desde botonera
		   RTR_A_ENVIAR : in STD_LOGIC;--desde botonera		
		   DATO_A_MOSTRAR: out STD_LOGIC_VECTOR(7 downto 0); --al BCD
		   
           bit_sin_relleno : in  STD_LOGIC; --stream serie de bits sin relleno (RECEPTOR)
		   flag_tiempo_bit : in STD_LOGIC; --marca el tiempo de bit del bit recibido
           flag_bits_sin_relleno : in  STD_LOGIC; --desde modulo relleno_bits ( DESTUFFING) (RECEPTOR)
           bus_idle : out  STD_LOGIC;  --hacia receptor para espera en idle
		   inicio_recepcion: in STD_LOGIC;  --desde receptor (RECEPTOR)
		   indicador_error : out STD_LOGIC:='0';  --avisa a relleno_bits (RECEPTOR)
		   inicio_anticipado_out : out STD_LOGIC:='0'; --avisa a relleno_bits y stuff_error (RECEPTOR)
		   flag_bit_error : in STD_LOGIC;		--desde el modulo BIT_error (RECEPTOR)
		   flag_stuff_error: in STD_LOGIC:='0'; --desde el modulo stuff_error (RECEPTOR)
		   bits_totales : out integer:=0;  --bits que contiene el mensaje recibido sin stuffing
		   BIT_OUT: out  STD_LOGIC:='1'; --BIT TRANSMITIDO
           fin_bits : out  STD_LOGIC); --para que el modulo relleno_bits finalice
           
end operaciones_NODO_CONTROL;

architecture Behavioral of operaciones_NODO_CONTROL is

		type mis_estados is (idle,espera_sample,SOF,identificador,RTR,IDE,reservado,DLC,DATOS,CRC,CRC_FIN,ACK_SLOT,ACK_FIN,EOF,
							 overload_flag,overload_flag_2,overload_delimiter, intermission,ERROR_FLAG,ERROR_FLAG_2,ERROR_DELIMITER); 
		signal recepcion: mis_estados;
		
		type mis_estadoss is (idle,espera_banderas,espera_bit_time_id,espera_bit_time_ACK,espera_bit_time_idle,SOF,identificador,RTR,IDE,reservado,DLC,DATOS,CRC,CRC_FIN,ACK_SLOT,
								ACK_respuesta,ACK_FIN,EOF,suspend_transmission,overload_flag,overload_delimiter, intermission,ERROR_FLAG,ERROR_DELIMITER); 
		signal transmision: mis_estadoss;
		
		type stream is (espera_flag_relleno,espera_flag_relleno_2,compara,bytes_de_Datos,calculo_bits,compara2);
		signal estado_stream : stream;
		
		type aplica_salidas is (idle,mensaje_aceptado);
		signal  guarda_salidas: aplica_salidas;
		
		type mensaje_introd is (idle,mensaje_in,mensaje_validado);
		signal 	estado_mensaje : mensaje_introd;
		
		type datos_array is array (0 to 15) of std_logic_vector(7 downto 0);
		signal salidas : datos_array;
		signal entradas : datos_array;
							
	

	
--LA IDEA ES ENVIAR TRAMAS DE DATOS PARA MODIFICAR LAS SALIDAS Y TRAMAS REMOTAS PARA SOLICITAR LAS ENTRADAS	
	
	
	constant dlc_transmitido: STD_LOGIC_VECTOR (3 downto 0):="0001";	--tenemos 1 byte de dato por nodo
 
  signal e: integer; --recorre el array de datos recibidos
  signal t: integer:=0; --recorre el array de datos transmitidos
  
  signal i :integer;  --bits totales del mensaje recibido 
  signal numero_bytes_datos : integer; --de 0 a 8 bytes de datos recibidos
  signal bits_totales_temp: integer:=0; --bits recibidos hasta el momento
  shared variable datos_totales_temp: STD_LOGIC_VECTOR(0 to 107);
  signal bit_guardado : STD_LOGIC:='0'; --señal para utilizar los bits en otros procesos;
  signal nuevo_stream_datos: STD_LOGIC:='0';--señal para resetear el stream de datos anterior a espera del nuevo mensaje
  
  signal inicio_anticipado: STD_LOGIC:='0'; --por si se inicia la transmision en el tercer bit de intermission
  
  signal bus_idle_tmp : STD_LOGIC :='0';
  signal BUS_OFF: STD_LOGIC; --SI ES 1 EL NODO NO FUNCIONA
  signal cuenta: integer:=0; --espera a que el ultimo bit de intermission se reciba completamente
  signal ACK_respuesta_flag : STD_LOGIC:='0'; --respuesta '0' de ack si el mensaje es valido
  signal error_transmisor_flag : STD_LOGIC:='0'; --indicamos al transmisor que envie flag de error
  signal overload_delimiter_flag: STD_LOGIC:='0'; --indica al transmisor cuando pasar a OVERLOAD delimiter
  signal error_delimiter_flag: STD_LOGIC:='0'; --indica al transmisor cuando pasar a ERROR delimiter
  signal overload_transmisor_flag : STD_LOGIC:='0'; --indicamos al transmisor que envie flag de overload
  signal ACK_ERROR : STD_LOGIC:='0'; --indicamos al contador de error que el error se ha producido en el ACK
  signal bit_dominante: STD_LOGIC:='0'; --indicamos al contador de errores si hemos recibido un '0' durante el flag pasivo (REGLA 3.1)
  signal cuenta_bits_dominantes: integer:=0; --indicamos al contador de errores el numero de '0' consecutivos en ERROR O OVERLOAD (REGLA 6)
  
  signal modulo_errores_pas_flag: STD_LOGIC:='0';  --nos indica si estamos en modo error activo '0' o modo error pasivo '1'
   
  
  signal identificador_recibido: STD_LOGIC_VECTOR(10 downto 0):=(others => '0');
  signal RTR_RECIBIDO : STD_LOGIC:='0'; --por si tenemos que responder a una trama remota
  signal prioridad_perdida: STD_LOGIC:='0'; --flag por si perdemos prioridad
  signal datos_recibidos: STD_LOGIC_VECTOR(63 downto 0):=(others => '0'); --almacena los datos recibidos en el mensaje
  signal timer_ON: STD_LOGIC:='0'; --flag del tiempo de bit del bit recibido
  signal cuenta_ACK_respuesta: integer:=0;
  
 signal mensaje_en_espera: STD_LOGIC:='0';  --ES 1 SI  introducimos manualmente datos a enviar (nodo de control)
  signal bit_transmitido_previo_TMP: STD_LOGIC:='1'; --para el stuffing
  signal bit_transmitido: STD_LOGIC:='0'; -- bit enviado por el transmisor
  signal transmisor_activo: STD_LOGIC:='0'; -- indica si somos el emisor del mensaje actual
  signal timer_inicio_transmisor: STD_LOGIC; --marca el comienzo de la cuenta de tiempo de bit del transmisor
  signal flag_timer_transmisor: STD_LOGIC; --marca el final de cada bit ( y por tanto el inicio del siguiente)
  signal CRC_transmisor_ready: STD_LOGIC; --el CRC a enviar ha sido calculado y esta listo
  signal CRC_OUT: STD_LOGIC_VECTOR (14 downto 0); --CRC a enviar
  signal mensaje_a_enviar_CRC_incluido: STD_LOGIC_VECTOR ( 41 downto 0):="011111111111000000111111111000000000000000"; --
  signal stuff_cuenta: integer:=0;
  
	
  signal flag_crc_calc : STD_LOGIC:='0'; --indica al modulo CRC receptor que realice la operacion con el nuevo bit recibido
  signal bit_CRC_in : STD_LOGIC :='0'; --bit enviado al CRC PARA calculo de este
  signal flag_crc_recibido: STD_LOGIC:='0'; --indica al modulo CRC receptor que copie el bit recibido
  signal flag_CRC_error : STD_LOGIC:= '0'; -- flag desde el modulo CRC receptor que marca un error en el CRC
  
  signal flag_trama_remota: STD_LOGIC:='0'; -- indica si hemos recibido una trama remota RTR=1
  signal flag_mensaje_aceptado: STD_LOGIC:='0'; --indica que el mensaje recibido es para este modulo y no contenia errores o si el mensaje enviado es correcto
  
  
 COMPONENT CRC_receptor
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		flag_CRC_calc : IN std_logic;
		flag_CRC_recibido : IN std_logic;
		inicio_anticipado: IN std_logic;
		nuevo_stream_datos : IN std_logic;
		bit_CRC_in : IN std_logic;          
		flag_CRC_error : OUT std_logic
		);
END COMPONENT;

COMPONENT timer_bit_transmisor
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;	
		timer_inicio_transmisor : IN std_logic;          
		flag_timer_transmisor : OUT std_logic
		);
END COMPONENT;
	
COMPONENT CRC_transmisor_NODO_CONTROL
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		ID_a_enviar : in STD_LOGIC_VECTOR( 10 downto 0);
		mensaje_en_espera : IN std_logic;
		byte_datos : IN std_logic_vector(7 downto 0);          
		CRC_transmisor_ready : OUT std_logic;
		RTR_A_ENVIAR: in STD_LOGIC;
		CRC_OUT : OUT std_logic_vector(14 downto 0)
		);
END COMPONENT;

 
COMPONENT timer_bit_receptor
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		flag_tiempo_bit : IN std_logic;          
		timer_ON : OUT std_logic
		);
END COMPONENT; 



COMPONENT contador_errores
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		transmisor_activo : IN std_logic;
		flag_mensaje_aceptado : IN std_logic;
		error_delimiter_flag : IN std_logic;
		error_transmisor_flag : IN std_logic;
		overload_transmisor_flag : IN std_logic;
		overload_delimiter_flag : IN std_logic;
		bit_sin_relleno : IN std_logic;
		ACK_ERROR : IN std_logic;
		flag_bits_sin_relleno : IN std_logic;
		cuenta_bits_dominantes : IN integer;
		bit_dominante : IN std_logic;
		e : IN integer;          
		BUS_OFF : OUT std_logic;
		modulo_errores_pas_flag : OUT std_logic
		);
END COMPONENT;
  
  
begin

bus_idle <= bus_idle_tmp;
BIT_OUT <=  bit_transmitido;
mensaje_a_enviar_CRC_incluido(40 downto 30) <= ID_A_ENVIAR;  
mensaje_a_enviar_CRC_incluido(29) <= RTR_A_ENVIAR;
mensaje_a_enviar_CRC_incluido(26 downto 23) <= dlc_transmitido;

DATO_A_MOSTRAR <=salidas(to_integer(unsigned(ID_A_ENVIAR))) when mostrar_entrada_salida='1'
					else entradas(to_integer(unsigned(ID_A_ENVIAR)));


inicio_anticipado_out <= inicio_anticipado when rising_edge(clk) ;

Inst_CRC_receptor: CRC_receptor PORT MAP(
		clk => clk,
		reset => reset,
		inicio_anticipado => inicio_anticipado,
		flag_CRC_calc => flag_CRC_calc,
		flag_CRC_recibido => flag_CRC_recibido,
		nuevo_stream_datos => nuevo_stream_datos,
		bit_CRC_in => bit_CRC_in,
		flag_CRC_error => flag_CRC_error
	);


Inst_timer_bit_transmisor: timer_bit_transmisor PORT MAP(
		clk => clk,
		reset => reset,		
		timer_inicio_transmisor => timer_inicio_transmisor,
		flag_timer_transmisor => flag_timer_transmisor
	);
	


Inst_CRC_transmisor: CRC_transmisor_NODO_CONTROL PORT MAP(
		clk => clk,
		reset => reset,
		ID_a_enviar => ID_A_ENVIAR,
		mensaje_en_espera => mensaje_en_espera,
		CRC_transmisor_ready => CRC_transmisor_ready,
		byte_datos => SALIDA_INTRODUCIDA,
		RTR_A_ENVIAR => RTR_A_ENVIAR,
		CRC_OUT => CRC_OUT
	);	
	
Inst_timer_bit_receptor: timer_bit_receptor PORT MAP(
		clk => clk,
		reset => reset,
		flag_tiempo_bit => flag_tiempo_bit,
		timer_ON => timer_ON
	);	
	

		
Inst_contador_errores: contador_errores PORT MAP(
		clk => clk,
		reset => reset,
		transmisor_activo => transmisor_activo,
		flag_mensaje_aceptado => flag_mensaje_aceptado,
		error_delimiter_flag => error_delimiter_flag,
		error_transmisor_flag => error_transmisor_flag,
		overload_transmisor_flag => overload_transmisor_flag,
		overload_delimiter_flag => overload_delimiter_flag,
		bit_sin_relleno => bit_sin_relleno,
		BUS_OFF => BUS_OFF,
		modulo_errores_pas_flag => modulo_errores_pas_flag,
		ACK_ERROR => ACK_ERROR,
		flag_bits_sin_relleno => flag_bits_sin_relleno,
		cuenta_bits_dominantes => cuenta_bits_dominantes,
		bit_dominante => bit_dominante,
		e => e
	);
		
		
		mensaje_introducido:process (clk,reset) --activa mensaje_en_espera 
				
			begin
				
			if (reset='1') then
				
				mensaje_en_espera<='0';
				estado_mensaje<= idle;
				
			else
			
				if rising_edge(clk) then
				
					case estado_mensaje is
					
					when idle =>
					
						if (introduccion_finalizada='1') then
						
							estado_mensaje<=mensaje_in;
							mensaje_en_espera<='1';
						end if;

					when mensaje_in	=>
					

						if (flag_mensaje_aceptado='1' and transmisor_activo='1') then
						
							mensaje_en_espera<='0';
							estado_mensaje <= mensaje_validado;
							
						elsif (RTR_A_ENVIAR='0') then

							mensaje_a_enviar_CRC_incluido(22 downto 15) <= SALIDA_INTRODUCIDA;
							mensaje_a_enviar_CRC_incluido(14 downto 0) <=  CRC_OUT;

						elsif (RTR_A_ENVIAR='1') then

							mensaje_a_enviar_CRC_incluido(22 downto 8) <=  CRC_OUT;
							
						end if;	
							
					when mensaje_validado =>
					
						if (introduccion_finalizada='0') then
						
							estado_mensaje<= idle;
						end if;
								

					end case;
				end if;		
			end if;	
				
			end process;
				
	
		guarda_salidas_y_entradas: process (clk,reset) --estamos suponiendo 1 byte de datos SIEMPRE (nos sobra con 8 bits para las 2 entradas/salidas
				
			begin 
			
			if (reset='1') then
			
				salidas <= (others =>"00000000");
				entradas <= (others =>"00000000");
				guarda_salidas<= idle;
				
			else 

				if rising_edge(clk) then
				
					case guarda_salidas is
					
						when idle =>
						
							if (flag_mensaje_aceptado='1') then
							
								guarda_salidas <= mensaje_aceptado;
							else
								guarda_salidas <= idle;
							end if;
						
						when mensaje_aceptado =>
						
							
							if (RTR_RECIBIDO='0' and transmisor_activo='1') then --HEMOS ENVIADO EL MENSAJE NOSOTROS Y ERA DE DATOS	
							
								salidas(to_integer(unsigned(ID_A_ENVIAR))) <= SALIDA_INTRODUCIDA;
								guarda_salidas <=idle;
								
							elsif(RTR_RECIBIDO='0' and transmisor_activo='0') then -- NO HEMOS ENVIADO EL MENSAJE NOSOTROS Y ERA DE DATOS	
							
								entradas(to_integer(unsigned(ID_A_ENVIAR))) <= datos_recibidos(63 downto 56); --se supone que recibimos este mensaje despues de enviar una trama remota
								guarda_salidas <=idle;														--por lo tanto la ID no varia
							else		
								guarda_salidas <=idle;	
							end if;
							
					end case;
					
				end if;
				
			end if;
			
		end process;					
	
		
		
		stream_completo:process (clk,reset,nuevo_stream_datos) -- aqui obtenemos el mensaje completo para conocer los bytes de datos recibidos

			begin
			
			if (reset='1' or nuevo_stream_datos='1') then
			
				estado_stream <= espera_flag_relleno;
				datos_totales_temp := (others => '0');
				i <=0;
				bits_totales <= 0;
				bits_totales_temp <=0;
				numero_bytes_datos <= 0;				
				bit_guardado<='0';
				flag_trama_remota <= '0';
				
				
			else 
			
				if rising_edge (clk) then
				
					case estado_stream is
					
						when espera_flag_relleno =>
						
							if (inicio_anticipado='1') then
							
								datos_totales_temp := (others => '0');
								bits_totales_temp <=1;
								bits_totales <= 0;
								flag_trama_remota <= '0';
								
							elsif (flag_bits_sin_relleno='1' and bits_totales_temp<datos_totales_temp'length) then  --flag desde relleno_bits
							
								datos_totales_temp(bits_totales_temp) := bit_sin_relleno;	 --colocamos el bit en el stream			
								bits_totales_temp <= bits_totales_temp +1;
								estado_stream <= espera_flag_relleno_2;
							else
								estado_stream <=espera_flag_relleno;
							end if;
							
						when espera_flag_relleno_2 =>
						
								bit_guardado<='1';
								estado_stream <= compara;
								
						when compara =>
						
								bit_guardado<='0';
							
							
							if (bits_totales_temp = i) then	--tenemos todos los bits 
								bits_totales <= bits_totales_temp;
								estado_stream <= espera_flag_relleno;
								i <= 0;
								
							elsif (bits_totales_temp = 13) then
							
									if (bit_sin_relleno='1') then -- SI RTR='1' ESTAMOS RECIBIENDO TRAMA REMOTA
									
										flag_trama_remota <= '1';
										numero_bytes_datos <= 0;
										estado_stream <= espera_flag_relleno;
									else
										estado_stream <= espera_flag_relleno;
										flag_trama_remota <= '0';
									end if;	
									
							elsif (bits_totales_temp = 19 and flag_trama_remota='1') then	
								estado_stream <= calculo_bits;
						
							elsif (bits_totales_temp = 19 and flag_trama_remota='0') then --19 bits para llegar al numero de bytes de datos
								estado_stream <= bytes_de_Datos;
								
							else
								estado_stream <= espera_flag_relleno;
							end if;	
								
						when bytes_de_Datos =>  --cuantos bytes de datos tenemos
						
							numero_bytes_datos <=  to_integer(unsigned(datos_totales_temp(15 to 18))); --de 0 a 8
							estado_stream <= calculo_bits;
						
						when calculo_bits => --bits totales del mensaje

							i <= 44 + numero_bytes_datos*8;
							estado_stream <= compara2;
						
						when compara2 =>
						
							if (bits_totales_temp = i) then	--tenemos todos los bits
								bits_totales <= bits_totales_temp;
								estado_stream <= espera_flag_relleno;
								i <= 0;
							else
								estado_stream <=espera_flag_relleno;
							end if;	
						
						
					end case;
				end if;
			end if;
	
			end process; 
			

		estado_receptor: process (clk,reset)
		
			procedure FORM_ERROR    (error_flagg : mis_estados;  --procedure para el form error
								     variable bit_a_testear: in STD_LOGIC;
									 constant comparador : in STD_LOGIC) IS

			begin
			
			if (bit_a_testear/=comparador) then

				recepcion <= error_flagg;	
					
			end if;
		
			end procedure;
			
			
			procedure BIT_ERROR   (error_flagg : mis_estados;  --procedure para el bit  error
								   signal transmisor_activo: in STD_LOGIC;	
								   signal flag_bit_error: in STD_LOGIC ) IS 

			begin
			
			if (transmisor_activo='1') then
			
				if (flag_bit_error='1') then

					recepcion <= error_flagg;	
					
				end if;
			end if;
			
			end procedure;
			
			
			begin
			
			if (reset='1') then
			
				recepcion <= idle;
				e <= 0;
				identificador_recibido <= (others => '0');
				prioridad_perdida <='0';
				RTR_RECIBIDO <= '0';
				ACK_ERROR <= '0';
				bit_dominante <= '0';
				cuenta_bits_dominantes <= 0;
				overload_transmisor_flag <= '0';
				error_transmisor_flag <= '0';
				bus_idle_tmp <= '0';
				fin_bits <= '0';
				indicador_error <='0';
				inicio_anticipado <= '0';
				error_delimiter_flag <= '0';
				ACK_respuesta_flag <='0';
				
			else 

				if rising_edge(clk) then
				
					case recepcion is
					
						when idle =>
						
							bus_idle_tmp <= '0';
							fin_bits <= '0';
							indicador_error <='0';
						
								if (inicio_recepcion = '1') then  --recibe flanco de bajada indicio de bit de start
								
									nuevo_stream_datos <= '1'; --resetea el proceso "stream_completo"
									recepcion <= espera_sample ;
									identificador_recibido <= (others => '0');
									
								end if;
							
						when espera_sample =>     --espera a samplear el bit de start
						
								nuevo_stream_datos <= '0';
								
								if ( flag_bits_sin_relleno='1') then  --señal de que hemos recibido el bit de start
								recepcion <= SOF;
							    else
								recepcion <= espera_sample;
								end if;
								
						when SOF =>  -- comprobamos errores y esperamos al nuevo sample 
						
								inicio_anticipado <= '0';
						
								if (bit_guardado='1') then  --bit de start guardado en el array
								
									flag_crc_calc <= '1';
									bit_CRC_in <= datos_totales_temp(e);		
									FORM_ERROR (ERROR_FLAG,datos_totales_temp(0),'0');
									
								elsif (flag_bits_sin_relleno='1') then --primer bit del ID recibido

									recepcion <=  identificador;
									e <= e+1;  --primer bit del identificador
								else
									flag_crc_calc <= '0';
								end if;
							
						when identificador =>
						
								if (flag_stuff_error='1') then
								
									recepcion <= ERROR_FLAG;
							
								elsif ( bit_guardado='1') then --bit guardado en el array
								
								
									flag_crc_calc <= '1';
									bit_CRC_in <= datos_totales_temp(e);
									identificador_recibido(11-e) <= datos_totales_temp(e);
									
									if (transmisor_activo='1') then --si este nodo esta transmitiendo...
									
										 if (datos_totales_temp(e)/=mensaje_a_enviar_CRC_incluido(41-e)) then -- Y si el bit recibido y el transmitido no son iguales...
										 
											recepcion <= identificador;
											prioridad_perdida <='1';  --perdemos la prioridad
										 end if;
									end if; 
									
								elsif (flag_bits_sin_relleno='1') then	--nuevo bit recibido
								
									if (e=11) then
										
										recepcion <= RTR;
										e <= e+1;
										prioridad_perdida <='0';
									else
										e <= e+1;
										recepcion <= identificador;
									end if;
								else
									flag_crc_calc <= '0';	
								end if;	
								
					
						when RTR =>
								
								if (flag_stuff_error='1') then
								
									recepcion <= ERROR_FLAG;
									
								elsif ( bit_guardado='1') then --bit guardado en el array
								
									flag_crc_calc <= '1';
									bit_CRC_in <= datos_totales_temp(e);
									RTR_RECIBIDO <= datos_totales_temp(e);
								
									if (transmisor_activo='1') then --si este nodo esta transmitiendo...
									
										 if (datos_totales_temp(e)/=mensaje_a_enviar_CRC_incluido(41-e)) then -- Y si el bit recibido y el transmitido no son iguales...
										 
											prioridad_perdida <='1';  --perdemos la prioridad
										 end if;
									end if; 
									
								elsif (flag_bits_sin_relleno='1') then   --nuevo bit recibido
								 
									prioridad_perdida <='0';
									recepcion <= IDE;
									e <=  e+1;
								else
									flag_crc_calc <= '0';	
								end if;	
									

						when IDE =>
						
								
						
								if (flag_stuff_error='1') then
								
									recepcion <= ERROR_FLAG;
									
								elsif ( bit_guardado='1') then --bit guardado en el array
								
									BIT_ERROR (ERROR_FLAG,transmisor_activo,flag_bit_error);
									flag_crc_calc <= '1';
									bit_CRC_in <= datos_totales_temp(e);									
									FORM_ERROR (ERROR_FLAG,datos_totales_temp(13),'0');
									
								elsif (flag_bits_sin_relleno='1') then   --nuevo bit recibido
								
									recepcion <= reservado;
									e <= e+1;
								else
									flag_crc_calc <= '0';
								end if;		
								

						when reservado =>
						
								
						
								if (flag_stuff_error='1') then
								
									recepcion <= ERROR_FLAG;
									
								elsif ( bit_guardado='1') then --bit guardado en el array
								
									BIT_ERROR (ERROR_FLAG,transmisor_activo,flag_bit_error);
							        flag_crc_calc <= '1';
									bit_CRC_in <= datos_totales_temp(e);
									FORM_ERROR (ERROR_FLAG,datos_totales_temp(14),'0');
									
								elsif (flag_bits_sin_relleno='1') then   --nuevo bit recibido
								
									recepcion <= DLC;
									e <= e+1;
								else
									flag_crc_calc <= '0';
								end if;
							
						when DLC =>
						
								
						
								if (flag_stuff_error='1') then
								
									recepcion <= ERROR_FLAG;
									
								elsif ( bit_guardado='1') then --bit guardado en el array
								
									BIT_ERROR (ERROR_FLAG,transmisor_activo,flag_bit_error);
								    flag_crc_calc <= '1';
									bit_CRC_in <= datos_totales_temp(e);
								  
								elsif 	(flag_bits_sin_relleno='1') then   --nuevo bit recibido
								
									e <= e+1;
								
									if (e=18) then 
									
										if (RTR_RECIBIDO='1' or numero_bytes_datos=0) then -- si el RTR recibido es '0' estamos en una trama de datos; si es '1' es una trama remota
										
											recepcion <= CRC;
											
										else
											recepcion <= datos;
										end if;	
									else
										recepcion <= DLC;
										
									end if;	
								else
									flag_crc_calc <= '0';	
								end if;
								
		
						when datos =>
						
							
						
							if (flag_stuff_error='1') then
								
									recepcion <= ERROR_FLAG;
									
							elsif ( bit_guardado='1') then --bit guardado en el array
							
								BIT_ERROR (ERROR_FLAG,transmisor_activo,flag_bit_error);	
								flag_crc_calc <= '1';
								bit_CRC_in <= datos_totales_temp(e);
								datos_recibidos(63-e+19) <= datos_totales_temp(e);  --siempre recibimos 19 bits antes de los bytes de datos
								
							elsif 	(flag_bits_sin_relleno='1') then   --nuevo bit recibido
							
								e <= e+1;
							
								if (e=18 + numero_bytes_datos*8) then
								
									recepcion <= CRC;
								else
									recepcion <= datos;
								end if;
							else
								flag_crc_calc <= '0';	
							end if;
				

						when CRC =>
						
							
						
							if (flag_stuff_error='1') then
								
									recepcion <= ERROR_FLAG;
									
							elsif ( bit_guardado='1') then --bit guardado en el array
							
								BIT_ERROR (ERROR_FLAG,transmisor_activo,flag_bit_error);
								flag_crc_recibido <= '1';
								bit_CRC_in <= datos_totales_temp(e);
								
							elsif (flag_bits_sin_relleno='1') then   --nuevo bit recibido
							
								e <= e+1;
								
								if (e=32 + numero_bytes_datos*8) then --penultimo bit del CRC
								
									fin_bits <= '1';
								
								elsif (e=33 + numero_bytes_datos*8) then  --el ultimo bit del crc es como minimo 33
								
									recepcion <= CRC_FIN;
								else
									recepcion <= CRC;
								end if;
							else
				      				flag_crc_recibido <= '0';
							end if;	
						
					
						when CRC_FIN =>  
						
							
							
							if ( bit_guardado='1') then --bit guardado en el array
								
								ACK_respuesta_flag <='1'; --para responder con '0' al mensaje recibido
								
								BIT_ERROR (ERROR_FLAG,transmisor_activo,flag_bit_error);
								FORM_ERROR (ERROR_FLAG,datos_totales_temp(e),'1');
								
							elsif (flag_bits_sin_relleno='1') then   --nuevo bit recibido
							
								ACK_respuesta_flag <='0';
								 e <= e+1;
								 recepcion <= ACK_SLOT;
							end if;	 
	                               
									
						

						when ACK_SLOT => --comprobamos si algun nodo ha recibido nuestro mensaje ( solo si estamos transmitiendo)
						
							if (bit_guardado='1') then --bit guardado en el array
							
								if (transmisor_activo='1') then --si este nodo esta transmitiendo...
								
									if (datos_totales_temp(e)/='0') then --si el bit recibido no es '0' --ACK ERROR
									
										recepcion <= ERROR_FLAG;
										ACK_ERROR <= '1';
										
									end if;
								end if;
								
							elsif	(flag_bits_sin_relleno='1') then   --nuevo bit recibido
							
								 e <= e+1;
								 recepcion <= ACK_FIN;
								 
							end if;	 
						

						when ACK_FIN =>
						
							if (bit_guardado='1') then --bit guardado en el array
							
								BIT_ERROR (ERROR_FLAG,transmisor_activo,flag_bit_error);
								FORM_ERROR (ERROR_FLAG,datos_totales_temp(e),'1');
								
								if ( flag_CRC_error='1') then --si existe error en el CRC se actua despues del ACK delimiter
								
									recepcion <= ERROR_FLAG;
								end if;	
								
							elsif (flag_bits_sin_relleno='1') then   --nuevo bit recibido

								 e <= e+1;
								 recepcion <= EOF;
							end if;	 	
							
						

						when EOF =>
						
							if (bit_guardado='1') then --bit guardado en el array
							
								if (e < (43 + numero_bytes_datos*8)) then	
								
								BIT_ERROR (ERROR_FLAG,transmisor_activo,flag_bit_error);
								FORM_ERROR (ERROR_FLAG,datos_totales_temp(e),'1');
								
									if (e =42 + numero_bytes_datos*8 and transmisor_activo='0') then --si no hay error hasta el penultimo bit de EOF y no somos transmisor =>
									
										if (bit_sin_relleno='1') then --y recibimos un '1'
																					--mensaje valido
											flag_mensaje_aceptado <= '1';
										end if;	
									end if;	
								
								elsif (e = 43 + numero_bytes_datos*8 ) then --si no hay error hasta el ultimo bit de EOF y  SOMOS transmisor.... =>
								
									if (transmisor_activo='1') then
									
									    BIT_ERROR (ERROR_FLAG,transmisor_activo,flag_bit_error);
										FORM_ERROR (ERROR_FLAG,datos_totales_temp(e),'1');
										
										if (bit_sin_relleno='1') then --y recibimos un '1'...
										
											flag_mensaje_aceptado <= '1'; --mensaje valido
										end if;
									end if;	
								
								end if;
								
							elsif (flag_bits_sin_relleno='1') then   --nuevo bit recibido
							
								e <= e+1;
							
								if (e= 43 + numero_bytes_datos*8) then
								
									recepcion <= intermission;
									e <=1;    --AQUI TERMINA EL MENSAJE
								
								else
									recepcion <= EOF;
								end if;	
						
							end if;	
							
					
						when intermission =>
						
						
								flag_mensaje_aceptado <= '0';
								
								if (bit_guardado='1') then
								
									if (e<3) then
									
									BIT_ERROR (ERROR_FLAG,transmisor_activo,flag_bit_error);
									
										if (bit_sin_relleno='0') then --si recibimos un '0' en el primer o segund bit de intermission => overload
										
											recepcion <= overload_flag;
										end if;	
									 
																	
									end if;
					
								elsif( flag_bits_sin_relleno='1') then
								
									e <= e+1;
								
									if (e=2 and bit_sin_relleno='0') then -- '0' recibido al tercer bit de intermission
									
										recepcion <= SOF;
										e <= 0;
										inicio_anticipado <= '1';
										fin_bits <= '0';
										
									elsif (e=2 and bit_sin_relleno='1') then --hemos recibido los tres bits de intermission y pasamos a idle
																			--	
										e <= 0;
										recepcion <= idle;
										bus_idle_tmp <= '1';
									
										
									end if;
								
								end if;	
								
									
							
						when overload_flag =>
						
							overload_transmisor_flag <= '1';
							e <= 0;
							recepcion <= overload_flag_2;
							cuenta_bits_dominantes <= 0;
							
							
							
						when overload_flag_2 =>

							overload_transmisor_flag <= '0';
							
								if (bit_guardado='1' and e<7) then
								
									BIT_ERROR (ERROR_FLAG,transmisor_activo,flag_bit_error);
										
									cuenta_bits_dominantes <= cuenta_bits_dominantes+1;
									
								elsif (bit_guardado='1' and e>=7) then	
								
									if (bit_sin_relleno='0') then

										cuenta_bits_dominantes <= cuenta_bits_dominantes+1;
									end if;	
								
								elsif (flag_bits_sin_relleno='1') then
								
									e <= e+1;
									
									if (e>=6) then
									
										if (bit_sin_relleno='1') then
										
											overload_delimiter_flag <='1'; --avisa al transmisor para que pase a OVERLOAD DELIMITER
											recepcion <= overload_delimiter;
											cuenta_bits_dominantes<=0;
											e <= 1;
										else
											recepcion <= overload_flag_2;
										end if;
									end if;	
								end if;
								
					
						when overload_delimiter =>
						
								if (bit_guardado='1' and e<8) then --el ultimo bit (8) no se trata como si error si es '0'
								
								BIT_ERROR (ERROR_FLAG,transmisor_activo,flag_bit_error);		
						
								elsif (flag_bits_sin_relleno='1') then
								
									overload_delimiter_flag <='0';
									e <= e+1;
									
									if (e=7 and bit_sin_relleno='0') then --si el ultimo bit es '0' pasamos a otra trama de overload
									
										recepcion <= overload_flag;
										
									elsif (e=8 ) then  --se han recibido todos los bits de overload_delimiter
									
										if (bit_sin_relleno='1') then
										
											e <= 1;	
											recepcion <= intermission;  -- si el bit despues de los 8 del delimiter es '1' => intermission
										else
											recepcion <= overload_flag;  -- si el bit despues de los 8 del delimiter es '0' => overload_flag
										end if;
							        end if;
								end if;	
					
					
						when ERROR_FLAG =>
						
							ACK_respuesta_flag <='0';
							ACK_ERROR <= '0';
							indicador_error <='1';
							error_transmisor_flag <= '1';
							flag_crc_recibido <= '0';
							flag_crc_calc <= '0';
							e <= 0;
							recepcion <= ERROR_FLAG_2;
							cuenta_bits_dominantes <= 0;
							bit_dominante <= '0';
							
						when ERROR_FLAG_2 =>

							error_transmisor_flag <= '0';
							
								if (bit_guardado='1' and e<6) then
								
									if (modulo_errores_pas_flag='0' and bit_sin_relleno='0') then  --nodo en error activo y recibimos '0'
									
										e <= e+1;
										cuenta_bits_dominantes <= cuenta_bits_dominantes+1;
										
									elsif (modulo_errores_pas_flag='0' and bit_sin_relleno='1') then --nodo en error activo y recibimos '1'
									
										recepcion <= ERROR_FLAG;
										cuenta_bits_dominantes<=0;		
										
									elsif (modulo_errores_pas_flag='1' and bit_sin_relleno='1') then  --nodo en error pasivo y recibimos '1'	 
									
										e <= e+1;
										cuenta_bits_dominantes<=0;
									else
										cuenta_bits_dominantes <= cuenta_bits_dominantes+1;
										bit_dominante <= '1'; --marca que hemos recibido algun bit dominante '0' durante PASSIVE FLAG
										e <=0;
									end if;
									
								elsif (bit_guardado='1' and bit_sin_relleno='0') then
								
									cuenta_bits_dominantes <= cuenta_bits_dominantes+1;
							
								elsif (flag_bits_sin_relleno='1') then
								
									  if (e=6) then
									  
										if (bit_sin_relleno='1') then
										
											error_delimiter_flag <= '1';  --avisa al transmisor para que pase a ERROR DELIMITER
											recepcion <= ERROR_DELIMITER;
											cuenta_bits_dominantes<=0;
											e <= 1;
										else
											recepcion <= ERROR_FLAG_2;
										end if;	
									  end if;
								end if;	  
									
					

						when ERROR_DELIMITER	 =>
										
						
								if (flag_bits_sin_relleno='1') then
								
									error_delimiter_flag <= '0';
								
									if (bit_sin_relleno='1' and e=8) then --si tenemos los 8 bits del delimiter y el siguiente es un 1 pasamos a intermission
									
									    e <= 1;
										recepcion <= intermission;
										indicador_error <='0';
								
									elsif (bit_sin_relleno='1' and e<8) then --si no tenemos los 8 bits y el siguiente es un 1 sumamos +1 a "e"
									
											e <= e+1;
											recepcion <= ERROR_DELIMITER;
											
											
									elsif (bit_sin_relleno='0' and e>=7) then --si tenemos 7 u 8 bits del delimiter y el siguiente es un 0 pasamos a overload flag
									
											e <= 0;
											recepcion <=  overload_flag;
									
									elsif (bit_sin_relleno='0' and e<8) then --si no tenemos los 8 bits del delimiter y el siguiente es un 0 reseteamos "e" a 0	
									
											e <=0;
											recepcion <= ERROR_FLAG;
									end if;
								
								
								end if;
					
					end case;
				end if;
			end if;		
		
		end process;
		
		
		estado_transmisor: process (clk,reset)
			
			
			variable bit_transmitido_previo: STD_LOGIC:='1';
			
			procedure stuff_contador ( signal bit_transmitido: inout STD_LOGIC;  --realiza el stuffing del mensaje a enviar
									   variable bit_transmitido_previo: inout STD_LOGIC;
									   signal t: inout integer;
									   signal stuff_cuenta: inout integer) IS
									   
			begin
			
				bit_transmitido_previo:=  bit_transmitido;
				
				if (stuff_cuenta =5) then
				
						bit_transmitido <= not bit_transmitido;
						stuff_cuenta <= 1;
						
				elsif (t < mensaje_a_enviar_CRC_incluido'length) then

				
					if (mensaje_a_enviar_CRC_incluido(41-t)/= bit_transmitido_previo) then
					
						stuff_cuenta <=1;
						t <= t+1;
						bit_transmitido <= mensaje_a_enviar_CRC_incluido(41-t);
						
						
					elsif (mensaje_a_enviar_CRC_incluido(41-t)= bit_transmitido_previo) then
					
						stuff_cuenta <= stuff_cuenta+1;
						t <= t+1;
						bit_transmitido <= mensaje_a_enviar_CRC_incluido(41-t);
					end if;
					
				end if;	
						

			end procedure;	
		
			begin
			
				if (reset='1') then 
				
					transmision <= idle;
					timer_inicio_transmisor <= '0';
					bit_transmitido <='1';
					t <= 0;  
					transmisor_activo <='0';
					stuff_cuenta <= 0;
					bit_transmitido_previo := '1';
					cuenta <=0;
					cuenta_ACK_respuesta <=0;
					
					
				else 

					if rising_edge(clk) then
						
								case transmision is
								
									when idle =>
									
										cuenta <=0;
										bit_transmitido <= '1';
										t <= 0;
										timer_inicio_transmisor <= '1';
									
										if (inicio_recepcion='1') then
										
											if (mensaje_en_espera='1') then
										
											transmision <= SOF;									
											timer_inicio_transmisor <= '0';
											transmisor_activo <='1';
											
											stuff_contador(bit_transmitido,bit_transmitido_previo,t,stuff_cuenta);
										
											else								
												transmision<= espera_banderas;
											end if;	
									
										elsif (mensaje_en_espera='1') then
										
											transmision <= SOF;
											stuff_contador(bit_transmitido,bit_transmitido_previo,t,stuff_cuenta);
											timer_inicio_transmisor <= '0';
											transmisor_activo <='1';
											
										end if;	
											
											
											
									when SOF  => 	
									
										timer_inicio_transmisor <= '0';
									
										
										if (error_transmisor_flag='1') then
										
											t <= 0;
											transmision <= ERROR_FLAG;
										
										elsif (flag_timer_transmisor='1') then
										
											stuff_contador(bit_transmitido,bit_transmitido_previo,t,stuff_cuenta);	
											transmision <= identificador;
										end if;
										
									when identificador	=>

										if (error_transmisor_flag='1') then
										
											t <= 0;
											transmision <= ERROR_FLAG;
											
										elsif ( prioridad_perdida='1') then
										
											transmisor_activo <='0';
											t <= 0;
											transmision <= espera_banderas;
											timer_inicio_transmisor<='1';
											
										elsif (flag_timer_transmisor='1') then
										
											stuff_contador(bit_transmitido,bit_transmitido_previo,t,stuff_cuenta);	
										
											if (t=12) then
												transmision <= RTR;
											else
												transmision <= identificador;
											end if;
										end if;

									when RTR => 
									
										
										
										if (error_transmisor_flag='1') then
										
											t <= 0;
											transmision <= ERROR_FLAG;
											
										elsif ( prioridad_perdida='1') then --otro nodo con mayor prioridad esta transmitiendo
										
											transmisor_activo <='0';
											t <= 0;
											transmision <= espera_banderas;
											timer_inicio_transmisor<='1';
											
										elsif (flag_timer_transmisor='1') then
										
											stuff_contador(bit_transmitido,bit_transmitido_previo,t,stuff_cuenta);	
											transmision <= IDE;
											
										end if;
											
									when IDE =>
									
										if (error_transmisor_flag='1') then
									
												t <= 0;
												transmision <= ERROR_FLAG;
	
										elsif (flag_timer_transmisor='1') then
										
											stuff_contador(bit_transmitido,bit_transmitido_previo,t,stuff_cuenta);	
											transmision <= reservado;
											
										end if;	
			
									when reservado =>
									
										if (error_transmisor_flag='1') then
										
											t <= 0;
											transmision <= ERROR_FLAG;
	
										elsif (flag_timer_transmisor='1') then
										
											stuff_contador(bit_transmitido,bit_transmitido_previo,t,stuff_cuenta);	
											transmision <= DLC;
											
										end if;	
								
									when DLC =>
									
										if (error_transmisor_flag='1') then
										
											t <= 0;
											transmision <= ERROR_FLAG;
			
										elsif (flag_timer_transmisor='1') then
										
											stuff_contador(bit_transmitido,bit_transmitido_previo,t,stuff_cuenta);	
											
											if (t=19 and RTR_A_ENVIAR='0') then --ESTAMOS ENVIANDO TRAMA DE DATOS
												
												transmision <= DATOS;
												
											elsif (t=19 and RTR_A_ENVIAR='1') then--ESTAMOS ENVIANDO TRAMA REMOTA
											
												transmision<= CRC;
												
											else
												transmision <= DLC;
											end if;
										end if;
										
									when DATOS =>
									
										if (error_transmisor_flag='1') then
										
											t <= 0;
											transmision <= ERROR_FLAG;	
											
										elsif (flag_timer_transmisor='1') then
										
											stuff_contador(bit_transmitido,bit_transmitido_previo,t,stuff_cuenta);	
											
											if (t=27) then
												
												transmision <= CRC;
											
											else
												transmision <= DATOS;
											end if;
										end if;
										
									when CRC =>
									
										
										if (error_transmisor_flag='1') then
										
											t <= 0;
											transmision <= ERROR_FLAG;	
											
										elsif (flag_timer_transmisor='1') then
										
											stuff_contador(bit_transmitido,bit_transmitido_previo,t,stuff_cuenta);	
											
											if (RTR_A_ENVIAR='0') then --TRAMA DE DATOS 1 BYTE DE DATOS SIEMPRE
											
												if (t=42 and stuff_cuenta <5) then
													
													transmision <= CRC_FIN;
													t <=0;
												else
													transmision <= CRC;
												end if;
											
											elsif (RTR_A_ENVIAR='1') then --TRAMA REMOTA 
											
												if (t=34 and stuff_cuenta <5) then
													
													transmision <= CRC_FIN;
													t <=0;
												else
													transmision <= CRC;
												end if;
											end if;
												
										end if;
									
									when CRC_FIN =>
									
										bit_transmitido <= '1';
									
										if (error_transmisor_flag='1') then
										
											t <= 0;
											transmision <= ERROR_FLAG;
	
										elsif (flag_timer_transmisor='1') then
									
											transmision <= ACK_SLOT;
											
										end if;	
										
									when ACK_SLOT =>
									
										bit_transmitido <= '1';
										
										if (error_transmisor_flag='1') then
											
											t <= 0;
											transmision <= ERROR_FLAG;
	
										elsif (flag_timer_transmisor='1') then
									
											transmision <= ACK_FIN;
											
										end if;	
										
									when ACK_FIN =>
									
										bit_transmitido <= '1';
										
										if (error_transmisor_flag='1') then
											
											t <= 0;
											transmision <= ERROR_FLAG;
	
										elsif (flag_timer_transmisor='1') then
									
											transmision <= EOF;
											
										end if;	
										
									when EOF => 
									
										bit_transmitido <= '1';
										
										if (error_transmisor_flag='1') then
										
											transmision <= ERROR_FLAG;
											t <= 0;
	
										elsif (flag_timer_transmisor='1') then
										
											t <= t+1;
											
											if (t=6) then
											
												t <= 0;
												transmision <= intermission;
											else		
												transmision <= EOF;
											end if;
										end if;	
										
									when intermission =>
																		
										bit_transmitido <= '1';
										cuenta <=0;
										
										if( overload_transmisor_flag='1') then --si el primer o segundo bit de intermission es 0
										
											transmision <= overload_flag;
											
										elsif (inicio_anticipado='1') then --si el tercer bit de intermission es 0

											if (mensaje_en_espera='1') then 	--y tenemos un mensaje esperando a ser enviado
											
												timer_inicio_transmisor <= '1';
												bit_transmitido <='0';
												transmision <=espera_bit_time_id; --esperamos a que acabe el bit recibido y enviamos el primer bit de ID
												t <= 1;
											else                                 --y NO tenemos mensaje esperando a ser enviado
												transmision <= espera_banderas;  --pasamos al estado espera_banderas (error,overload,ack,etc)
												transmisor_activo <= '0';
												t <=0;
											end if;
											
										elsif (flag_timer_transmisor='1') then
										
											t <= t+1;
											
											if (t=2) then
											
												if (modulo_errores_pas_flag='1'and transmisor_activo='1') then --si este nodo esta en modo error pasivo
												
													transmision <= suspend_transmission;
													t <= 0;
												else
													timer_inicio_transmisor <= '1';
													transmision <= idle;
												end if;	
											
												transmisor_activo <='0';
												bit_transmitido_previo := '1';
												t <= 0;
												
											end if;
										end if;
											
									when espera_bit_time_id => --esperamos a que acabe el bit recibido
									
										if (timer_ON='1') then
										
											timer_inicio_transmisor <= '0';
											stuff_contador(bit_transmitido,bit_transmitido_previo,t,stuff_cuenta);	
											transmision <= identificador;
										end if;	
									
									when suspend_transmission =>
									
										bit_transmitido <= '1';
									
										if (inicio_recepcion='1') then
										
											transmision <= espera_banderas;
											t <=0;
											
										elsif (flag_timer_transmisor='1') then
										
											t <= t+1;
											
											if (t=7) then
											
												transmision <= idle;
												t <=0;
											end if;
											
										end if;	
										
									when ERROR_FLAG =>
									
										if (timer_ON='1') then
										
											if (e=6) then --si hemos recibido los 6 bits consecutivos del error transmitido,enviamos '1'
												bit_transmitido <= '1';
												
											elsif(e=1 and error_delimiter_flag='1') then --indica si hemos recibido '1' despues del 6 bit enviado de error
												
													transmision <= ERROR_DELIMITER;
											
											else
												if (modulo_errores_pas_flag='0') then
													
													bit_transmitido <= '0';--error activo
												else
													bit_transmitido <= '1'; -- error pasivo
												end if;
											end if;
										end if;		
		
									when ERROR_DELIMITER=>
									
										timer_inicio_transmisor <= '1';
										
										if (error_transmisor_flag='1') then
										
											t <= 0;
											transmision <= ERROR_FLAG;
									
										elsif (overload_transmisor_flag='1') then
										
											transmision <= overload_flag;
									
										elsif (timer_ON='1') then
										
											if (e=8) then 
											
												transmision <= intermission;
												timer_inicio_transmisor <= '0';
											end if;
										end if;

									when overload_flag =>
									
										if (error_transmisor_flag='1') then
										
											transmision <= ERROR_FLAG;
									
										elsif (timer_ON='1') then
										
											bit_transmitido <='0';
											
											if (overload_delimiter_flag='1') then --indica si hemos recibido '1' despues del 6 bit enviado de overload
											
												transmision <= overload_delimiter;
												bit_transmitido <= '1';
											
											elsif (e>=6) then
												
												bit_transmitido <= '1';
											
											else
												transmision <= overload_flag;
											end if;
											
										end if;
										
												
									when overload_delimiter =>
									
										if (error_transmisor_flag='1') then
										
											transmision <= ERROR_FLAG;
											
										elsif (overload_transmisor_flag='1') then

											transmision <= overload_flag;
											
										elsif (timer_ON='1') then
										
											if (e=8) then
											
												timer_inicio_transmisor <= '0';
												transmision <= intermission;
											else
												transmision <= overload_delimiter;
											end if;
										end if;	
									
										
									when espera_banderas =>
									
										bit_transmitido <= '1';
										
										if (error_transmisor_flag='1') then
										
											transmision <= ERROR_FLAG;
											
										elsif (overload_transmisor_flag='1') then

											transmision <= overload_flag;
									
										elsif (ACK_respuesta_flag='1') then
										
											transmision <= espera_bit_time_ACK;
											
										elsif (bus_idle_tmp='1') then
											
											transmision <= espera_bit_time_idle;
											
										elsif (inicio_anticipado='1') then --si el tercer bit de intermission es 0

											if (mensaje_en_espera='1') then 	--y tenemos un mensaje esperando a ser enviado
											
												timer_inicio_transmisor <= '1';
												bit_transmitido <='0';
												transmision <=espera_bit_time_id; --esperamos a que acabe el bit recibido y enviamos el primer bit de ID
												t <= 1;
											else                                 --y NO tenemos mensaje esperando a ser enviado
												transmision <= espera_banderas;  --pasamos al estado espera_banderas (error,overload,ack,etc)
												transmisor_activo <= '0';
												t <=0;
											end if;	
											
										end if;	
									
									when espera_bit_time_ACK =>
									
										if (error_transmisor_flag='1') then
										
											transmision <= ERROR_FLAG;
									
										elsif (cuenta_ACK_respuesta=2) then
										
											cuenta_ACK_respuesta <=0;
											transmision <= ACK_respuesta;
										else
											cuenta_ACK_respuesta <= cuenta_ACK_respuesta+1;
											transmision <= espera_bit_time_ACK;
										end if;
										
									when ACK_respuesta =>
									
										bit_transmitido <='0';
										
										if (error_transmisor_flag='1') then
										
											transmision <= ERROR_FLAG;
											
										elsif (timer_ON='1') then
										
											transmision <= espera_banderas;
											bit_transmitido <='1';
										end if;
									
									when espera_bit_time_idle =>
									
										cuenta <= cuenta+1;
										timer_inicio_transmisor <= '1';
									
										if (inicio_recepcion='1') then
										
											if (mensaje_en_espera='1') then
										
											transmision <= SOF;									
											
											transmisor_activo <='1';
											
											stuff_contador(bit_transmitido,bit_transmitido_previo,t,stuff_cuenta);
										
											else								
												transmision<= espera_banderas;
											end if;	
																													
										elsif(cuenta=49) then
										
											cuenta <=0;
											transmision <= idle;
											
										end if;	
								
										
								end case;
					end if;
				end if;
					
			bit_transmitido_previo_TMP<=bit_transmitido_previo;
			end process;		

	
end Behavioral;