library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

--N BIT ADDER
entity sum is	
	generic(
		N: integer := 8);
	port(
		A_in   : in  std_logic_vector(N - 1 downto 0);
		B_in   : in  std_logic_vector(N - 1 downto 0);
		C_out  : out std_logic_vector(N - 1 downto 0));
end sum;

architecture behavioral of sum is


begin

	--trunc N bit result
	C_out <= A_in+B_in;
	
end behavioral;
