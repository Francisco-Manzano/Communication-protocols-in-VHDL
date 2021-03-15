--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:11:25 05/10/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/MODBUS/unidad_operativa_tb.vhd
-- Project Name:  MODBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: unidad_operativa
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
--use IEEE.STD_LOGIC_ARITH.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
 
ENTITY unidad_operativa_tb IS
END unidad_operativa_tb;
 
ARCHITECTURE behavior OF unidad_operativa_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT unidad_operativa
    Port ( clk : in  STD_LOGIC;
			  clk1hz: in STD_LOGIC;
           reset : in  STD_LOGIC;
           comando_actual : in  STD_LOGIC_VECTOR (8 downto 0);
		   SIGUIENTE_REGISTRO: in STD_LOGIC;
           MAS : in  STD_LOGIC;
           MENOS : in  STD_LOGIC;
		   inicio_transmision : in STD_LOGIC;
		   CRC_DONE : out STD_LOGIC;  
		   bytes_totales : out integer:=0; --BYTES a transmitir por la uart tx
		   CRC_OUT : out unsigned(15 downto 0); -- valor del CRC para el BCD
		   valor_vector : out std_logic_vector(120 downto 0); --trama a enviar para la uart tx
		   registro_actual: OUT integer;
           valor_dec : out integer); --valores de los comandos para el BCD
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal clk1hz : std_logic := '0';
   signal reset : std_logic := '0';
   signal comando_actual : std_logic_vector(8 downto 0) := (others => '0');
   signal MAS : std_logic := '0';
   signal MENOS : std_logic := '0';
	signal inicio_transmision: std_logic:='0';
	signal SIGUIENTE_REGISTRO: std_logic:='0';
	
 	--Outputs
	signal CRC_DONE: std_logic:='0';
   signal valor_dec : integer:=0;
   signal bytes_totales: integer:=0;
   signal CRC_OUT: unsigned(15 downto 0):=(others=>'0');
   signal valor_vector: std_logic_vector(120 downto 0):=(others=>'0');
   signal registro_actual: integer:=0;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
   constant clk1hz_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: unidad_operativa PORT MAP (
          clk => clk,
          clk1hz => clk1hz,
          reset => reset,
          comando_actual => comando_actual,
          MAS => MAS,
          MENOS => MENOS,
		  inicio_transmision=> inicio_transmision,
		  SIGUIENTE_REGISTRO=> SIGUIENTE_REGISTRO,
		  CRC_DONE=> CRC_DONE,
		  bytes_totales=> bytes_totales,
		  CRC_OUT => CRC_OUT,
		  valor_vector=>valor_vector,
		  registro_actual=> registro_actual,
          valor_dec => valor_dec
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   clk1hz_process :process
   begin
		clk1hz <= '0';
		wait for clk1hz_period/2;
		clk1hz <= '1';
		wait for clk1hz_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

		reset <= '1';
		wait for clk_period*4;
		reset <='0';
		wait for clk_period*3;
		comando_actual <= "000000001";  --AD SLAVE
		MAS <= '1';
		wait for clk_period*4;
		MAS <= '0';
		wait for clk_period*3;
		comando_actual <= "000000010"; --FUNCION
		wait for clk_period*3;
		MAS <= '1';
		wait for clk_period*10;
		MAS <= '0';
		wait for clk_period*3;
		MENOS <= '1';
		wait for clk_period*7;
		MENOS <= '0';
		wait for clk_period*3;
		MAS <= '1';
		wait for clk_period*2;
		MAS <= '0';
		comando_actual <= "000000100"; --AD_DATO
		wait for clk_period*3;
		MENOS <= '1';
		wait for clk_period*3;
		MENOS <= '0';
		wait for clk_period*3;
		MAS <= '1';
		wait for clk_period*10;
		MAS <= '0';
		wait for clk_period*3;
		comando_actual <= "000001000";
		wait for clk_period*3;
		MAS <= '1';
		wait for clk_period*12;
		MAS <= '0';
		wait for clk_period*3;
		MENOS <= '1';
		wait for clk_period*7;
		MENOS <= '0';
		wait for clk_period*3;
		comando_actual <= "000010000";
		wait for clk_period*3;
		MAS <= '1';
		wait for clk_period*4;
		MAS <= '0';
		wait for clk_period*3;
		MENOS <= '1';
		wait for clk_period*2;
		MENOS <= '0';
		wait for clk_period*3;
		comando_actual <= "000100000";
		wait for clk_period*3;
		MAS <= '1';
		wait for clk_period*20;
		MAS <= '0';
		wait for clk_period*3;
		MENOS <= '1';
		wait for clk_period*7;
		MENOS <= '0';
		wait for clk_period*3;
		comando_actual <= "000000001";
		wait for clk_period*3;
		MAS <= '1';
		wait for clk_period*12;
		MAS <= '0';
		wait for clk_period*3;
		MENOS <= '1';
		wait for clk_period*7;
		MENOS <= '0';
		
		
		
		
		







      wait;
   end process;

END;
