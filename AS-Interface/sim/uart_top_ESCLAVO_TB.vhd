--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:32:50 08/11/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/AS-Interface/uart_top_ESCLAVO_TB.vhd
-- Project Name:  AS-Interface
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: uart_top_ESCLAVO
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
 
ENTITY uart_top_ESCLAVO_TB IS
END uart_top_ESCLAVO_TB;
 
ARCHITECTURE behavior OF uart_top_ESCLAVO_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uart_top_ESCLAVO
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         tx_activado : IN  std_logic;
         rx_tx : INOUT  std_logic;
         datos_a_enviar : IN  std_logic_vector(3 downto 0);
         esclavo_encendido : IN  std_logic;
         rx_valido : OUT  std_logic;
         datos_completos : OUT  std_logic_vector(10 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal tx_activado : std_logic := '0';
   signal datos_a_enviar : std_logic_vector(3 downto 0) := (others => '0');
   signal esclavo_encendido : std_logic := '0';

	--BiDirs
   signal rx_tx : std_logic:= '1';

 	--Outputs
   signal rx_valido : std_logic;
   signal datos_completos : std_logic_vector(10 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
   constant uart_periodo : time := 6 us;  -- tiempo de bit
   
   procedure UART_tb_recibir (
		i_data_in       : in  std_logic_vector(11 downto 0);
		signal o_serial : out std_logic) is
		begin
 
    -- recibe bit_inicio
    o_serial <= '0';
    wait for uart_periodo;
 
    -- recibe bits_datos y bit_paridad
    for ii in 0 to 11 loop
      o_serial <= i_data_in(11-ii);
      wait for uart_periodo;
    end loop;  -- ii
 
    -- recibe bit stop 1
    o_serial <= '1';
    wait for uart_periodo;
	 
	
	 end UART_tb_recibir;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uart_top_ESCLAVO PORT MAP (
          clk => clk,
          reset => reset,
          tx_activado => tx_activado,
          rx_tx => rx_tx,
          datos_a_enviar => datos_a_enviar,
          esclavo_encendido => esclavo_encendido,
          rx_valido => rx_valido,
          datos_completos => datos_completos
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
		esclavo_encendido <='1';
		wait for 5 us;
		reset<='1';
		rx_tx <= '1';
		wait for clk_period*2;
		reset <='0';
		wait for 5 us;
      -- insert stimulus here 
		wait until rising_edge(clk);
		UART_tb_recibir("101101101000",rx_tx);
		rx_tx <= 'Z';
		wait for clk_period*5;
		datos_a_enviar<= "1110";
		wait for clk_period*2;
		tx_activado<='1';
		wait for clk_period*2;
		tx_activado<='0';
		
		--comprobando calculo de paridad recibida
		 wait for clk_period*10;
		 wait for 100 us;
		 wait until rising_edge(clk);
		UART_tb_recibir("101101101001",rx_tx);
		rx_tx <= 'Z';
		wait for clk_period*1;
		datos_a_enviar<= "1100";
		wait for clk_period*2;
		tx_activado<='1';
		wait for clk_period*2;
		tx_activado<='0';
		
		--comprobando calculo de paridad enviada
		 wait for clk_period*10;
		 wait for 100 us;
		 wait until rising_edge(clk);
		UART_tb_recibir("101101101000",rx_tx);
		rx_tx <= 'Z';
		wait for clk_period*5;
		datos_a_enviar<= "1010";
		wait for clk_period*2;
		tx_activado<='1';
		wait for clk_period*2;
		tx_activado<='0';
		
		
		
		
		

      wait;
   end process;

END;
