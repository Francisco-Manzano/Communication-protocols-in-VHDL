--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:25:38 12/03/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/MODBUSS/MODBUS/ESCLAVO_MODBUS_TB.vhd
-- Project Name:  MODBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ESCLAVO_MODBUS
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
 
ENTITY ESCLAVO_MODBUS_TB IS
END ESCLAVO_MODBUS_TB;
 
ARCHITECTURE behavior OF ESCLAVO_MODBUS_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ESCLAVO_MODBUS
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         rx : IN  std_logic;
         tx : OUT  std_logic;
		 LED_RX_RECIBIDO_ESCLAVO: out STD_LOGIC;
		 LED_TX_INICIADA_ESCLAVO: out STD_LOGIC;
         ENTRADA1 : IN  std_logic;
         ENTRADA2 : IN  std_logic;
         ENTRADA3 : IN  std_logic;
         ENTRADA4 : IN  std_logic;
         SALIDA1 : OUT  std_logic;
         SALIDA2 : OUT  std_logic;
         SALIDA3 : OUT  std_logic;
         SALIDA4 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal rx : std_logic := '0';
   signal ENTRADA1 : std_logic := '0';
   signal ENTRADA2 : std_logic := '0';
   signal ENTRADA3 : std_logic := '0';
   signal ENTRADA4 : std_logic := '0';

 	--Outputs
	signal LED_RX_RECIBIDO_ESCLAVO:std_logic;
	signal LED_TX_INICIADA_ESCLAVO:std_logic;
   signal tx : std_logic;
   signal SALIDA1 : std_logic;
   signal SALIDA2 : std_logic;
   signal SALIDA3 : std_logic;
   signal SALIDA4 : std_logic;

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
   uut: ESCLAVO_MODBUS PORT MAP (
          clk => clk,
          reset => reset,
          rx => rx,
          tx => tx,
		  LED_RX_RECIBIDO_ESCLAVO => LED_RX_RECIBIDO_ESCLAVO,
		  LED_TX_INICIADA_ESCLAVO => LED_TX_INICIADA_ESCLAVO,
          ENTRADA1 => ENTRADA1,
          ENTRADA2 => ENTRADA2,
          ENTRADA3 => ENTRADA3,
          ENTRADA4 => ENTRADA4,
          SALIDA1 => SALIDA1,
          SALIDA2 => SALIDA2,
          SALIDA3 => SALIDA3,
          SALIDA4 => SALIDA4
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
	  
		ENTRADA1 <= '1'; --POS0
		ENTRADA2 <= '0'; --POS1
		ENTRADA3 <= '1'; --POS2
		ENTRADA4 <= '1'; --POS3

			reset <= '1';
			wait for clk_period*3;
			reset <= '0';	
			wait for 1 us;	

				--FUNCION 2
			
			UART_tb_recibir(X"01", rx);		--DIR 1									
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			UART_tb_recibir(X"02", rx);			--FUNCION 2											
			wait for clk_period*5;
			wait until rising_edge(clk);
						
			UART_tb_recibir(X"00", rx);				--MEM							
			wait for clk_period*5;
			wait until rising_edge(clk);	
			
			UART_tb_recibir(X"01", rx);				--MEM	 1									
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			UART_tb_recibir(X"00", rx);				--COILS PEDIDOS							
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			UART_tb_recibir(X"03", rx);					--COILS PEDIDOS 3								
			wait for clk_period*5;
			wait until rising_edge(clk);	
			
			UART_tb_recibir(X"69", rx);						--CRC					
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			UART_tb_recibir(X"CB", rx);							--CRC					
			wait for clk_period*5;
			wait until rising_edge(clk);	
			
			--FUNCION 5
			
			WAIT FOR 3 ms;
			
			UART_tb_recibir(X"01", rx);		--DIR 1									
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			UART_tb_recibir(X"05", rx);			--FUNCION 2											
			wait for clk_period*5;
			wait until rising_edge(clk);
						
			UART_tb_recibir(X"00", rx);				--MEM							
			wait for clk_period*5;
			wait until rising_edge(clk);	
			
			UART_tb_recibir(X"01", rx);				--MEM	 1	SALIDA 2								
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			UART_tb_recibir(X"FF", rx);				--ACTIVA SALIDA						
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			UART_tb_recibir(X"00", rx);					--ACTIVA SALIDA 							
			wait for clk_period*5;
			wait until rising_edge(clk);	
			
			UART_tb_recibir(X"DD", rx);						--CRC					
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			UART_tb_recibir(X"FA", rx);							--CRC					
			wait for clk_period*5;
			wait until rising_edge(clk);


			--FUNCION 1
			WAIT FOR 3 ms;
			
			UART_tb_recibir(X"01", rx);		--DIR 1									
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			UART_tb_recibir(X"01", rx);			--FUNCION 2											
			wait for clk_period*5;
			wait until rising_edge(clk);
						
			UART_tb_recibir(X"00", rx);				--MEM							
			wait for clk_period*5;
			wait until rising_edge(clk);	
			
			UART_tb_recibir(X"01", rx);				--MEM	 1									
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			UART_tb_recibir(X"00", rx);				--SALIDAS PEDIDAS					
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			UART_tb_recibir(X"03", rx);				--SALIDAS PEDIDAS							
			wait for clk_period*5;
			wait until rising_edge(clk);	
			
			UART_tb_recibir(X"2D", rx);						--CRC					
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			UART_tb_recibir(X"CB", rx);							--CRC					
			wait for clk_period*5;
			wait until rising_edge(clk);		
			
			
			--FUNCION 15
			WAIT FOR 3 ms;
			
			UART_tb_recibir(X"01", rx);		--DIR 1									
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			UART_tb_recibir(X"0F", rx);			--FUNCION 2											
			wait for clk_period*5;
			wait until rising_edge(clk);
						
			UART_tb_recibir(X"00", rx);				--MEM							
			wait for clk_period*5;
			wait until rising_edge(clk);	
			
			UART_tb_recibir(X"00", rx);				--MEM	 1									
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			UART_tb_recibir(X"00", rx);				--SALIDAS A MODIFICAR					
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			UART_tb_recibir(X"04", rx);				--SALIDAS A MODIFICAR										
			wait for clk_period*5;
			wait until rising_edge(clk);

			UART_tb_recibir(X"01", rx);				--BYTES A SEGUIR										
			wait for clk_period*5;
			wait until rising_edge(clk);

			UART_tb_recibir(X"0D", rx);				--valor aplicado a salidas										
			wait for clk_period*5;
			wait until rising_edge(clk);
				
			
			UART_tb_recibir(X"FF", rx);						--CRC					
			wait for clk_period*5;
			wait until rising_edge(clk);
			
			UART_tb_recibir(X"53", rx);							--CRC					
			wait for clk_period*5;
			wait until rising_edge(clk);		
			

      wait;
   end process;

END;
