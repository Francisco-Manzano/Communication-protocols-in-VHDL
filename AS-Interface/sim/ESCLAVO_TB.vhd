--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:08:51 08/12/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/AS-Interface/ESCLAVO_TB.vhd
-- Project Name:  AS-Interface
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ESCLAVO_A
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
 
ENTITY ESCLAVO_TB IS
END ESCLAVO_TB;
 
ARCHITECTURE behavior OF ESCLAVO_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ESCLAVO_A
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         ENTRADA1 : IN  std_logic;
         ENTRADA2 : IN  std_logic;
         esclavo_encendido : IN  std_logic;
         SALIDA1 : OUT  std_logic;
         SALIDA2 : OUT  std_logic;
         rx_tx : INOUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal ENTRADA1 : std_logic := '0';
   signal ENTRADA2 : std_logic := '0';
   signal esclavo_encendido : std_logic := '0';

	--BiDirs
   signal rx_tx : std_logic;

 	--Outputs
   signal SALIDA1 : std_logic:= '0';
   signal SALIDA2 : std_logic :='0';

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
   uut: ESCLAVO_A PORT MAP (
          clk => clk,
          reset => reset,
          ENTRADA1 => ENTRADA1,
          ENTRADA2 => ENTRADA2,
          esclavo_encendido => esclavo_encendido,
          SALIDA1 => SALIDA1,
          SALIDA2 => SALIDA2,
          rx_tx => rx_tx
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
	  
	    wait for clk_period*10;
		esclavo_encendido <='1';
		wait for 5 us;
		reset<='1';
		wait for clk_period*2;
		reset <='0';
		wait for 5 us;
      -- insert stimulus here 
		wait until rising_edge(clk);
		UART_tb_recibir("000011101101",rx_tx);
		wait for clk_period*1;
		rx_tx <= 'Z';
		wait for 70 us;
		
		wait until rising_edge(clk);
		UART_tb_recibir("000011000110",rx_tx);
		wait for clk_period*1;
		rx_tx <= 'Z';
		wait for 70 us;
		
		reset <='1';
		wait for clk_period*1;
		reset<= '0';
		
		ENTRADA1<='1';
		ENTRADA2<='1';
		
		wait until rising_edge(clk);
		UART_tb_recibir("000011000110",rx_tx);
		wait for clk_period*1;
		rx_tx <= 'Z';
		wait for 70 us;
		
		
	  
	  
	  
	  
	  

      wait;
   end process;

END;
