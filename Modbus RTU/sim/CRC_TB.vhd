--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:13:50 05/15/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/MODBUS/CRC_TB.vhd
-- Project Name:  MODBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CRC
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
 
ENTITY CRC_TB IS
END CRC_TB;
 
ARCHITECTURE behavior OF CRC_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CRC
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         inicio_transmision : IN  std_logic;
         dato : IN  integer;
		 registro_actual : in integer;
         numero_datos : IN  integer;
         flag_crcdone : OUT  std_logic;
		 bytes_totales : out integer:=0;
         CRC_out : out unsigned(15 downto 0);  --para ver el CRC en el BCD
          trama_out : out  STD_LOGIC_VECTOR (120 downto 0):= (others =>'0'); --salida de datos hacia la uart
         comando_actual : IN  std_logic_vector(6 downto 0);
         funcion : IN  integer
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal inicio_transmision : std_logic := '0';
   signal dato : integer := 0;
   signal registro_actual : integer:= 0;
   signal numero_datos : integer := 0;
   signal comando_actual : std_logic_vector(6 downto 0) := (others => '0');
   signal funcion : integer := 0;

 	--Outputs
	signal bytes_totales: integer:=0;
   signal flag_crcdone : std_logic:='0';
   signal CRC_out : unsigned (15 downto 0):=(others=>'0');
   signal trama_out : std_logic_vector(120 downto 0):=(others=>'0');

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CRC PORT MAP (
          clk => clk,
          reset => reset,
          inicio_transmision => inicio_transmision,
          dato => dato,
		  registro_actual => registro_actual,
          numero_datos => numero_datos,
          flag_crcdone => flag_crcdone,
		  bytes_totales => bytes_totales,
          CRC_out => CRC_out,
		  trama_out => trama_out,
          comando_actual => comando_actual,
          funcion => funcion
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
			wait for clk_period*2;
			reset<='0';
			wait for clk_period*10;
			funcion <= 1;
			wait for clk_period*10;
			numero_datos <= 2;
			wait for clk_period*10;
			comando_actual <= "0000001";
			wait for clk_period*10;
			dato <= 2;
			wait for clk_period*10;
			comando_actual <= "0000010";
			wait for clk_period*10;
			dato <= 1;
			wait for clk_period*10;
			comando_actual <= "0000100";
			wait for clk_period*10;
			dato <= 5;
			wait for clk_period*10;
			comando_actual <= "0001000";
			wait for clk_period*10;
			dato <= 5;
			wait for clk_period*10;
		
			inicio_transmision<='1';
			wait until flag_crcdone='1';
			wait for clk_period*10;
			inicio_transmision<='0';   ---------------------------
			wait for clk_period*10;
			funcion <= 1;
			wait for clk_period*10;
			numero_datos <= 4;
			wait for clk_period*10;
			comando_actual <= "0000001";
			wait for clk_period*10;
			dato <= 5;
			wait for clk_period*10;
			comando_actual <= "0000010";
			wait for clk_period*10;
			dato <= 2;
			wait for clk_period*10;
			comando_actual <= "0000100";
			wait for clk_period*10;
			dato <= 16;
			wait for clk_period*10;
			comando_actual <= "0001000";
			wait for clk_period*10;
			dato <= 10;
			wait for clk_period*10;
			
			inicio_transmision<='1';
			wait until flag_crcdone='1';
			wait for clk_period*10;
			inicio_transmision<='0';   ---------------------------
			wait for clk_period*10;
			funcion <= 15;
			wait for clk_period*10;
			numero_datos <= 2;
			wait for clk_period*10;
			comando_actual <= "0000001";
			wait for clk_period*10;
			dato <= 1;
			wait for clk_period*10;
			comando_actual <= "0000010";
			wait for clk_period*10;
			dato <= 15;                    --FUNCION 15
			wait for clk_period*10;
			comando_actual <= "0000100";
			wait for clk_period*10;
			dato <= 3;
			wait for clk_period*10;
			comando_actual <= "0001000";
			wait for clk_period*10;
			dato <= 9;
			wait for clk_period*10;
			comando_actual <= "0010000";
			wait for clk_period*10;
			dato <= 2;
			wait for clk_period*10;
			comando_actual <= "0100000";
			wait for clk_period*10;
			registro_actual<=1;
			wait for clk_period*10;
			dato <= 15;
			wait for clk_period*10;
			registro_actual<=2;
			wait for clk_period*10;
			dato <= 65535;
			wait for clk_period*10;
			inicio_transmision<='1';
			wait until flag_crcdone='1';
			wait for clk_period*10;
			inicio_transmision<='0';   ---------------------------
			wait for clk_period*10;
			funcion <= 16;
			wait for clk_period*10;
			numero_datos <= 4;
			wait for clk_period*10;
			comando_actual <= "0000001";
			wait for clk_period*10;
			dato <= 1;                  --ad slave
			wait for clk_period*10;
			comando_actual <= "0000010";
			wait for clk_period*10;
			dato <= 16;                  --FUNCION 16
			wait for clk_period*10;
			comando_actual <= "0000100";
			wait for clk_period*10;
			dato <= 3;                   --ad mem
			wait for clk_period*10;
			comando_actual <= "0001000";
			wait for clk_period*10;
			dato <= 2;                   --registros a rellenar
			wait for clk_period*10;
			comando_actual <= "0010000";
			wait for clk_period*10;
			dato <= 4;                   --numero de bytes
			wait for clk_period*10;
			comando_actual <= "0100000";
			wait for clk_period*10;
			registro_actual<=1;
			wait for clk_period*10;
			dato <= 65535;               --registro 1
			wait for clk_period*10;
			registro_actual<=2;
			wait for clk_period*10;
			dato <= 65280;                --registro 2
			wait for clk_period*10;
			inicio_transmision<='1';
			wait until flag_crcdone='1';
			inicio_transmision<='0';
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			

      wait;
   end process;

END;
