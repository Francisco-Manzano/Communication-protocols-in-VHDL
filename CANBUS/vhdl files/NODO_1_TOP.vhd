----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:48:15 09/10/2020 
-- Design Name: 
-- Module Name:    NODO_1_TOP - Behavioral 
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

entity NODO_1_TOP is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           rx : in  STD_LOGIC;
           tx : out  STD_LOGIC;
           ENTRADA1 : in  STD_LOGIC;
           ENTRADA2 : in  STD_LOGIC;
           SALIDA1 : out  STD_LOGIC;
           SALIDA2 : out  STD_LOGIC);
end NODO_1_TOP;

architecture Behavioral of NODO_1_TOP is



COMPONENT operaciones
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		entradas : IN std_logic_vector(7 downto 0);
		bit_sin_relleno : IN std_logic;
		flag_tiempo_bit : IN std_logic;
		flag_bits_sin_relleno : IN std_logic;
		inicio_recepcion : IN std_logic;
		flag_bit_error : IN std_logic;
		flag_stuff_error : IN std_logic;          
		bus_idle : OUT std_logic;
		SALIDA_1 : OUT std_logic;
		SALIDA_2 : OUT std_logic;
		indicador_error : OUT std_logic;
		inicio_anticipado_out : OUT std_logic;
		bits_totales : OUT integer;
		BIT_OUT : OUT std_logic;
		fin_bits : OUT std_logic
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


signal entradas : std_logic_vector (7 downto 0):="00000000";
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

begin

entradas(1) <= ENTRADA2;
entradas(0) <= ENTRADA1;
tx <= tx_tmp;

Inst_operaciones: operaciones PORT MAP(
		clk => clk,
		reset => reset,
		entradas => entradas,
		bit_sin_relleno => bits_sin_relleno,
		flag_tiempo_bit => flag_tiempo_bit,
		flag_bits_sin_relleno => flag_bit_sin_relleno,
		bus_idle => bus_idle,
		inicio_recepcion => inicio_recepcion,
		SALIDA_1 => SALIDA1,
		SALIDA_2 => SALIDA2,
		indicador_error => indicador_error,
		inicio_anticipado_out => inicio_anticipado_out,
		flag_bit_error => flag_bit_error,
		flag_stuff_error => flag_stuff_error,
		bits_totales => bits_totales,
		BIT_OUT => tx_tmp,
		fin_bits => fin_bits
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
	
	
	
	
	
	
	
	

end Behavioral;

