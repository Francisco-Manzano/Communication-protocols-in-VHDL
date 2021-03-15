--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:21:46 05/18/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/MODBUS/MODBUS_TOP_TB.vhd
-- Project Name:  MODBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MODBUS_TOP
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
 
ENTITY MODBUS_TOP_TB IS
END MODBUS_TOP_TB;
 
ARCHITECTURE behavior OF MODBUS_TOP_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MODBUS_TOP
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         switch_comando_siguiente : IN  std_logic;
         switch_inicio_transmision : IN  std_logic;
		 switch_datos_recibidos: in STD_LOGIC;
         MAS : IN  std_logic;
         MENOS : IN  std_logic;
         SIGUIENTE_REGISTRO : IN  std_logic;
         tx : OUT  std_logic;
		 LED_CRC: out std_logic:='0';
		  LED_RX_finalizada: out STD_LOGIC:='0'; --TEST
         LED_TX_iniciada : OUT  std_logic;
         bcd7 : OUT  std_logic_vector(47 downto 0);
         rx : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal switch_comando_siguiente : std_logic := '0';
   signal switch_inicio_transmision : std_logic := '0';
   signal MAS : std_logic := '0';
   signal MENOS : std_logic := '0';
   SIGNAL switch_datos_recibidos: std_logic:='0';
   signal SIGUIENTE_REGISTRO : std_logic := '0';
   signal rx : std_logic := '0';

 	--Outputs
   signal tx : std_logic;
   signal LED_CRC: STD_LOGIC;
   signal LED_RX_finalizada: STD_LOGIC;
   signal LED_TX_iniciada : std_logic;
   signal bcd7 : std_logic_vector(47 downto 0);

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
   uut: MODBUS_TOP PORT MAP (
          clk => clk,
          reset => reset,
          switch_comando_siguiente => switch_comando_siguiente,
          switch_inicio_transmision => switch_inicio_transmision,
          MAS => MAS,
          MENOS => MENOS,
		  switch_datos_recibidos => switch_datos_recibidos,
		  LED_RX_finalizada => LED_RX_finalizada,
		  LED_CRC => LED_CRC,
          SIGUIENTE_REGISTRO => SIGUIENTE_REGISTRO,
          tx => tx,
          LED_TX_iniciada => LED_TX_iniciada,
          bcd7 => bcd7,
          rx => rx
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
		
		 reset<='1';
		 MAS <= '1';
		 MENOS <= '1';
		 rx <= '1';
		 wait for clk_period*4;	
		 reset<='0';
		 wait for clk_period*3;
		 switch_comando_siguiente<='1';
		 wait for clk_period;
		 switch_comando_siguiente<='0';
		  wait for clk_period*4;	
		 MAS <='0';
		 wait for clk_period;
		 MAS <='1';
		 wait for clk_period*4;
		
		 switch_comando_siguiente<='1';
		 wait for clk_period;	 
		 switch_comando_siguiente<='0';	 
		  wait for clk_period*4;	
		 MAS <='0';
		 wait for clk_period;
		 MAS <='1';
		 wait for clk_period*4;
		 
		 
		 switch_comando_siguiente<='1';
		 wait for clk_period*2;
		 switch_comando_siguiente<='0';
		  wait for clk_period*4;	
		  MAS <='0';
		 wait for clk_period;
		 MAS <='1';
		 wait for clk_period*4;
		switch_inicio_transmision <='1';
		 wait for 15 ms;
		--switch_inicio_transmision <='0';
		
			wait until rising_edge(clk);
			UART_tb_recibir(X"01",rx);
			wait until rising_edge(clk);
			UART_tb_recibir(X"01", rx);
			wait until rising_edge(clk);
			UART_tb_recibir(X"01",rx);
			wait until rising_edge(clk);
			UART_tb_recibir(X"f0", rx);
			wait for 5 ms;
		
		
      wait;
   end process;

END;
