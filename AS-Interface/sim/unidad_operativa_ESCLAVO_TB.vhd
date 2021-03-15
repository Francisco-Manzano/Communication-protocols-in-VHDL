--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:16:05 08/12/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/AS-Interface/unidad_operativa_ESCLAVO_TB.vhd
-- Project Name:  AS-Interface
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: unidad_operativa_ESCLAVO
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
 
ENTITY unidad_operativa_ESCLAVO_TB IS
END unidad_operativa_ESCLAVO_TB;
 
ARCHITECTURE behavior OF unidad_operativa_ESCLAVO_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT unidad_operativa_ESCLAVO
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         rx_valido : IN  std_logic;
         datos_completos : IN  std_logic_vector(10 downto 0);
         tx_activado : OUT  std_logic;
		 esclavo_encendido : in  STD_LOGIC;
         ENTRADA1 : IN  std_logic;
         ENTRADA2 : IN  std_logic;
         SALIDA1 : OUT  std_logic;
         SALIDA2 : OUT  std_logic;
         datos_a_enviar : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal rx_valido : std_logic := '0';
   signal datos_completos : std_logic_vector(10 downto 0) := (others => '0');
   signal ENTRADA1 : std_logic := '0';
   signal ENTRADA2 : std_logic := '0';
   signal esclavo_encendido : std_logic := '0';

 	--Outputs
   signal tx_activado : std_logic;
   signal SALIDA1 : std_logic;
   signal SALIDA2 : std_logic;
   signal datos_a_enviar : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: unidad_operativa_ESCLAVO PORT MAP (
          clk => clk,
          reset => reset,
          rx_valido => rx_valido,
          datos_completos => datos_completos,
          tx_activado => tx_activado,
          ENTRADA1 => ENTRADA1,
          ENTRADA2 => ENTRADA2,
		  esclavo_encendido => esclavo_encendido,
          SALIDA1 => SALIDA1,
          SALIDA2 => SALIDA2,
          datos_a_enviar => datos_a_enviar
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
	  
	  
			esclavo_encendido<='1';	
			reset <='1';              
			wait for clk_period*2;
			reset <='0';
			wait for clk_period*2;
			rx_valido <= '1';
			datos_completos <="10000110101";  --CASO DIRECCION INCORRECTA
			wait for clk_period*1;
			rx_valido <= '0';
			wait for clk_period*10;
			
			rx_valido <= '1';
			datos_completos <="10001111100";  --CASO COMANDOS  RESET_SLAVE
			wait for clk_period*1;
			rx_valido <= '0';
			wait for clk_period*10;
			
			rx_valido <= '1';
			datos_completos <="10001100000";  --CASO COMANDOS  DELETE ADRESS
			wait for clk_period*1;
			rx_valido <= '0';
			wait for clk_period*10;
			
			rx_valido <= '1';
			datos_completos <="00000000011";  --CASO ADDRESS ASSIGNMENT
			wait for clk_period*1;
			rx_valido <= '0';
			wait for clk_period*10;
			
			rx_valido <= '1';
			datos_completos <="10001110000";  --CASO COMANDOS  READ_IO
			wait for clk_period*1;
			rx_valido <= '0';
			wait for clk_period*10;
			
			rx_valido <= '1';
			datos_completos <="10001110001";  --CASO COMANDOS  READ_ID
			wait for clk_period*1;
			rx_valido <= '0';
			wait for clk_period*10;
			
			rx_valido <= '1';
			datos_completos <="10001111110";  --CASO COMANDOS  READ_STATUS
			wait for clk_period*1;
			rx_valido <= '0';
			wait for clk_period*10;
			
			rx_valido <= '1';
			datos_completos <="10001111111";  --CASO COMANDOS  READ_RESET_STATUS
			wait for clk_period*1;
			rx_valido <= '0';
			wait for clk_period*10;
			
			
			rx_valido <= '1';
			datos_completos <="00001110011";  --CASO PARAMETROS  
			wait for clk_period*1;
			rx_valido <= '0';
			wait for clk_period*10;
			
			rx_valido <= '1';
			datos_completos <="00001100011";  --CASO DATOS
			wait for clk_period*1;
			rx_valido <= '0';
			wait for clk_period*10;
			
			ENTRADA1 <= '1';
			
			rx_valido <= '1';
			datos_completos <="00001100011";  --CASO DATOS
			wait for clk_period*1;
			rx_valido <= '0';
			wait for clk_period*10;
			
			
			ENTRADA2 <= '1';
			
			rx_valido <= '1';
			datos_completos <="00001100011";  --CASO DATOS
			wait for clk_period*1;
			rx_valido <= '0';
			wait for clk_period*10;
			
			rx_valido <= '1';
			datos_completos <="00001100001";  --CASO DATOS
			wait for clk_period*1;
			rx_valido <= '0';
			wait for clk_period*10;
			
			rx_valido <= '1';
			datos_completos <="00001100000";  --CASO DATOS
			wait for clk_period*1;
			rx_valido <= '0';
			wait for clk_period*10;
			
			
			
			
			
			
			
			
			
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  

      wait;
   end process;

END;
