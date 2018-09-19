library ieee;
use ieee.std_logic_1164.all;

entity pg_block is 
		port(p   	 : in std_logic;
			 g 		 : in std_logic;
			 p_prev  : in std_logic;
			 g_prev	 : in std_logic;
			 p_out   : out std_logic;
			 g_out	 : out std_logic);
end entity;

architecture structural of pg_block is
begin
	-- Propagate generation
	p_out <= p and p_prev;
	
	-- Generate generation
	g_out <= (p and g_prev) or g;
end architecture;
