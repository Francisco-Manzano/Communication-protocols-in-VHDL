--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:45:55 08/25/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/CANBUS/CANBUS/relleno_bits_receptor_TB.vhd
-- Project Name:  CANBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: relleno_bits_receptor
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
 
ENTITY relleno_bits_receptor_TB IS
END relleno_bits_receptor_TB;
 
ARCHITECTURE behavior OF relleno_bits_receptor_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT relleno_bits_receptor
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         bit_recibido : IN  std_logic;
		 inicio_anticipado: in STD_LOGIC;
         flag_bit_recibido : IN  std_logic;
		 aviso_bit_relleno: out STD_LOGIC;
         bits_sin_relleno : OUT  std_logic;
         flag_bit_sin_relleno : OUT  std_logic;
         fin_bits : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal inicio_anticipado: std_logic := '0';
   signal reset : std_logic := '0';
   signal bit_recibido : std_logic := '0';
   signal flag_bit_recibido : std_logic := '0';
   signal fin_bits : std_logic := '0';

 	--Outputs
   signal bits_sin_relleno : std_logic;
   signal flag_bit_sin_relleno : std_logic;
   SIGNAL aviso_bit_relleno: STD_LOGIC;	
   
   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: relleno_bits_receptor PORT MAP (
          clk => clk,
          reset => reset,
          bit_recibido => bit_recibido,
		  inicio_anticipado => inicio_anticipado,
          flag_bit_recibido => flag_bit_recibido,
		  aviso_bit_relleno => aviso_bit_relleno,
          bits_sin_relleno => bits_sin_relleno,
          flag_bit_sin_relleno => flag_bit_sin_relleno,
          fin_bits => fin_bits
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
		wait for clk_period*3;
		reset <= '0';
		wait for clk_period*10;
		flag_bit_recibido<='1';
		wait for clk_period*10;
		flag_bit_recibido <= '0';
		wait for clk_period*3;
		wait for clk_period*3;
		flag_bit_recibido <= '1'; --bit1 1
		bit_recibido <= '1'; 
		wait for clk_period*5;		
		flag_bit_recibido <= '0';
		wait for clk_period*3;
		flag_bit_recibido <= '1';  --bit1 2
		wait for clk_period*5;
		flag_bit_recibido <= '0';
		wait for clk_period*5;
		flag_bit_recibido <= '1';   --bit1 3
		wait for clk_period*5;
		flag_bit_recibido <= '0';
		wait for clk_period*5;
		flag_bit_recibido <= '1';  --bit1 4
		wait for clk_period*5;
		flag_bit_recibido <= '0';
		wait for clk_period*5;
		flag_bit_recibido <= '1';  --bit1 5
		wait for clk_period*5;
		flag_bit_recibido <= '0';
		wait for clk_period*5;
		flag_bit_recibido <= '1';  --bit1 6 NO DEBERIA ACEPTARLO
		wait for clk_period*5;
		flag_bit_recibido <= '0';
		wait for clk_period*5;
		flag_bit_recibido <= '1';  --bit1 1 de nuevo
		wait for clk_period*5;
		flag_bit_recibido <= '0';
		wait for clk_period*5;
		flag_bit_recibido <= '1';  --bit1 2 de nuevo
		wait for clk_period*5;
		flag_bit_recibido <= '0';
		bit_recibido <= '0'; 
		wait for clk_period*5;
		flag_bit_recibido <= '1';   --bit0 1
		wait for clk_period*5;
		flag_bit_recibido <= '0';
		wait for clk_period*5;
		flag_bit_recibido <= '1';   --bit0 2
		wait for clk_period*5;
		flag_bit_recibido <= '0';
		bit_recibido <= '1';
		wait for clk_period*5;
		flag_bit_recibido <= '1';    --bit1 1
		wait for clk_period*5;
		flag_bit_recibido <= '0';
		wait for clk_period*5;
		flag_bit_recibido <= '1';    --bit1 1
		wait for clk_period*5;
		flag_bit_recibido <= '0';
		bit_recibido <= '0';
		wait for clk_period*5;
		flag_bit_recibido <= '1';    --bit0 1
		wait for clk_period*5;
		flag_bit_recibido <= '0'; 
		wait for clk_period*5;
		flag_bit_recibido <= '1';    --bit0 2
		wait for clk_period*5;
		flag_bit_recibido <= '0'; 
		wait for clk_period*5;
		flag_bit_recibido <= '1';    --bit0 3
		wait for clk_period*5;
		flag_bit_recibido <= '0'; 
		wait for clk_period*5;
		flag_bit_recibido <= '1';    --bit0 4
		wait for clk_period*5;
		flag_bit_recibido <= '0'; 
		wait for clk_period*5;
		flag_bit_recibido <= '1';    --bit0 5
		wait for clk_period*5;
		flag_bit_recibido <= '0'; 
		wait for clk_period*5;
		flag_bit_recibido <= '1';    --bit0 6 NO DEBERIA ACEPTARLO
		wait for clk_period*5;
		flag_bit_recibido <= '0'; 
		wait for clk_period*5;
		flag_bit_recibido <= '1';    --bit0 1
		wait for clk_period*5;
		flag_bit_recibido <= '0'; 
		reset <= '1';
		wait for clk_period*5;
		reset <= '0';
		wait for clk_period*5;
		flag_bit_recibido <= '1';    --bit0 1
		wait for clk_period*5;
		flag_bit_recibido <= '0'; 
		wait for clk_period*5;
		flag_bit_recibido <= '1';    --bit0 2
		wait for clk_period*5;
		flag_bit_recibido <= '0'; 
		wait for clk_period*5;
		flag_bit_recibido <= '1';    --bit0 3
		wait for clk_period*5;
		flag_bit_recibido <= '0'; 
		fin_bits <='1';
		
		
		wait for clk_period*5;
		flag_bit_recibido <= '1';    --bit0 1
		wait for clk_period*5;
		flag_bit_recibido <= '0'; 
		wait for clk_period*5;
		flag_bit_recibido <= '1';    --bit0 2
		wait for clk_period*5;
		flag_bit_recibido <= '0'; 
		wait for clk_period*5;
		flag_bit_recibido <= '1';    --bit0 3
		wait for clk_period*5;
		flag_bit_recibido <= '0'; 
		wait for clk_period*5;
		flag_bit_recibido <= '1';    --bit0 1
		wait for clk_period*5;
		flag_bit_recibido <= '0'; 
		wait for clk_period*5;
		flag_bit_recibido <= '1';    --bit0 2
		wait for clk_period*5;
		flag_bit_recibido <= '0'; 
		wait for clk_period*5;
		flag_bit_recibido <= '1';    --bit0 3
		wait for clk_period*5;
		flag_bit_recibido <= '0'; 
		
		
		

      wait;
   end process;

END;
