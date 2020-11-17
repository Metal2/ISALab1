library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

--N bit multiplier
entity mpy is	
	generic(
		N: integer := 8);
	port(
		sample  : in  std_logic_vector(N - 1 downto 0);
		coeff   : in  std_logic_vector(N - 1 downto 0);
		mpy_out : out std_logic_vector(N  downto 0));
end mpy;

architecture behavioral of mpy is

signal tmp_m : std_logic_vector (N*2 -1 downto 0);

begin

	tmp_m <= sample*coeff;
	mpy_out<= tmp_m(15 downto 7);

end behavioral;
