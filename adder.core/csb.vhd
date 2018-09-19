-- This block contains two 4bits RCAs and one MUX

library ieee;
use ieee.std_logic_1164.all;

entity csb is
  generic(N : integer := 4);
  port ( cin 	: in  std_logic;						-- Taken from the sparsetree
   	     a      : in  std_logic_vector(N-1 downto 0);	-- Addend A
   		 b      : in  std_logic_vector(N-1 downto 0);	-- Addend B
   		 sout   : out std_logic_vector(N-1 downto 0);	-- Sum
   		 cout	: out std_logic);						-- Useless because the Cout of the adder is taken from sparsetree (last bit)
   		 																		--   Reported only to debug each single block.
end entity;

architecture structural of csb is
  
  	-- Used components
	component RCA
		Generic (N     :	Integer := 8);
		Port (	A:	In	std_logic_vector(N-1 downto 0);
				B:	In	std_logic_vector(N-1 downto 0);
				Ci:	In	std_logic;
				S:	Buffer	std_logic_vector(N-1 downto 0);
				Co:	Out	std_logic);
	end component; 

	component MUX21_GENERIC 
		Generic(N: integer := 32);
		Port (one:	In	std_logic_vector(N-1 downto 0);
	      	  zero:	In	std_logic_vector(N-1 downto 0);
	      	  sel:	In	std_logic;
	      	  Y:	Out	std_logic_vector(N-1 downto 0));
	end component;

	-- Signals used
	signal sout_0, sout_1: std_logic_vector(N-1 downto 0);
	signal cout_0, cout_1: std_logic;

begin 
		RCA_0: RCA 	generic map(N => N)
					port map(a, b, '0', sout_0, cout_0);
		RCA_1: RCA 	generic map(N => N)
					port map(a, b, '1', sout_1, cout_1);
		MUX_sum: MUX21_GENERIC	generic map(N => N)
								port map(sout_1, sout_0, cin, sout);
		cout <= '0';				-- Useless in this case, so forced to '0'
end architecture;






