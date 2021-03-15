--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:01:43 09/12/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/CANBUS/CANBUS/contador_errores_TB.vhd
-- Project Name:  CANBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: contador_errores
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY contador_errores_TB IS
END contador_errores_TB;
 
ARCHITECTURE behavior OF contador_errores_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT contador_errores
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         transmisor_activo : IN  std_logic;
         flag_mensaje_aceptado : IN  std_logic;
         error_delimiter_flag : IN  std_logic;
         error_transmisor_flag : IN  std_logic;
         overload_transmisor_flag : IN  std_logic;
         overload_delimiter_flag : IN  std_logic;
		 BUS_OFF : OUT std_logic;
         bit_sin_relleno : IN  std_logic;
         modulo_errores_pas_flag : OUT  std_logic;
         ACK_ERROR : IN  std_logic;
         flag_bits_sin_relleno : IN  std_logic;
         cuenta_bits_dominantes : IN  integer;
         bit_dominante : IN  std_logic;
         e : IN  integer
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal transmisor_activo : std_logic := '0';
   signal flag_mensaje_aceptado : std_logic := '0';
   signal error_delimiter_flag : std_logic := '0';
   signal error_transmisor_flag : std_logic := '0';
   signal overload_transmisor_flag : std_logic := '0';
   signal overload_delimiter_flag : std_logic := '0';
   signal bit_sin_relleno : std_logic := '0';
   signal ACK_ERROR : std_logic := '0';
   signal flag_bits_sin_relleno : std_logic := '0';
   signal cuenta_bits_dominantes : integer := 0;
   signal bit_dominante : std_logic := '0';
   signal e : integer := 0;

 	--Outputs
   signal modulo_errores_pas_flag : std_logic;
   signal BUS_OFF : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: contador_errores PORT MAP (
          clk => clk,
          reset => reset,
          transmisor_activo => transmisor_activo,
          flag_mensaje_aceptado => flag_mensaje_aceptado,
          error_delimiter_flag => error_delimiter_flag,
          error_transmisor_flag => error_transmisor_flag,
          overload_transmisor_flag => overload_transmisor_flag,
          overload_delimiter_flag => overload_delimiter_flag,
          bit_sin_relleno => bit_sin_relleno,
          modulo_errores_pas_flag => modulo_errores_pas_flag,
          ACK_ERROR => ACK_ERROR,
		  BUS_OFF => BUS_OFF,
          flag_bits_sin_relleno => flag_bits_sin_relleno,
          cuenta_bits_dominantes => cuenta_bits_dominantes,
          bit_dominante => bit_dominante,
          e => e
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
	  
		reset <= '1';
		wait for clk_period;
		reset <= '0';
		transmisor_activo <= '0'; --MODO RECEPTOR			
		wait for clk_period*5;
		
		
		for i in 0 to 140 loop
				
			error_transmisor_flag <='1';
			wait for clk_period;
			error_transmisor_flag <='0';
			wait for clk_period*5;
			error_delimiter_flag <= '1';
			wait for clk_period*5;
			error_delimiter_flag <= '0';
			wait for clk_period*5;
			bit_sin_relleno <= '1';
			wait for clk_period*5;
			e <= 8;
			wait for clk_period*5;
			e <= 0;
			bit_sin_relleno <= '0';
		
		end loop;
		
		for i in 0 to 150 loop
		
			flag_mensaje_aceptado <='1';
			wait for clk_period*1;
			flag_mensaje_aceptado <='0';
			wait for clk_period*2;
		
		end loop;
		
		
		
		
		for i in 0 to 140 loop
				
			error_transmisor_flag <='1';
			wait for clk_period;
			error_transmisor_flag <='0';
			wait for clk_period*5;
			error_delimiter_flag <= '1';
			wait for clk_period*5;
			error_delimiter_flag <= '0';
			wait for clk_period*5;
			bit_sin_relleno <= '1';
			wait for clk_period*5;
			e <= 8;
			wait for clk_period*5;
			e <= 0;
			bit_sin_relleno <= '0';
		
		end loop;
		
		ACK_ERROR <='1';
		wait for clk_period*1;	
		ACK_ERROR <='0';
		bit_dominante <='0';
		wait for clk_period*2;
		
		error_delimiter_flag <='1';
		wait for clk_period*1;
		error_delimiter_flag<= '0';
		
		wait for clk_period*2;
		
		e<=8;
		bit_sin_relleno <='1';
		wait for clk_period;
		e <= 0;
		bit_sin_relleno <= '0';
		
		
		transmisor_activo <= '1';

		
		for i in 0 to 140 loop
				
			error_transmisor_flag <='1';
			wait for clk_period;
			error_transmisor_flag <='0';
			wait for clk_period*5;
			error_delimiter_flag <= '1';
			wait for clk_period*5;
			error_delimiter_flag <= '0';
			wait for clk_period*5;
			bit_sin_relleno <= '1';
			wait for clk_period*5;
			e <= 8;
			wait for clk_period*5;
			e <= 0;
			bit_sin_relleno <= '0';
		
		end loop;
		transmisor_activo <= '0';
		
		for i in 0 to 140 loop
				
			error_transmisor_flag <='1';
			wait for clk_period;
			error_transmisor_flag <='0';
			wait for clk_period*5;
			error_delimiter_flag <= '1';
			wait for clk_period*5;
			error_delimiter_flag <= '0';
			wait for clk_period*5;
			bit_sin_relleno <= '1';
			wait for clk_period*5;
			e <= 8;
			wait for clk_period*5;
			e <= 0;
			bit_sin_relleno <= '0';
		
		end loop;
		
		for i in 0 to 1500 loop
		
			flag_mensaje_aceptado <='1';
			wait for clk_period*1;
			flag_mensaje_aceptado <='0';
			wait for clk_period*2;
		
		end loop;
		
		transmisor_activo <= '1';
		
		for i in 0 to 1500 loop
		
			flag_mensaje_aceptado <='1';
			wait for clk_period*1;
			flag_mensaje_aceptado <='0';
			wait for clk_period*2;
		
		end loop;
		
		wait for clk_period*2;
		overload_transmisor_flag <='1';
		transmisor_activo <= '1';
		cuenta_bits_dominantes <=14;
			
		wait for clk_period*2;
		
		flag_bits_sin_relleno <='1';
		wait for clk_period*1;
		flag_bits_sin_relleno <='0';
		cuenta_bits_dominantes <=15;
		wait for clk_period*5;
		
		flag_bits_sin_relleno <='1';
		wait for clk_period*1;
		flag_bits_sin_relleno <='0';
		
		wait for clk_period*5;
		cuenta_bits_dominantes <=22;
		
		flag_bits_sin_relleno <='1';
		wait for clk_period*1;
		flag_bits_sin_relleno <='0';
		
		
		wait for clk_period*5;
		transmisor_activo <='0';
		flag_bits_sin_relleno <='1';
		wait for clk_period*1;
		flag_bits_sin_relleno <='0';
		
		overload_transmisor_flag <='0';
		overload_delimiter_flag<='1';
		wait for clk_period;
		overload_delimiter_flag<='0';
		wait for clk_period*5;
		transmisor_activo <='0';
		wait for clk_period*5;
		error_transmisor_flag <='1';
		wait for clk_period;
		error_transmisor_flag <='0';
		
		
		transmisor_activo <='1';
		wait for clk_period*5;
		error_transmisor_flag <='1';
		wait for clk_period;
		error_transmisor_flag <='0';
		cuenta_bits_dominantes <= 7;
		bit_sin_relleno <='0';
		wait for clk_period*5;
		transmisor_activo <='0';
		
		wait for clk_period*5;
		transmisor_activo <='1';
		cuenta_bits_dominantes <= 8;
		wait for clk_period*2;
		error_delimiter_flag <='1';
		wait for clk_period*1;
		
      wait;
   end process;

END;
