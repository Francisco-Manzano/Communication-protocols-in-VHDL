--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:49:13 05/06/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/MODBUS/unidad_control_tb.vhd
-- Project Name:  MODBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: unidad_control
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
 
ENTITY unidad_control_tb IS
END unidad_control_tb;
 
ARCHITECTURE behavior OF unidad_control_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT unidad_control
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         switch_comando_siguiente_SR : IN  std_logic;
		 switch_datos_recibidos_SR: in STD_LOGIC;
         switch_inicio_transmision_SR : IN  std_logic;
         comando_actual : OUT  std_logic_vector(8 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal switch_datos_recibidos_SR:std_logic:='0';
   signal switch_comando_siguiente_SR : std_logic := '0';
   signal switch_inicio_transmision_SR : std_logic := '0';

 	--Outputs
   signal comando_actual : std_logic_vector(8 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: unidad_control PORT MAP (
          clk => clk,
          reset => reset,  
switch_datos_recibidos_SR => switch_datos_recibidos_SR,		  
          switch_comando_siguiente_SR => switch_comando_siguiente_SR,
          switch_inicio_transmision_SR => switch_inicio_transmision_SR,
          comando_actual => comando_actual
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

      -- insert stimulus here 
		reset<='1';
		 wait for clk_period*2;
		reset <='0';
		 wait for clk_period*2;
		switch_comando_siguiente_SR <='1';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='0';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='1';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='0';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='1';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='0';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='1';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='0';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='1';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='0';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='1';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='0';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='1';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='0';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='1';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='0';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='1';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='0';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='1';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='0';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='1';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='0';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='1';
		wait for clk_period*2;
		switch_comando_siguiente_SR <='0';
		wait for clk_period*2;
		
		
		
		
		
		
		
		
		
      wait;
   end process;

END;
