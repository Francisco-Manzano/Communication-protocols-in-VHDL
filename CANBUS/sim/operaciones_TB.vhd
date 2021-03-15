--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:30:28 08/25/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/CANBUS/CANBUS/operaciones_TB.vhd
-- Project Name:  CANBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: operaciones
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
 
ENTITY operaciones_TB IS
END operaciones_TB;
 
ARCHITECTURE behavior OF operaciones_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT operaciones
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
		 entradas : in STD_LOGIC_VECTOR(7 downto 0);
         bit_sin_relleno : IN  std_logic;
		 flag_tiempo_bit : in STD_LOGIC;
         flag_bits_sin_relleno : IN  std_logic;
         bus_idle : OUT  std_logic;
         inicio_recepcion : IN  std_logic;  
		 indicador_error : out STD_LOGIC;
		 flag_bit_error : in STD_LOGIC;
		 flag_stuff_error: in STD_LOGIC;	
         bits_totales : OUT  integer;
		 inicio_anticipado_out : out STD_LOGIC:='0';
         fin_bits : OUT  std_logic
		 );
         
    END COMPONENT;
    

   --Inputs
   signal flag_bit_error: std_logic:='0';
   signal flag_tiempo_bit: std_logic:= '0';
   signal entradas: std_logic_vector(7 downto 0):="00000001";
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal flag_stuff_error: std_logic:='0';
   signal bit_sin_relleno : std_logic := '0';
   signal flag_bits_sin_relleno : std_logic := '0';
   signal inicio_recepcion : std_logic := '0';

 	--Outputs
   signal bus_idle : std_logic; 
   signal inicio_anticipado_out: std_logic;
   signal bits_totales : integer;
   signal indicador_error: std_logic;
   signal fin_bits : std_logic;
   

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: operaciones PORT MAP (
          clk => clk,
          reset => reset,
		  entradas => entradas,
          bit_sin_relleno => bit_sin_relleno,
		  flag_tiempo_bit => flag_tiempo_bit,
		  inicio_anticipado_out => inicio_anticipado_out,
          flag_bits_sin_relleno => flag_bits_sin_relleno,
		  flag_bit_error => flag_bit_error,
		  flag_stuff_error => flag_stuff_error,
          bus_idle => bus_idle,
		  indicador_error => indicador_error,
          inicio_recepcion => inicio_recepcion,
          bits_totales => bits_totales,
          fin_bits => fin_bits      
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
			reset <= '1';
			wait for clk_period*3;
			reset <= '0';
			
			entradas <= "00000011";
			wait for clk_period;
	
			
			
		-- --------------------------------------------------------------------------------
			
			inicio_recepcion <= '1';
			wait for clk_period;
			inicio_recepcion <= '0';

										--1    --SOF
			bit_sin_relleno <= '0';
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';     --2     --ID 1
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			
			bit_sin_relleno <= '0';    --3       --ID   2   
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --4     --ID 3
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --5     --ID  4
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 1180 ns;
			
			-- bit_sin_relleno <= '1';    --     RELLENO
			 -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- wait for clk_period*1;
			-- flag_bits_sin_relleno <= '0';
			-- wait for 180 ns;
			
			bit_sin_relleno <= '0';    --6    --ID 5
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --7     --ID 6
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --8     --ID 7
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --9     --ID 8
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --10     --ID 9
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 1180 ns;
			
			-- bit_sin_relleno <= '1';    --     RELLENO
			 -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- wait for clk_period*1;
			-- flag_bits_sin_relleno <= '0';
			-- wait for 180 ns;
			
			bit_sin_relleno <= '0';    --11     --ID 10
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --12     --ID 11
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			
			bit_sin_relleno <= '1';    --14      --RTR
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0'; 
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --      IDE
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --        RESERVADO
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --17			DLC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --18			DLC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 1180 ns;
			
			
			bit_sin_relleno <= '0';    --19			DLC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			-- bit_sin_relleno <= '0';    --19			DLC
			 -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- wait for clk_period*1;
			-- flag_bits_sin_relleno <= '0';
			-- wait for 180 ns;
			
			
			bit_sin_relleno <= '1';    --19			DLC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			-- bit_sin_relleno <= '0';    --20			DATOS
			 -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- wait for clk_period*1;
			-- flag_bits_sin_relleno <= '0';
			-- wait for 180 ns;
			
			-- bit_sin_relleno <= '0';    --21			DATOS
			 -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- wait for clk_period*1;
			-- flag_bits_sin_relleno <= '0';
			-- wait for 180 ns;
			
			-- bit_sin_relleno <= '0';    --22			DATOS
			 -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- wait for clk_period*1;
			-- flag_bits_sin_relleno <= '0';
			-- wait for 180 ns;
			
			-- bit_sin_relleno <= '0';    --23			DATOS
			 -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- wait for clk_period*1;
			-- flag_bits_sin_relleno <= '0';
			-- wait for 180 ns;
			
			-- bit_sin_relleno <= '0';    --24			DATOS
			 -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- wait for clk_period*1;
			-- flag_bits_sin_relleno <= '0';
			-- wait for 1180 ns;
			
			-- -- bit_sin_relleno <= '0';    --25			DATOS
			 -- -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- -- wait for clk_period*1;
			-- -- flag_bits_sin_relleno <= '0';
			-- -- wait for 180 ns;
			
			-- bit_sin_relleno <= '0';    --26			DATOS
			 -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- wait for clk_period*1;
			-- flag_bits_sin_relleno <= '0';
			-- wait for 180 ns;
			
			-- bit_sin_relleno <= '1';    --27			DATOS
			 -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- wait for clk_period*1;
			-- flag_bits_sin_relleno <= '0';
			-- wait for 180 ns;
			
			-- bit_sin_relleno <= '1';    --27			DATOS
			 -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- wait for clk_period*1;
			-- flag_bits_sin_relleno <= '0';
			-- wait for 180 ns;
			
			
			
			bit_sin_relleno <= '0';    --28         CRC 14
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --29         CRC 13
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --30         CRC 12
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --31         CRC 11
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --32         CRC 10
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 1180 ns;
			
			bit_sin_relleno <= '0';    --33         CRC 9
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --34         CRC 8
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --35         CRC 7
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --36         CRC 6
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --37         CRC 5
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --38         CRC 4
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 1180 ns;
			
			bit_sin_relleno <= '1';    --39         CRC 3
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --34         CRC 8
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --35         CRC 7
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --36         CRC 6
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			-- bit_sin_relleno <= '0';    --37         CRC 5
			 -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- wait for clk_period*1;
			-- flag_bits_sin_relleno <= '0';
			-- wait for 180 ns;
			
			-- bit_sin_relleno <= '0';    --38         CRC 4
			 -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- wait for clk_period*1;
			-- flag_bits_sin_relleno <= '0';
			-- wait for 1180 ns;
			
			-- -- bit_sin_relleno <= '1';    --39         CRC 3
			 -- -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- -- wait for clk_period*1;
			-- -- flag_bits_sin_relleno <= '0';
			-- -- wait for 180 ns;
			
			bit_sin_relleno <= '1';    --43       CRCDEL
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --44        ACK SLOT
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --45         ACK DEL
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --46        EOF
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --47        EOF
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --48        EOF
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --49        EOF
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --50        EOF
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --51       EOF
			 wait for 800 ns; flag_bits_sin_relleno <= '1'; 
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --52        EOF
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --52        IM
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --52        IM
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --52        IM
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			wait for 850 ns;
			inicio_recepcion <= '1';
			wait for clk_period;
			inicio_recepcion <= '0';
			
			
			--COMPROBAMOS QUE LA RESPUESTA A LA TRAMA REMOTA RECIBIDA ES CORRECTA
			
			bit_sin_relleno <= '0';    --       SOF
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 1180 ns;
			
			-- bit_sin_relleno <= '1';    --   relleno    
			 -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- wait for clk_period*1;
			-- flag_bits_sin_relleno <= '0';
			-- wait for 180 ns;
			
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 1180 ns;
			
			-- bit_sin_relleno <= '1';    --   relleno    
			 -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- wait for clk_period*1;
			-- flag_bits_sin_relleno <= '0';
			-- wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 1180 ns;
			
			-- bit_sin_relleno <= '1';    --   relleno    
			 -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- wait for clk_period*1;
			-- flag_bits_sin_relleno <= '0';
			-- wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 1180 ns;
			
			-- bit_sin_relleno <= '1';    --   relleno    
			 -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- wait for clk_period*1;
			-- flag_bits_sin_relleno <= '0';
			-- wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 1180 ns;
			
			-- bit_sin_relleno <= '1';    --   relleno    
			 -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- wait for clk_period*1;
			-- flag_bits_sin_relleno <= '0';
			-- wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --       
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --      ACK SLOT
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --        ACK DEL
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --       EOF 
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --      EOF  
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --       EOF 
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --      EOF  
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --      EOF  
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --      EOF  
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --   EOF    
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --    IM   
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --    IM   
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --       IM
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			-- --AÑADIR MAS POSIBILIDADES PARA COMPROBARLO TODO
			
			
			
			wait for 5 us;
		--COMPROBANDO FORM ERROR EN SOF
		
			inicio_recepcion <= '1';
			wait for clk_period;
			inicio_recepcion <= '0';

										
			bit_sin_relleno <= '1';
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';   
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';   
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';   
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';  
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';   
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';   
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';   ----ERROR ACTIVO DE OTRO NODO (SUPERPOSICION DE FLAGS)
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --ERROR ACTIVO DE OTRO NODO (SUPERPOSICION DE FLAGS)
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --ERROR ACTIVO DE OTRO NODO (SUPERPOSICION DE FLAGS)
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --ERROR ACTIVO DELIMITER 1
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --ERROR ACTIVO DELIMITER 2
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --ERROR ACTIVO DELIMITER 3
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --ERROR ACTIVO DELIMITER 4
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --ERROR ACTIVO DELIMITER 5
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --ERROR ACTIVO DELIMITER 6
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --ERROR ACTIVO DELIMITER 7
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --ERROR ACTIVO DELIMITER 8
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --        INTERMISSION 1
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --        INTERMISSION 2
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --        INTERMISSION 3
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			wait for 5 us;
			
			
		
			-- -- COMPROBANDO OVERLOAD
			
			inicio_recepcion <= '1';
			wait for clk_period;
			inicio_recepcion <= '0';

			wait for clk_period*3;      --1    --SOF
			bit_sin_relleno <= '0';
		    wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';     --2     --ID
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			
			bit_sin_relleno <= '0';    --3       --ID     
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --4     --ID
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --5     --ID
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --6     --ID
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --7     --ID
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --8     --ID
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --9     --ID
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --10     --ID
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --11     --ID
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --12     --ID
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --13     --RTR
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --14      --IDE
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0'; 
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --15      RESERVED
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --16        DLC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --17			DLC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --18			DLC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --19			DLC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --20			DATOS
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --21			DATOS
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --22			DATOS
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --23			DATOS
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --24			DATOS
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --25			DATOS
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --26			DATOS
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --27			DATOS
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --28         CRC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --29         CRC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --30         CRC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --31         CRC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --32         CRC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --33         CRC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --34         CRC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --35         CRC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --36         CRC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --37         CRC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --38         CRC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --39         CRC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --40         CRC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --41         CRC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --42         CRC
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --43       CRCDEL
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --44        ACK SLOT
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --45         ACK DEL
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --46        EOF
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --47        EOF
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --48        EOF
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --49        EOF
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --50        EOF
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --51        EOF
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --52        EOF
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --52        INTERMISSION 1
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --52        INTERMISSION 2
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			-- bit_sin_relleno <= '0';    --        INTERMISSION 3 AQUI PROVOCAMOS EL OVERLOAD
			 -- wait for 800 ns; flag_bits_sin_relleno <= '1';
			-- wait for clk_period*1;
			-- flag_bits_sin_relleno <= '0';
			-- wait for 180 ns;
			
			bit_sin_relleno <= '0';    --       OVERLOAD_FLAG 1
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --        OVERLOAD_FLAG 2
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --        OVERLOAD_FLAG 3
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --        OVERLOAD_FLAG 4
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --        OVERLOAD_FLAG 5
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --        OVERLOAD_FLAG 6
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --        OVERLOAD_FLAG DE OTRO NODO
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --        OVERLOAD_FLAG DE OTRO NODO
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '0';    --        OVERLOAD_FLAG DE OTRO NODO
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --        OVERLOAD DELIMITER 1
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --        OVERLOAD DELIMITER 2
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --        OVERLOAD DELIMITER 3
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --        OVERLOAD DELIMITER 4
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --        OVERLOAD DELIMITER 5
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --        OVERLOAD DELIMITER 6
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --        OVERLOAD DELIMITER 7
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --        OVERLOAD DELIMITER 8
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --        INTERMISSION 1
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --        INTERMISSION 2
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			bit_sin_relleno <= '1';    --        INTERMISSION 3
			 wait for 800 ns; flag_bits_sin_relleno <= '1';
			wait for clk_period*1;
			flag_bits_sin_relleno <= '0';
			wait for 180 ns;
			
			
			
			
			


      wait;
   end process;

END;
