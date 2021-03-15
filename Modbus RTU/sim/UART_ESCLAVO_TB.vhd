--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:53:34 12/02/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/MODBUSS/MODBUS/UART_ESCLAVO_TB.vhd
-- Project Name:  MODBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: UART_ESCLAVO
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
 
ENTITY UART_ESCLAVO_TB IS
END UART_ESCLAVO_TB;
 
ARCHITECTURE behavior OF UART_ESCLAVO_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UART_ESCLAVO
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         datos_completos : IN  std_logic_vector(120 downto 0);
         datos_recibidos : OUT  std_logic_vector(7 downto 0);
         bytes_a_enviar : IN  INTEGER;
         tx_inicio : IN  std_logic;
		 LED_TX_INICIADA_ESCLAVO: out STD_LOGIC;
		 LED_RX_RECIBIDO_ESCLAVO: out STD_LOGIC;
         flag_fin_recepcion : OUT  std_logic;
         flag_byte_recibido : OUT  std_logic;
         numerobytes_recibidos : OUT  INTEGER;
         rx : IN  std_logic;
         tx : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal datos_completos : std_logic_vector(120 downto 0) := (others => '0');
   signal bytes_a_enviar : INTEGER := 0;
   signal tx_inicio : std_logic := '0';
   signal rx : std_logic := '0';

 	--Outputs
   signal datos_recibidos : std_logic_vector(7 downto 0);
   signal LED_RX_RECIBIDO_ESCLAVO: std_logic;
   signal LED_TX_INICIADA_ESCLAVO: std_logic;
   signal flag_fin_recepcion : std_logic;
   signal flag_byte_recibido : std_logic;
   signal numerobytes_recibidos : INTEGER;
   signal tx : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
   constant uart_periodo : time := 8680 ns;  -- 1/115200
	
	procedure UART_tb_recibir (
		i_data_in       : in  std_logic_vector(7 downto 0);
		signal o_serial : out std_logic) is
		begin
 
    -- recibe bit_inicio
    o_serial <= '0';
    wait for uart_periodo;
 
    -- recibe bits_datos
    for ii in 0 to 7 loop
      o_serial <= i_data_in(ii);
      wait for uart_periodo;
    end loop;  -- ii
 
    -- recibe bit stop 1
    o_serial <= '1';
    wait for uart_periodo;
	 
	 -- recibe bit stop 2
    o_serial <= '1';
    wait for uart_periodo;
	 
	 end UART_tb_recibir;	
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: UART_ESCLAVO PORT MAP (
          clk => clk,
          reset => reset,
          datos_completos => datos_completos,
          datos_recibidos => datos_recibidos,
          bytes_a_enviar => bytes_a_enviar,
          tx_inicio => tx_inicio,
		  LED_RX_RECIBIDO_ESCLAVO => LED_RX_RECIBIDO_ESCLAVO,
		  LED_TX_INICIADA_ESCLAVO => LED_TX_INICIADA_ESCLAVO,
          flag_fin_recepcion => flag_fin_recepcion,
          flag_byte_recibido => flag_byte_recibido,
          numerobytes_recibidos => numerobytes_recibidos,
          rx => rx,
          tx => tx
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
	 
			reset <= '1';
			wait for clk_period*3;
			reset <= '0';	
			wait for 1 us;			
			
			UART_tb_recibir(X"01", rx);											
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			UART_tb_recibir(X"02", rx);											
			
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			UART_tb_recibir(X"01", rx);											
			
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			UART_tb_recibir(X"03", rx);											
			
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			bytes_a_enviar <= 4;
			datos_completos <=(others=>'0');
			datos_completos (31 downto 0) <= X"0F030201";
			wait for 1 ms;
			
			tx_inicio <= '1';
			wait for clk_period*5;
			tx_inicio <= '0';
			
			
	 
	  
	 -- rx <= '1';
	  

      -- insert stimulus here 

      wait;
   end process;

END;
