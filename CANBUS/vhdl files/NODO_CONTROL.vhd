----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:32:49 09/13/2020 
-- Design Name: 
-- Module Name:    NODO_CONTROL - Behavioral 
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

entity NODO_CONTROL is

	 Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           rx : in  STD_LOGIC;
           tx : out  STD_LOGIC;
		   ENTRADA_SALIDA: in STD_LOGIC;
		   MAS: in STD_LOGIC;
		   MENOS : in STD_LOGIC;
		   indicador_errorr:out STD_LOGIC;
		   bcd_0: out std_logic_vector(7 downto 0);
		   bcd_2: out std_logic_vector(7 downto 0);
		   bcd_4: out std_logic_vector(7 downto 0);
		   bcd_5: out std_logic_vector(7 downto 0);
		   
		   MODIFICAR_SOLICITAR:in STD_LOGIC;
		   ACEPTAR: in STD_LOGIC
		   
		   
		);
end NODO_CONTROL;

architecture Behavioral of NODO_CONTROL is


COMPONENT operaciones_NODO_CONTROL
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		introduccion_finalizada : IN std_logic;
		SALIDA_INTRODUCIDA : IN std_logic_vector(7 downto 0);
		mostrar_entrada_salida : IN std_logic;
		ID_A_ENVIAR : IN std_logic_vector(10 downto 0);
		RTR_A_ENVIAR : IN std_logic;
		bit_sin_relleno : IN std_logic;
		flag_tiempo_bit : IN std_logic;
		flag_bits_sin_relleno : IN std_logic;
		inicio_recepcion : IN std_logic;
		flag_bit_error : IN std_logic;
		flag_stuff_error : IN std_logic;          
		DATO_A_MOSTRAR : OUT std_logic_vector(7 downto 0);
		bus_idle : OUT std_logic;
		indicador_error : OUT std_logic;
		inicio_anticipado_out : OUT std_logic;
		bits_totales : OUT integer;
		BIT_OUT : OUT std_logic;
		fin_bits : OUT std_logic
		);
END COMPONENT;


COMPONENT relojj_1hz
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;          
		reloj1hz : OUT std_logic
		);
END COMPONENT;


COMPONENT BOTONERA
	PORT(
		clk1hz : IN std_logic;
		reset : IN std_logic;
		ENTRADA_SALIDA : IN std_logic;
		MODIFICAR_SOLICITAR : IN std_logic;
		ACEPTAR : IN std_logic;
		MAS : IN std_logic;
		MENOS : IN std_logic;          
		visualizar_modificar : OUT std_logic;
		mostrar_entrada_salida : OUT std_logic;
		ID_A_ENVIAR : OUT std_logic_vector(10 downto 0);
		RTR_A_ENVIAR : OUT std_logic;
		introduccion_finalizada : OUT std_logic;
		SALIDA_INTRODUCIDA : OUT std_logic_vector(7 downto 0)
		);
END COMPONENT;


COMPONENT STUFF_ERROR
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		inicio_anticipado : IN std_logic;
		inicio_recepcion : IN std_logic;
		flag_bit_recibido : IN std_logic;
		bit_recibido : IN std_logic;          
		flag_stuff_error : OUT std_logic
		);
END COMPONENT;


COMPONENT receptor
	PORT(
		clk10Mhz : IN std_logic;
		clk : IN std_logic;
		reset : IN std_logic;
		rx : IN std_logic;
		bus_idle : IN std_logic;          
		inicio_recepcion : OUT std_logic;
		flag_bit_recibido : OUT std_logic;
		flag_tiempo_bit : OUT std_logic;
		flag_test : OUT std_logic;
		flag_test_2 : OUT std_logic;
		bit_recibido : OUT std_logic
		);
END COMPONENT;


COMPONENT relleno_bits_receptor
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		bit_recibido : IN std_logic;
		flag_bit_recibido : IN std_logic;
		inicio_anticipado : IN std_logic;
		indicador_error : IN std_logic;
		fin_bits : IN std_logic;          
		bits_sin_relleno : OUT std_logic;
		aviso_bit_relleno : OUT std_logic;
		flag_bit_sin_relleno : OUT std_logic
		);
END COMPONENT;


COMPONENT reloj_10Mhz
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;          
		relojj_10Mhz : OUT std_logic
		);
END COMPONENT;


COMPONENT BIT_ERROR
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		bit_recibido : IN std_logic;
		bit_enviado : IN std_logic;
		flag_bit_recibido : IN std_logic;          
		flag_BIT_error : OUT std_logic
		);
END COMPONENT;
	
	
signal SALIDA_INTRODUCIDA : std_logic_vector (7 downto 0);
signal bits_sin_relleno : STD_LOGIC;
signal flag_tiempo_bit: STD_LOGIC;
signal flag_bit_sin_relleno: STD_LOGIC;
signal bus_idle: STD_LOGIC;
signal inicio_recepcion: STD_LOGIC;
signal indicador_error: STD_LOGIC;
signal inicio_anticipado_out: STD_LOGIC;
signal flag_bit_error: STD_LOGIC;
signal flag_bit_recibido: STD_LOGIC;
signal flag_stuff_error: STD_LOGIC;
signal bits_totales: integer;
signal fin_bits: STD_LOGIC;
signal bit_recibido: STD_LOGIC;
signal clk10Mhz: STD_LOGIC;
signal tx_tmp : STD_LOGIC;
signal flag_test,flag_test_2,aviso_bit_relleno: STD_LOGIC;	
signal introduccion_finalizada: STD_LOGIC;	
signal ID_A_ENVIAR: std_logic_vector( 10 downto 0);
signal DATO_A_MOSTRAR: std_logic_vector( 7 downto 0);
signal RTR_A_ENVIAR: STD_LOGIC;
signal mostrar_entrada_salida: STD_LOGIC;
signal reloj1hz: std_logic;
signal visualizar_modificar: STD_LOGIC;


