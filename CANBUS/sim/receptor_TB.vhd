--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:42:07 08/24/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/CANBUS/CANBUS/receptor_TB.vhd
-- Project Name:  CANBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: receptor
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
 
ENTITY receptor_TB IS
END receptor_TB;
 
ARCHITECTURE behavior OF receptor_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT receptor
    PORT(
         clk10Mhz : IN  std_logic;
		 clk : IN std_logic;
         reset : IN  std_logic;
         rx : IN  std_logic;
		 flag_tiempo_bit : out STD_LOGIC:= '0';
		 bus_idle: in STD_LOGIC;
		 inicio_recepcion: out STD_LOGIC:='0';
		 flag_test_2 : out STD_LOGIC :='0';
		 flag_test : out STD_LOGIC :='0';
         flag_bit_recibido : OUT  std_logic;
         bit_recibido : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal clk10Mhz : std_logic := '0';
   signal reset : std_logic := '0';
   signal rx : std_logic := '1';
   signal bus_idle: STD_LOGIC:='0';

 	--Outputs
   signal flag_bit_recibido : std_logic:='0';
   signal flag_tiempo_bit: std_logic:='0';
   signal flag_test : STD_LOGIC :='0';
   signal  flag_test_2 : STD_LOGIC :='0';
   signal bit_recibido : std_logic;
   SIGNAL inicio_recepcion: STD_LOGIC:='0';
   

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: receptor PORT MAP (
          clk10Mhz => clk10Mhz,
		  clk => clk,
          reset => reset,
          rx => rx,
		  bus_idle => bus_idle,
		  flag_tiempo_bit => flag_tiempo_bit,
		  inicio_recepcion => inicio_recepcion,
		  flag_test_2 => flag_test_2,
		  flag_test => flag_test,
          flag_bit_recibido => flag_bit_recibido,
          bit_recibido => bit_recibido
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
      wait for 400 ns;	
	  
	  

      wait for clk_period*10;
	  
		rx <= '1';

      -- insert stimulus here 
	  
	  
		reset <= '1';
		wait for clk_period*3;
		reset <= '0';
		wait for clk_period*10;
		wait for 20 ns;
		 rx <= '0';
		 wait for 90 us;
		 reset <= '1';
		 rx <= '1';
		 wait for clk_period*3; --TB PARA COMPROBAR SI PHASE_SEG_1 SE ALARGA AL DETECTAR BIT EDGE
		 reset <='0';
		 wait for clk_period*3;
		 rx <= '0';
		 wait for 10 us;
		 rx <= '1';
		 wait for 190 ns;
		 wait for 100 ns;
		 wait for 35 ns;
		 rx <= '0';
		 
		 
		 wait for 40 us;
		 reset <='1';
		 rx <= '1';
		                       --TB PARA COMPROBAR SI PHASE_SEG_2 SE ACORTA AL DETECTAR BIT EDGE
		 wait for clk_period*1;
		 reset <='0';
		 wait for clk_period*5;
		 rx <= '0';
		 
		 wait until flag_test<= '1';
		 rx <= '1';
		 wait until flag_bit_recibido <= '1';
		 rx <= '0';
		 wait for 100 ns;
		 bus_idle <= '1';

		 
		 
		 
		 
		 
		 
		
	  
	  


      wait;
   end process;

END;
