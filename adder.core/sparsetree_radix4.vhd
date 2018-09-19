library ieee;
use ieee.std_logic_1164.all;

entity sparsetree_radix4 is
		generic(log2_N_BIT : integer := 5);
		port(A	 : in std_logic_vector(2**log2_N_BIT-1 downto 0);		-- Operand A
			 B   : in std_logic_vector(2**log2_N_BIT-1 downto 0);		-- Operand B
			 Cin : in std_logic;										-- First carry in
			 g_o : out std_logic_vector((2**log2_N_BIT)/4 downto 0));	-- Carry vector generated
end entity;

architecture structural of sparsetree_radix4 is
	
	-- Components used
	component pg_network
		generic(log2_N_BIT	: integer := 8);
		port(A	   : in std_logic_vector(2**log2_N_BIT-1 downto 0);
			 B	   : in std_logic_vector(2**log2_N_BIT-1 downto 0);
			 Cin   : std_logic;
			 P	   : out std_logic_vector(2**log2_N_BIT-1 downto 0);
			 G	   : out std_logic_vector(2**log2_N_BIT-1 downto 0));
	end component;
	
	component g_block
		port(p   	 : in std_logic;
			 g 		 : in std_logic;
			 p_prev  : in std_logic;
			 g_prev	 : in std_logic;
			 g_out	 : out std_logic);
	end component;
	
	component pg_block
		port(p  	 : in std_logic;
			 g  	 : in std_logic;
			 p_prev  : in std_logic;
			 g_prev  : in std_logic;
			 p_out   : out std_logic;
			 g_out	 : out std_logic);
	end component;
	
	-- Signal for interconnections
	type signal_vector is array (log2_N_BIT downto 0) of std_logic_vector(2**log2_N_BIT-1 downto 0);
	
	-- Matrices of propagate signals and generate signals
	signal prop_sig : signal_vector;
	signal gen_sig  : signal_vector;

begin

	-- Create the initial PG network
	pg_net : pg_network generic map (log2_N_BIT)
						     			port map (	A, 
									          	 	B, 
													Cin,
													prop_sig(log2_N_BIT), 
													gen_sig(log2_N_BIT));
		
		
	-- First two rows that are always the same for every number of bits
	row_gen : for row in log2_N_BIT downto log2_N_BIT-1 generate
		col_gen : for col in 0 to (2**(row-1))-1 generate			
				comm_pg_j : pg_block port map(prop_sig(row)(col*2+1),
											  gen_sig(row)(col*2+1), 	
											  prop_sig(row)(col*2),
									      	  gen_sig(row)(col*2), 														
										      prop_sig(row-1)(col),
											  gen_sig(row-1)(col));
		end generate col_gen;
	end generate row_gen;
	
	-- Other rows
	row_gen_o : for row in log2_N_BIT-2 downto 1 generate
		col_gen_o : for col in 0 to 2**(row-1)-1 generate
			
			-- Generate a connection
				inst_conn : for i in 0 to (2**log2_N_BIT)/(2**(2+row))-1 generate
					gen_sig(row-1)(col*2**(log2_N_BIT-1-row)+i) <= gen_sig(row)(col*2**(log2_N_BIT-1-row)+i);
					prop_sig(row-1)(col*2**(log2_N_BIT-1-row)+i) <= prop_sig(row)(col*2**(log2_N_BIT-1-row)+i);
				end generate inst_conn;
			
			-- Generate a pg_block or a g_block if it it the first column
				inst_pgORg : for i in 0 to (2**log2_N_BIT)/(2**(2+row))-1 generate
					col0 : if col>0 generate
						comm_pg : pg_block port map(prop_sig(row)(col*2**(log2_N_BIT-1-row)+2**(log2_N_BIT-2-row)+i),
																			  gen_sig(row)(col*2**(log2_N_BIT-1-row)+2**(log2_N_BIT-2-row)+i),
																			  prop_sig(row)(col*2**(log2_N_BIT-1-row)+2**(log2_N_BIT-2-row)-1),
											 								  gen_sig(row)(col*2**(log2_N_BIT-1-row)+2**(log2_N_BIT-2-row)-1),
																			  prop_sig(row-1)(col*2**(log2_N_BIT-1-row)+2**(log2_N_BIT-2-row)+i),
																			  gen_sig(row-1)(col*2**(log2_N_BIT-1-row)+2**(log2_N_BIT-2-row)+i));
					end generate col0;
					coli : if col=0 generate
						comm_g : g_block port map(prop_sig(row)(col*2**(log2_N_BIT-1-row)+2**(log2_N_BIT-2-row)+i),
											  						  gen_sig(row)(col*2**(log2_N_BIT-1-row)+2**(log2_N_BIT-2-row)+i),
											  						  prop_sig(row)(col*2**(log2_N_BIT-1-row)+2**(log2_N_BIT-2-row)-1),
											  						  gen_sig(row)(col*2**(log2_N_BIT-1-row)+2**(log2_N_BIT-2-row)-1),
											  						  gen_sig(row-1)(col*2**(log2_N_BIT-1-row)+2**(log2_N_BIT-2-row)+i));
					end generate coli;
				end generate inst_pgORg;
			
		end generate col_gen_o;
	end generate row_gen_o;
	
	-- Vector containing the generated carries with the C_in
	g_o <= gen_sig(0)((2**log2_N_BIT)/4-1 downto 0) & Cin;
			
end architecture;
