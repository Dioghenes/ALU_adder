library ieee;
use ieee.std_logic_1164.all;

entity sum_generator is 
		generic(log2_N_BIT : integer := 5);
		port(A	   : in std_logic_vector(2**log2_N_BIT-1 downto 0);
			 B	   : in std_logic_vector(2**log2_N_BIT-1 downto 0);
			 Cin   : in std_logic_vector((2**log2_N_BIT)/4-1 downto 0);
			 SUM   : out std_logic_vector(2**log2_N_BIT-1 downto 0));
end entity;

architecture structural of sum_generator is
	-- Used components
	component csb
	 	generic(N : integer := 4);
  		port ( cin 	: in  std_logic;
   	     	   a    : in  std_logic_vector(N-1 downto 0);
   		 	   b    : in  std_logic_vector(N-1 downto 0);
   			   sout : out std_logic_vector(N-1 downto 0);
   			   cout	: out std_logic);
   	end component;
	
	-- Signals for interconnections; all CSB have a c_out signal required by the entity but this is not used externally
	-- All the carry out of CSBs in facts are useless in this kind of adder: the real COUT of the adder is taken from the 
	--    last carry generated by the sparsetree network. 
	signal co_dead : std_logic_vector((2**log2_N_BIT)/4-1 downto 0);

begin
	-- Instantiation of Carry Select Blocks of 4 bits because it is a radix-4 algorithm
	csb_gen : for i in (2**log2_N_BIT)/4-1 downto 0 generate
		csb_i : csb generic map(4)
					port map(Cin(i),A((3+4*i) downto (4*i)),B((3+4*i) downto (4*i)),SUM((3+4*i) downto (4*i)),co_dead(i));
	end generate;		
end architecture;
