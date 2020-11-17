library IEEE;
use IEEE.std_logic_1164.all;

entity reg_1bit is	
	port(
		clk   : in std_logic;
		rst_n : in std_logic;
		ld    : in std_logic;
		d_in  : in  std_logic;
		d_out : out std_logic);
end reg_1bit;

architecture behavioral of reg_1bit is

signal tmp_out: std_logic;
	
begin

--register process, asynch active_low reset
reg: 	process(clk,rst_n)
		begin
		if (rst_n = '0') then
			tmp_out <= '0';
		elsif (rising_edge(clk)) then
			if (ld = '1') then
				tmp_out <= d_in;
			end if;
		end if;
		end process;
		
--output assignment
d_out <= tmp_out;

end behavioral;
