library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

--N bit register
entity reg is	
	generic(
		N: integer := 8);
	port(
		clk   : in std_logic;
		rst_n : in std_logic;
		ld    : in std_logic;
		d_in  : in  std_logic_vector(N-1 downto 0);
		d_out : out std_logic_vector(N-1 downto 0));
end reg;

architecture behavioral of reg is

signal tmp_out: std_logic_vector(N-1 downto 0);
	
begin

--register process, asynch active_low reset
reg: 	process(clk,rst_n)
		begin
		if (rst_n = '0') then
			tmp_out <= (others=>'0');
		elsif (rising_edge(clk)) then
			if (ld = '1') then
				tmp_out <= d_in;
			end if;
		end if;
		end process;
		
--output assignment
d_out <= tmp_out;

end behavioral;
