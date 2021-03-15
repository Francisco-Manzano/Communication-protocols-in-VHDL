--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:38:27 09/10/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/CANBUS/CANBUS/NODO_1_TOP_TB.vhd
-- Project Name:  CANBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: NODO_1_TOP
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
 
ENTITY NODO_1_TOP_TB IS
END NODO_1_TOP_TB;
 
ARCHITECTURE behavior OF NODO_1_TOP_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT NODO_1_TOP
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         rx : IN  std_logic;
         tx : OUT  std_logic;
         ENTRADA1 : IN  std_logic;
         ENTRADA2 : IN  std_logic;
         SALIDA1 : OUT  std_logic;
         SALIDA2 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal rx : std_logic := '0';
   signal ENTRADA1 : std_logic := '0';
   signal ENTRADA2 : std_logic := '0';

 	--Outputs
   signal tx : std_logic;
   signal SALIDA1 : std_logic;
   signal SALIDA2 : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: NODO_1_TOP PORT MAP (
          clk => clk,
          reset => reset,
          rx => rx,
          tx => tx,
          ENTRADA1 => ENTRADA1,
          ENTRADA2 => ENTRADA2,
          SALIDA1 => SALIDA1,
          SALIDA2 => SALIDA2
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
		rx <= '1';
		wait for clk_period;
		reset <='0';
		
		ENTRADA1 <= '1';
		ENTRADA2 <= '1';
		
		wait for 5 us;
		
		rx <='0';  
		wait for 1 us;
		rx <='0';   --ID1
		wait for 1 us;
		rx <='0';   --ID2
		wait for 1 us;
		rx <='0';   --ID3
		wait for 1 us;
		rx <='0';   --ID4
		wait for 1 us;
		rx <='1';   --RELLENO
		wait for 1 us;
		rx <='0';   --ID5
		wait for 1 us;
		rx <='0';   --ID6
		wait for 1 us;
		rx <='0';   --ID7
		wait for 1 us;
		rx <='0';   --ID8
		wait for 1 us;
		rx <='0';   --ID9
		wait for 1 us;
		rx <='1';   --RELLENO
		wait for 1 us;
		rx <='0';   --ID10
		wait for 1 us;
		rx <='1';   --ID11
		wait for 1 us;
		rx <='1';   --RTR REMOTA
		wait for 1 us;
		rx <='0';   --IDE
		wait for 1 us;
		rx <='0';   --RESERVADO
		wait for 1 us;
		rx <='0';   --DLC1
		wait for 1 us;
		rx <='0';   --DLC2
		wait for 1 us;
		rx <='0';   --DLC3
		wait for 1 us;
		rx <='1';   --RELLENO
		wait for 1 us;
		rx <='1';   --DLC4
		wait for 1 us;
		rx <='0';   --CRC1
		wait for 1 us;
		rx <='0';   --CRC1
		wait for 1 us;
		rx <='1';   --CRC1
		wait for 1 us;
		rx <='0';   --CRC1
		wait for 1 us;
		rx <='1';   --CRC1
		wait for 1 us;
		rx <='0';   --CRC1
		wait for 1 us;
		rx <='0';   --CRC1
		-- wait for 1 us;
		-- rx <='0';   --relleno
		wait for 1 us;
		rx <='0';   --CRC1
		wait for 1 us;
		rx <='1';   --CRC1
		wait for 1 us;
		rx <='0';   --CRC1
		wait for 1 us;
		rx <='0';   --CRC1
		wait for 1 us;
		rx <='1';   --CRC1
		-- wait for 1 us;
		-- rx <='1';   --relleno
		wait for 1 us;
		rx <='1';   --CRC1
		wait for 1 us;
		rx <='1';   --CRC1
		wait for 1 us;
		rx <='1';   --CRC1
		wait for 1 us;
		rx <='1';   --CRC DEL
		wait for 1 us;
		rx <='0';   --ACK SLOT
		wait for 1 us;
		rx <='1';   --ACK FIN
		wait for 1 us;
		rx <='1';   --EOF
		wait for 1 us;
		rx <='1';   --EOF
		wait for 1 us;
		rx <='1';   --EOF
		wait for 1 us;
		rx <='1';   --EOF
		wait for 1 us;
		rx <='1';   --EOF
		wait for 1 us;
		rx <='1';   --EOF
		wait for 1 us;
		rx <='1';   --EOF
		wait for 1 us;
		rx <='1';   --IM
		wait for 1 us;
		rx <='1';   --IM
		wait for 1 us;
		rx <='1';  			 -- RX='0' PARA ESTO >> COMPROBAMOS EL INICIO ANTICIPADO ( TERCER BIT DE IM ES '0') Y COMPROBAMOS 
		wait for 1015 ns;--    QUE SI TENEMOS UN MENSAJE EN ESPERA COMPETIMOS POR LA PRIORIDAD CON EL NODO QUE HA COMENZADO EL MENSAJE
		
		--AQUI COMPROBAMOS LA RESPUESTA A LA TRAMA REMOTA SOLICITADA
		
		rx <='0';  
		wait for 5 us;
		rx <='1';  --relleno
		wait for 1 us;	
		rx <='0';  
		wait for 5 us;
		rx <='1';   --relleno
		wait for 1 us;
		rx <='0';  
		wait for  us;
		rx <='1';  
		wait for 1 us;
		rx <='0';  
		wait for 5 us;
		rx <='1';   --relleno
		wait for 1 us;	
		rx <='0';  
		wait for 1 us;
		rx <='1';  
		wait for 1 us;
		rx <='0';  
		wait for 5 us;
		rx <='1';   --relleno
		wait for 1 us;
		rx <='0';  
		wait for 1 us;
		rx <='1';  
		wait for 5 us;
		rx <='0';   --relleno
		wait for 2 us;
		rx <='1';  
		wait for 3 us;
		rx <='0';  
		wait for 3 us;
		rx <='1';  
		wait for 4 us;
		rx <='0';  
		wait for 1 us;
		rx <='1';  
		wait for 1 us;
		rx <='0';  
		wait for 1 us;
		rx <='1';  --AQUI PODEMOS COMPROBAR SUSPEND TRANSMISSION ==> TENEMOS QUE PONER A '1' LA BANDERA DE ERROR PASIVO PORQUE NO HEMOS CREADO EL MODULO TODAVIA
		wait for 1 us;
		
		--SI ESTA EN SUSPEND TRANMISSION Y RECIBE TRANSMISION DE ENTRADA => PASAMOS A IDLE
		
		
		------------------------------------------------------------DATA FRAME RECIBIDO CON DATOS DE LAS SALIDAS DEL NODO ID 2
		
		WAIT FOR 15 us;
		rx <= '0';
		wait for 5 us;
		rx <='1';
		wait for 1 us;
		rx <= '0';
		wait for 5 us;
		rx <= '1';
		wait for 2 us;
		rx <= '0';
		wait for 5 us;
		rx <= '1';
		wait for 1 us;
		rx <= '0';
		wait for 2 us;
		rx <= '1';
		wait for 1 us;
		rx <= '0';
		wait for 5 us;
		rx <= '1';
		wait for 1 us;
		rx <= '0';
		wait for 1 us;
		rx <= '1';
		wait for 2 us;
		rx <= '0';
		wait for 1 us;
		rx <= '1';
		wait for 5 us;
		rx <= '0';
		wait for 1 us;
		rx <= '1';
		wait for 1 us;
		rx <= '0';
		wait for 5 us;
		rx <= '1';
		wait for 1 us;
		rx <= '0';
		wait for 3 us;
		rx <= '1';
		wait for 1 us;
		rx <= '0';
		wait for 1 us;
		rx <= '1';
		wait for 9 us;
		rx <='0';  --COMPROBAMOS EL OVERLOAD FRAME APLICANDO UN '0' AL SEGUNDO BIT DE INTERMISSION
		wait for 8 us;
		rx <= '1';   
		
		
		
		
		wait for 30 us;
		rx <='0';
		wait for 30 us;
		rx <='1';
		wait for 10 us;
		rx <='0';
		
		
		
		
		
		
		
		
		
		
		
		
		
		
      wait;
   end process;

END;
