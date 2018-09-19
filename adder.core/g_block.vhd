library ieee;
use ieee.std_logic_1164.all;

entity g_block is 
		port(p   	 : in std_logic;
			 g 		 : in std_logic;
			 p_prev  : in std_logic;
			 g_prev	 : in std_logic;
			 g_out	 : out std_logic);
end g_block;

architecture structural of g_block is
begin
	-- Generate generation
	g_out <= (p and g_prev) or g;
end structural;
