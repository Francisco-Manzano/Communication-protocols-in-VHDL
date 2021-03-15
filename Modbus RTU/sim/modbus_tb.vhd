--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:21:57 04/25/2020
-- Design Name:   
-- Module Name:   C:/Users/paquiolo/Desktop/universidad/TFG protocolos de comunicacion/MODBUS/modbus_tb.vhd
-- Project Name:  MODBUS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: uart_top
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
 
ENTITY modbus_tb IS
END modbus_tb;
 
ARCHITECTURE behavior OF modbus_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uart_top
   Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
		   tx: out STD_LOGIC;
		   rx : in STD_LOGIC;
           --rx_tx : inout  STD_LOGIC; --entrada/salida de datos RS485
		   tx_inicio: in STD_LOGIC;  -- señal desde el modulo CRC
		   tx_activo: out STD_LOGIC; --TX ESTA TRANSMITIENDO
		   tx_fin: out STD_LOGIC;
		   rx_fin: out STD_LOGIC; -- bandera de byte recibido 
		   numerobytes: in integer;
           datos : in  STD_LOGIC_VECTOR (120 downto 0); -- MENSAJE + CRC A ENVIAR
		   datos_recibidos: out STD_LOGIC_VECTOR ( 7 downto 0); -- byte desde el modulo receptor
		   rx_fin_trama: out STD_LOGIC);  --bandera de fin de trama testbench
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal tx_inicio : std_logic := '0';
   signal rx: std_logic:= '0';
   signal numerobytes: integer:= 0;
   signal datos : std_logic_vector(120 downto 0) := (others => '0');


 	--Outputs
   signal tx: std_logic:='0';
   signal tx_activo : std_logic:='0';
   signal tx_fin : std_logic:='0';
   signal rx_fin : std_logic:='0';
   signal rx_fin_trama : std_logic:='0';
   signal datos_recibidos: std_logic_vector( 7 downto 0):= (others=> '0');

   -- Clock period definitions
    constant clk_period : time := 20 ns;  --50 Mhz   
	constant uart_periodo : time := 8680 ns;  -- 1/115200
	
	procedure uart_recibir (
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
	 
	 end uart_recibir;	
  
	
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uart_top PORT MAP (
          clk => clk,
          reset => reset,
          tx => tx,
		  rx => rx,
          tx_inicio => tx_inicio,
          tx_activo => tx_activo,
          tx_fin => tx_fin,
          rx_fin => rx_fin,
		  numerobytes=> numerobytes,
          datos => datos,
		  datos_recibidos => datos_recibidos,
          rx_fin_trama => rx_fin_trama
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
			 wait until rising_edge(clk);
			 numerobytes <= 4;
			wait for clk_period*3;
			 datos(31 downto 0) <= X"8F0301FF";
			wait until rising_edge(clk);
			tx_inicio   <= '1';
			wait until rising_edge(clk);
			tx_inicio   <= '0';
			wait until tx_activo ='0';
			wait for clk_period*10;
			wait until rising_edge(clk);
			wait for clk_period*100;  
			
			-- envia bytes UART
			wait until rising_edge(clk);
			uart_recibir(X"A5",rx);
			wait until rising_edge(clk);
			uart_recibir(X"13", rx);
			wait until rx_fin_trama ='1';
		
			wait until rising_edge(clk);
			 datos(31 downto 0) <= X"FFFFFFFF";
			wait for 600 ns;
			tx_inicio   <= '1';
			wait until rising_edge(clk);
			tx_inicio   <= '0';
			wait until tx_activo ='0';
			wait for clk_period*10;
			wait until rising_edge(clk);
			wait for clk_period*100;  
			
			-- -- envia bytes  UART
			-- wait until rising_edge(clk);
			-- uart_recibir(X"A5", rx);
			-- wait until rising_edge(clk);
			-- uart_recibir(X"13", rx);
			-- wait until rx_fin_trama ='1';

			
      wait;
   end process;

END;
