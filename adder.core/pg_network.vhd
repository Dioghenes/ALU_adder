library ieee;
use ieee.std_logic_1164.all;

entity pg_network is
		generic(log2_N_BIT	: integer := 5);
		port(A	   : in std_logic_vector(2**log2_N_BIT-1 downto 0);
			 B	   : in std_logic_vector(2**log2_N_BIT-1 downto 0);
			 Cin   : std_logic;
			 P	   : out std_logic_vector(2**log2_N_BIT-1 downto 0);
			 G	   : out std_logic_vector(2**log2_N_BIT-1 downto 0));
end entity;

architecture structural of pg_network is
	signal first_prop : std_logic;
begin

	pg_gen : for i in 0 to 2**log2_N_BIT-1 generate
	
		-- The first block requires some more logic because Cin must be taken into account
		first_block : if i=0 generate
			first_prop <= A(i) xor B(i);
			P(i) <= first_prop;
			G(i) <= (A(i) and B(i)) or (Cin and first_prop);
		end generate first_block;
		
		-- The other blocks are simpler
		other_blocks : if i>0 generate
			P(i) <= A(i) xor B(i);
			G(i) <= A(i) and B(i);
		end generate other_blocks;
	end generate;
	
end architecture;
