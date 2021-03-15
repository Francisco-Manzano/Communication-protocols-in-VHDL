--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:05:48 12/02/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/MODBUSS/MODBUS/OPERACIONES_ESCLAVO_TB.vhd
-- Project Name:  MODBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: operaciones_ESCLAVO
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
 
ENTITY OPERACIONES_ESCLAVO_TB IS
END OPERACIONES_ESCLAVO_TB;
 
ARCHITECTURE behavior OF OPERACIONES_ESCLAVO_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT operaciones_ESCLAVO
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         numerobytes_recibidos : IN INTEGER;
         datos_recibidos : IN  std_logic_vector(7 downto 0);
         flag_byte_recibido : IN  std_logic;
         flag_fin_recepcion : IN  std_logic;
		 SALIDA1 : out  STD_LOGIC:='0';
			SALIDA2 : out  STD_LOGIC:='0';
			SALIDA3 : out  STD_LOGIC:='0';
			SALIDA4 : out  STD_LOGIC:='0';
			ENTRADA1: IN std_logic;
			ENTRADA2: IN std_logic;
			ENTRADA3: IN std_logic;
			ENTRADA4: IN std_logic;
         tx_inicio : OUT  std_logic;
         datos_completos : OUT  std_logic_vector(120 downto 0);
         bytes_a_enviar : OUT  INTEGER
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal numerobytes_recibidos : INTEGER := 0;
   signal datos_recibidos : std_logic_vector(7 downto 0) := (others => '0');
   signal flag_byte_recibido : std_logic := '0';
   signal flag_fin_recepcion : std_logic := '0';
   signal ENTRADA1: std_logic:='0';
   signal ENTRADA2: std_logic:='0';
   signal ENTRADA3: std_logic:='0';
   signal ENTRADA4: std_logic:='0';
   

 	--Outputs
   signal tx_inicio : std_logic;
   signal datos_completos : std_logic_vector(120 downto 0);
   signal bytes_a_enviar : INTEGER;
   signal SALIDA1: STD_LOGIC;
   signal SALIDA2: STD_LOGIC;
   signal SALIDA3: STD_LOGIC;
   signal SALIDA4: STD_LOGIC;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: operaciones_ESCLAVO PORT MAP (
          clk => clk,
          reset => reset,
          numerobytes_recibidos => numerobytes_recibidos,
          datos_recibidos => datos_recibidos,
		  ENTRADA1 => ENTRADA1,
		  ENTRADA2 => ENTRADA2,
		  ENTRADA3 => ENTRADA3,
		  ENTRADA4 => ENTRADA4,
		  SALIDA1 => SALIDA1,
		  SALIDA2 => SALIDA2,
		  SALIDA3 => SALIDA3,
		  SALIDA4 => SALIDA4,
          flag_byte_recibido => flag_byte_recibido,
          flag_fin_recepcion => flag_fin_recepcion,
          tx_inicio => tx_inicio,
          datos_completos => datos_completos,
          bytes_a_enviar => bytes_a_enviar
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
		
	 ENTRADA1 <= '1';
	 ENTRADA2 <= '1';
	 ENTRADA3 <= '1';
	 ENTRADA4 <= '1';
	 	
      -- insert stimulus here 
	  reset <= '1';
	  wait for clk_period;
	  reset <='0';
	  
	  --EXCEPCION
	  
	   wait for clk_period*5;	--DIRECCION ESCLAVO  DIRECCION 1
	   datos_recibidos <=X"01";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--FUNCION   FUNCION 2
	   datos_recibidos <=X"02";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--DIRECCION MEMORIA 1
	   datos_recibidos <=X"00";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';						--MEMORIA 3
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--DIRECCION MEMORIA 2
	   datos_recibidos <=X"00";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--NUMEROS DE BOBINAS 1
	   datos_recibidos <=X"00";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';					
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--NUMEROS DE BOBINAS 2
	   datos_recibidos <=X"09";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	   
	  
	   wait for clk_period*5;	--CRC 1
	   datos_recibidos <=X"B8";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	   wait for clk_period*5;	--CRC 2
	   datos_recibidos <=X"0C";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	   numerobytes_recibidos <= 8;
	   
	   flag_fin_recepcion <= '1';
	   wait for clk_period;
	   flag_fin_recepcion <= '0';
	   
	   
	   wait for 60 us; 
	   -- reset <= '1';
	   -- wait for clk_period*5;
	   -- reset <= '0';
	   
	   
	   
	   
	   
	   
	   
	  
	   wait for clk_period*5;	--DIRECCION ESCLAVO  DIRECCION 1
	   datos_recibidos <=X"01";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--FUNCION   FUNCION 1
	   datos_recibidos <=X"01";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--DIRECCION MEMORIA 1
	   datos_recibidos <=X"00";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';						--MEMORIA 3
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--DIRECCION MEMORIA 2
	   datos_recibidos <=X"01";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--NUMEROS DE BOBINAS 1
	   datos_recibidos <=X"00";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';					--15
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--NUMEROS DE BOBINAS 2
	   datos_recibidos <=X"03";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	   
	  
	   wait for clk_period*5;	--CRC 1
	   datos_recibidos <=X"2D";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	   wait for clk_period*5;	--CRC 2
	   datos_recibidos <=X"CB";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	   numerobytes_recibidos <= 8;
	   
	   flag_fin_recepcion <= '1';
	   wait for clk_period;
	   flag_fin_recepcion <= '0';
	   
	   wait for 40 us; 
	   
	   
	   
	  
	   
	   --ORDEN 15
	   
	   numerobytes_recibidos<= 10;
	  
	   wait for clk_period*5;	--DIRECCION ESCLAVO  DIRECCION 1
	   datos_recibidos <=X"01";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--FUNCION   FUNCION 15
	   datos_recibidos <=X"0F";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--DIRECCION MEMORIA 1
	   datos_recibidos <=X"00";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';						--MEMORIA 3
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--DIRECCION MEMORIA 2
	   datos_recibidos <=X"02";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	   
	    wait for clk_period*5;	--BOBINAS A ESCRIBIR 1
	   datos_recibidos <=X"00";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;							--4 BOBINAS
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	    wait for clk_period*5;	--BOBINAS A ESCRIBIR 2
	   datos_recibidos <=X"04";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	   
	    wait for clk_period*5;	--BYTES DE DATOS
	   datos_recibidos <=X"01";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';		
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--VALOR DE BOBINAS 1
	   datos_recibidos <=X"0F";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';		
	   wait for clk_period;
	   flag_byte_recibido <= '0';					
	   wait for clk_period*5;
	   
	 
	   
	  
	   wait for clk_period*5;	--CRC 1
	   datos_recibidos <=X"07";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	   wait for clk_period*5;	--CRC 2
	   datos_recibidos <=X"52";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	   
	   flag_fin_recepcion <= '1';
	   wait for clk_period;
	   flag_fin_recepcion <= '0';
	   
	   
	   --orden 5
	   wait for 40 us; 
	    
	  
	  
	   wait for clk_period*5;	--DIRECCION ESCLAVO  DIRECCION 1
	   datos_recibidos <=X"01";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--FUNCION   FUNCION 5
	   datos_recibidos <=X"05";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--DIRECCION MEMORIA 1
	   datos_recibidos <=X"00";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';						--MEMORIA 3
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--DIRECCION MEMORIA 2
	   datos_recibidos <=X"00";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--ACTIVA/DESACTIVA BOBINA 1
	   datos_recibidos <=X"FF";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';					--15
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--ACTIVA/DESACTIVA BOBINA 2
	   datos_recibidos <=X"00";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	   
	  
	   wait for clk_period*5;	--CRC 1
	   datos_recibidos <=X"8C";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	   wait for clk_period*5;	--CRC 2
	   datos_recibidos <=X"3A";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	   numerobytes_recibidos <= 8;
	   
	   flag_fin_recepcion <= '1';
	   wait for clk_period;
	   flag_fin_recepcion <= '0';
	   
	   wait for 40 us; 

	   
	   
	    --orden 5 apagar
	  
	    
	
	  
	   wait for clk_period*5;	--DIRECCION ESCLAVO  DIRECCION 1
	   datos_recibidos <=X"01";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--FUNCION   FUNCION 5
	   datos_recibidos <=X"05";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--DIRECCION MEMORIA 1
	   datos_recibidos <=X"00";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';						--MEMORIA 3
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--DIRECCION MEMORIA 2
	   datos_recibidos <=X"00";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--ACTIVA/DESACTIVA BOBINA 1
	   datos_recibidos <=X"00";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';					--15
	   wait for clk_period*5;
	   
	  
	   wait for clk_period*5;	--ACTIVA/DESACTIVA BOBINA 2
	   datos_recibidos <=X"00";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	   
	  
	   wait for clk_period*5;	--CRC 1
	   datos_recibidos <=X"CD";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	   wait for clk_period*5;	--CRC 2
	   datos_recibidos <=X"CA";
	   wait for clk_period*5;	
	   flag_byte_recibido <= '1';
	   wait for clk_period;
	   flag_byte_recibido <= '0';
	   wait for clk_period*5;
	   
	   numerobytes_recibidos <= 8;
	   
	   flag_fin_recepcion <= '1';
	   wait for clk_period;
	   flag_fin_recepcion <= '0';
	   
	   wait for 40 us; 


      wait;
   end process;

END;
