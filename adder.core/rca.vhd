library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;


entity RCA is 
	Generic (N     :	Integer := 4);
	Port (	A:	In	std_logic_vector(N-1 downto 0);
			B:	In	std_logic_vector(N-1 downto 0);
			Ci:	In	std_logic;
			S:	Buffer	std_logic_vector(N-1 downto 0);
			Co:	Out	std_logic);
end entity; 


-- STRUCTURAL architecture
architecture STRUCTURAL of RCA is

  -- Sum and carry signals
  signal STMP : std_logic_vector(N-1 downto 0);
  signal CTMP : std_logic_vector(N downto 0);

  -- Used components
  component FA 
 	Port ( A:	In	std_logic;
	       B:	In	std_logic;
	       Ci:	In	std_logic;
           S:	Out	std_logic;
	       Co:	Out	std_logic);
  end component; 
begin
  CTMP(0) <= Ci;
  S <= STMP;
  Co <= CTMP(N);
  
  fa_gen: for I in 1 to N generate
    fa_i : FA 
	  Port Map (A(I-1), B(I-1), CTMP(I-1), STMP(I-1), CTMP(I)); 
  end generate;
end architecture;
