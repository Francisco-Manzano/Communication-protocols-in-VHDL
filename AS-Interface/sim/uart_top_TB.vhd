--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:22:37 08/02/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/AS-Interface/uart_top_TB.vhd
-- Project Name:  AS-Interface
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: uart_top
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
use IEEE.NUMERIC_STD.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY uart_top_TB IS
END uart_top_TB;
 
ARCHITECTURE behavior OF uart_top_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uart_top
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
		 rx_tx: INOUT std_logic;
         tx_inicio : IN  std_logic;
         tx_activo : OUT  std_logic;
         tx_fin : OUT  std_logic;
         rx_fin : OUT  std_logic;
         datos : IN  std_logic_vector(10 downto 0);
         esclavo_off : OUT  std_logic_vector(1 downto 0);
         datos_recibidos : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal tx_inicio : std_logic := '0';
   signal datos : std_logic_vector(10 downto 0) := (others => '0');

 	--Outputs
   signal tx_activo : std_logic;
   signal tx_fin : std_logic;
   signal rx_fin : std_logic;
   signal esclavo_off : std_logic_vector(1 downto 0);
   signal datos_recibidos : std_logic_vector(3 downto 0);
   
   --inouts

   signal rx_tx : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
   constant uart_periodo : time := 6 us;  -- tiempo de bit
   
   procedure UART_tb_recibir (
		i_data_in       : in  std_logic_vector(4 downto 0);
		signal o_serial : out std_logic) is
		begin
 
    -- recibe bit_inicio
    o_serial <= '0';
    wait for uart_periodo;
 
    -- recibe bits_datos y bit_paridad
    for ii in 0 to 4 loop
      o_serial <= i_data_in(4-ii);
      wait for uart_periodo;
    end loop;  -- ii
 
    -- recibe bit stop 1
    o_serial <= '1';
    wait for uart_periodo;
	 
	
	 end UART_tb_recibir;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uart_top PORT MAP (
          clk => clk,
          reset => reset,
		  rx_tx => rx_tx,
          tx_inicio => tx_inicio,
          tx_activo => tx_activo,
          tx_fin => tx_fin,
          rx_fin => rx_fin,
          datos => datos,
          esclavo_off => esclavo_off,
          datos_recibidos => datos_recibidos
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
		 
		 reset <='1';
		 wait for clk_period*3;
		 reset <= '0';
		 rx_tx <= 'Z';
		 wait for clk_period*2;
		 datos<= "10101010100";
		 wait for 20 us;
		 tx_inicio   <= '1';
		 wait until rising_edge(clk);
		 tx_inicio   <= '0';
		 wait until tx_fin ='1';
		 wait for clk_period*5;
		 
		 -- envia datos desde esclavo UART_tb
		wait until rising_edge(clk);
		UART_tb_recibir("10100",rx_tx);
		 rx_tx <= 'Z';
		-- wait for clk_period*2;
		-- reset <='1';
		 -- wait for clk_period*3;
		 -- reset <= '0';
		
		wait for clk_period*5;
		 datos<= "01010101100";
		 wait for clk_period*2;
		 wait for 40 us;
		 tx_inicio   <= '1';
		 wait until rising_edge(clk);
		 tx_inicio   <= '0';
		 wait until tx_fin ='1';
		 wait for clk_period*5;

		 wait until rising_edge(clk);
		UART_tb_recibir("01010",rx_tx);
		 rx_tx <= 'Z';
		 
		 
		
		
		 
      wait;
   end process;

END;
