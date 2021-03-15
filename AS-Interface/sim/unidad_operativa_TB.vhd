--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:41:59 08/08/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/AS-Interface/unidad_operativa_TB.vhd
-- Project Name:  AS-Interface
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY unidad_operativa_TB IS
END unidad_operativa_TB;
 
ARCHITECTURE behavior OF unidad_operativa_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT unidad_operativa
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         management : IN  std_logic;
         dato_anadido : IN  std_logic;
         dir_introducida : IN  std_logic_vector(4 downto 0);
         dato_introducido : IN  std_logic_vector(4 downto 0);
         dato_o_parametro : IN  std_logic;
		 esclavo_no_conectado : OUT boolean:=false;
         dato_a_mostrar : OUT  std_logic_vector(10 downto 0);
         dato_completo : OUT  std_logic_vector(10 downto 0);
         esclavo_off : IN  std_logic_vector(1 downto 0);
         tx_inicio : OUT  std_logic;
		 fase_ciclica_datos : out STD_LOGIC:='0';
		 fase_ciclica_iniciacion: out STD_LOGIC:='0';
         dato_recibido : IN  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal management : std_logic := '0';
   signal dato_anadido : std_logic := '0';
   signal dir_introducida : std_logic_vector(4 downto 0) := "00001";
   signal dato_introducido : std_logic_vector(4 downto 0) := (others => '0');
   signal dato_o_parametro : std_logic := '0';
   signal esclavo_off : std_logic_vector(1 downto 0) := (others => '0');
   signal dato_recibido : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   
   signal dato_a_mostrar : std_logic_vector(10 downto 0);
   signal dato_completo : std_logic_vector(10 downto 0);
   signal tx_inicio : std_logic;
   signal esclavo_no_conectado :  boolean;
   signal fase_ciclica_datos : STD_LOGIC;
   signal fase_ciclica_iniciacion : STD_LOGIC;
   
   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: unidad_operativa PORT MAP (
          clk => clk,
          reset => reset,
          management => management,
          dato_anadido => dato_anadido,
          dir_introducida => dir_introducida,
          dato_introducido => dato_introducido,
          dato_o_parametro => dato_o_parametro,
          dato_a_mostrar => dato_a_mostrar,
		  esclavo_no_conectado => esclavo_no_conectado,
          dato_completo => dato_completo,
          esclavo_off => esclavo_off,
          tx_inicio => tx_inicio,
		  fase_ciclica_iniciacion => fase_ciclica_iniciacion,
		  fase_ciclica_datos  => fase_ciclica_datos,
          dato_recibido => dato_recibido
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
	  
			 wait for clk_period*2;
			 reset <='1';
			 wait for clk_period*2;
			 reset <='0'; 
			 wait for clk_period*2;
			 wait until tx_inicio = '1';
			 wait until tx_inicio = '0';
			  wait for clk_period*5;
			 esclavo_off <= "10";       --ESCLAVO 1
			 dato_recibido <="1010";	--ID
			wait for clk_period*1;
			esclavo_off <= "00";	
			 wait until tx_inicio='1';
			  wait until tx_inicio = '0';
			   wait for clk_period*5;
			 esclavo_off <= "10"; 
			 dato_recibido <="1110";    --IO
			 wait for clk_period*1;
			 esclavo_off <= "00"; 
			 
			 
			  wait until tx_inicio = '1';
			 wait until tx_inicio = '0';
			  wait for clk_period*5;
			 esclavo_off <= "10";       --ESCLAVO 2
			 dato_recibido <="1000";	--ID
			wait for clk_period*1;
			esclavo_off <= "00";	
			 wait until tx_inicio='1';
			  wait until tx_inicio = '0';
			   wait for clk_period*5;
			 esclavo_off <= "10"; 
			 dato_recibido <="1100";    --IO
			 wait for clk_period*1;
			 esclavo_off <= "00"; 
			 
			 
			  wait until tx_inicio = '1';
			 wait until tx_inicio = '0';
			  wait for clk_period*5;
			 esclavo_off <= "10";       --ESCLAVO 3
			 dato_recibido <="0011";	--ID
			wait for clk_period*1;
			esclavo_off <= "00";	
			 wait until tx_inicio='1';
			  wait until tx_inicio = '0';
			   wait for clk_period*5;
			 esclavo_off <= "01";       --SUPUESTO DE IO NO RECIBIDO
			 dato_recibido <="1111";    --IO 
			 wait for clk_period*1;
			 esclavo_off <= "00"; 
			 
			  wait until tx_inicio = '1';
			 wait until tx_inicio = '0';
			  wait for clk_period*5;
			 esclavo_off <= "01";       --ESCLAVO 4 NO CONECTADO
			 dato_recibido <="0011";	--ID
			wait for clk_period*1;
			esclavo_off <= "00";	
			
			 
			 
			  wait until tx_inicio = '1';
			 wait until tx_inicio = '0';
			  wait for clk_period*5;
			 esclavo_off <= "10";       --ESCLAVO 5
			 dato_recibido <="1011";	--ID
			wait for clk_period*1;
			esclavo_off <= "00";	
			 wait until tx_inicio='1';
			  wait until tx_inicio = '0';
			   wait for clk_period*5;
			 esclavo_off <= "10";       
			 dato_recibido <="1001";    --IO 
			 wait for clk_period*1;
			 esclavo_off <= "00"; 
			 
			 
			 wait until tx_inicio = '1';
			 esclavo_off <= "01";
			 
			 wait until fase_ciclica_datos='1';
			 esclavo_off <= "00"; 
			 
			 
			 
										--DATOS 1
			 wait until tx_inicio = '0';
			 wait for clk_period*5;
			 esclavo_off <= "10"; 
			 dato_recibido <="1111";
			 wait for clk_period*1;
			 esclavo_off <= "00";	
			 
			 
			 wait until tx_inicio = '1';   --DATOS 2
			 wait until tx_inicio = '0';
			 wait for clk_period*5;
			 esclavo_off <= "10"; 
			 dato_recibido <="1001";
			 wait for clk_period*1;
			 esclavo_off <= "01";

				--"APAGAMOS" LOS ESCLAVOS PARA COMPROBAR SI SE ELIMINAN
				
				
				--EL SIGUIENTE CODIGO ES PARA INCLUIR UN ESCLAVO NUEVO DURANTE EL FUNCIONAMIENTO NORMAL

			 wait for 15 us;
			 
			 wait until fase_ciclica_iniciacion ='1';
			 esclavo_off <= "00";
			 wait until tx_inicio ='0';
			 esclavo_off <= "10";
			 dato_recibido <= "1111";
			 
			 wait until tx_inicio = '1';
			 dato_recibido <= "1110";
			 
			  wait until tx_inicio = '0';
			  esclavo_off <= "01";
			 ------------------------------------------------------
			 
			  --EL SIGUIENTE CODIGO ES PARA INCLUIR UN ESCLAVO DE FABRICA "00000" Y SUSTITUIR UNO DEFECTUOSO
			  
			  wait for 15 us ;
			  
			  reset <= '1';
			  esclavo_off <= "00";
			  wait for clk_period*2;
			  reset <='0'; 
			 wait for clk_period*2;
			 wait until tx_inicio = '1';
			 wait until tx_inicio = '0';
			  wait for clk_period*5;
			 esclavo_off <= "10";       --ESCLAVO 1
			 dato_recibido <="1010";	--ID
			wait for clk_period*1;
			esclavo_off <= "00";	
			 wait until tx_inicio='1';
			  wait until tx_inicio = '0';
			   wait for clk_period*5;
			 esclavo_off <= "10"; 
			 dato_recibido <="1110";    --IO
	  
			wait until tx_inicio = '1';
			 esclavo_off <= "01";
			 
			
			 
			 wait until fase_ciclica_datos='1';
			 esclavo_off <= "00"; 
			 
			 
			 
			 wait until tx_inicio = '0';
			 esclavo_off <="01";  
			 
			 -------------------
			 
			 wait until fase_ciclica_iniciacion='1';
			 esclavo_off <="10";
			 dato_recibido <="1010";  --ID
			 wait until tx_inicio ='0';
			 esclavo_off <="01";
			 wait until tx_inicio ='1';
			 
			 esclavo_off <="10";
			 dato_recibido <="1110";   --IO
			 wait until tx_inicio = '0';
		     wait for clk_period*1;
			 esclavo_off <= "01";
			 wait until tx_inicio ='1';
			 esclavo_off <="10";
			 dato_recibido <="0110";    --ADDRESS_ASSIGNMENT CORRECTO
			 wait until tx_inicio = '0';
			 wait for clk_period*1;
			 esclavo_off <= "01";
			 wait until tx_inicio ='1';
			 esclavo_off <="10";
			 dato_recibido <="1111";    --RESPUESTA DEL ESCLAVO AL SER ACTIVADO
			 
			 
			 dir_introducida <= "00001";  --test PARA DATO INTRODUCIDO MANUAL
			 dato_introducido <= "01010";
			 dato_anadido <='1';
			 
			 
			 wait until tx_inicio = '0';
			  dato_anadido <='0';
			-- esclavo_off <= "01";
			dato_recibido <="0101";
			 wait until tx_inicio = '1';
			 wait until tx_inicio = '0';
			 management <= '1';
			 wait for clk_period*2;
			 management <= '0';
			 dir_introducida <= "00001";
			 dato_introducido <= "11010";
			 wait for clk_period*5;
			 management <= '0';
			 
			 
			 wait for clk_period*50;
			 dato_o_parametro <='1';
			 dir_introducida <= "00001";
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			
			
			
			 
			 
			 
			 
			 
			 
			 
			 

      wait;
   end process;

END;