COMPONENT BCD_7
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		dato_desde_operacion : IN std_logic_vector(7 downto 0);
		ID_A_MOSTRAR : IN std_logic_vector(10 downto 0);
		SALIDA_INTRODUCIDA : IN std_logic_vector(7 downto 0);
		mostrar_entrada_salida : IN std_logic;
		visualizar_modificar : IN std_logic;          
		bcd_0 : OUT std_logic_vector(7 downto 0);
		bcd_2 : OUT std_logic_vector(7 downto 0);
		bcd_4 : OUT std_logic_vector(7 downto 0);
		bcd_5 : OUT std_logic_vector(7 downto 0)
		);
END COMPONENT;
	
	
	
begin

tx <= tx_tmp;
indicador_errorr<=indicador_error;

Inst_operaciones_NODO_CONTROL: operaciones_NODO_CONTROL PORT MAP(
		clk => clk,
		reset => reset,
		introduccion_finalizada => introduccion_finalizada,
		SALIDA_INTRODUCIDA => SALIDA_INTRODUCIDA,
		mostrar_entrada_salida => mostrar_entrada_salida,
		ID_A_ENVIAR => ID_A_ENVIAR,
		RTR_A_ENVIAR => RTR_A_ENVIAR,
		DATO_A_MOSTRAR => DATO_A_MOSTRAR,
		bit_sin_relleno => bits_sin_relleno,
		flag_tiempo_bit => flag_tiempo_bit,
		flag_bits_sin_relleno => flag_bit_sin_relleno ,
		bus_idle => bus_idle,
		inicio_recepcion => inicio_recepcion,
		indicador_error => indicador_error,
		inicio_anticipado_out => inicio_anticipado_out,
		flag_bit_error => flag_bit_error,
		flag_stuff_error => flag_stuff_error,
		bits_totales => bits_totales,
		BIT_OUT => tx_tmp,
		fin_bits => fin_bits
	);


Inst_relojj_1hz: relojj_1hz PORT MAP(
		clk => clk,
		reset => reset,
		reloj1hz => reloj1hz
	);
	

Inst_BOTONERA: BOTONERA PORT MAP(
		clk1hz => reloj1hz, ---reloj1hz es la señal real; clk para TB
		reset => reset,
		ENTRADA_SALIDA => ENTRADA_SALIDA,
		MODIFICAR_SOLICITAR => MODIFICAR_SOLICITAR,
		ACEPTAR => ACEPTAR,
		MAS => MAS,
		MENOS => MENOS,
		visualizar_modificar =>  visualizar_modificar,
		mostrar_entrada_salida => mostrar_entrada_salida,
		ID_A_ENVIAR => ID_A_ENVIAR,
		RTR_A_ENVIAR => RTR_A_ENVIAR,
		introduccion_finalizada => introduccion_finalizada,
		SALIDA_INTRODUCIDA => SALIDA_INTRODUCIDA
	);

Inst_STUFF_ERROR: STUFF_ERROR PORT MAP(
		clk => clk,
		reset => reset,
		inicio_anticipado => inicio_anticipado_out,
		inicio_recepcion => inicio_recepcion,
		flag_bit_recibido => flag_bit_recibido,
		bit_recibido => bit_recibido,
		flag_stuff_error => flag_stuff_error
	);
	
	
Inst_receptor: receptor PORT MAP(
		clk10Mhz => clk10Mhz,
		clk => clk,
		reset => reset,
		rx => rx,
		bus_idle => bus_idle,
		inicio_recepcion => inicio_recepcion,
		flag_bit_recibido => flag_bit_recibido,
		flag_tiempo_bit => flag_tiempo_bit,
		flag_test => flag_test,
		flag_test_2 => flag_test_2,
		bit_recibido => bit_recibido
	);	
	
	
Inst_relleno_bits_receptor: relleno_bits_receptor PORT MAP(
		clk => clk,
		reset => reset,
		bit_recibido => bit_recibido,
		flag_bit_recibido => flag_bit_recibido,
		bits_sin_relleno => bits_sin_relleno,
		aviso_bit_relleno => aviso_bit_relleno,
		inicio_anticipado => inicio_anticipado_out,
		indicador_error => indicador_error,
		flag_bit_sin_relleno => flag_bit_sin_relleno,
		fin_bits => fin_bits
	);	
	
	
Inst_reloj_10Mhz: reloj_10Mhz PORT MAP(
		clk => clk,
		reset => reset,
		relojj_10Mhz => clk10Mhz 
	);	
	
	
Inst_BIT_ERROR: BIT_ERROR PORT MAP(
		clk => clk,
		reset => reset,
		flag_BIT_error => flag_BIT_error,
		bit_recibido => bit_recibido,
		bit_enviado => tx_tmp,
		flag_bit_recibido => flag_bit_recibido 
	);	



Inst_BCD_7: BCD_7 PORT MAP(
		clk => clk,
		reset => reset,
		dato_desde_operacion => DATO_A_MOSTRAR,
		ID_A_MOSTRAR => ID_A_ENVIAR,
		SALIDA_INTRODUCIDA => SALIDA_INTRODUCIDA,
		mostrar_entrada_salida => mostrar_entrada_salida,
		visualizar_modificar => visualizar_modificar,
		bcd_0 => bcd_0,
		bcd_2 => bcd_2,
		bcd_4 => bcd_4,
		bcd_5 => bcd_5
	);

	
end Behavioral;

