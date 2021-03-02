----------------------------------------------------------------------------------
-- Company: 
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:08:34 05/06/2020 
-- Design Name: 
-- Module Name:    mux_dato_dec - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
--use IEEE.STD_LOGIC_ARITH.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux_dato_dec is
    Port ( ad_slave,funcion,ad_dato,dato,num_dato,valor_dato : in integer;
           comando_actual : in  STD_LOGIC_VECTOR (8 downto 0);
           salida : out  integer);
end mux_dato_dec;

architecture Behavioral of mux_dato_dec is

begin

  with comando_actual select
    salida <= ad_slave when   "000000001",
				  funcion when    "000000010",
			     ad_dato when    "000000100",
	           dato when       "000001000",
				  num_dato when   "000010000",
				  valor_dato when "000100000",
				  0 when others;
  

end Behavioral;

