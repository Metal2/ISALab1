library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity MUX is
port(
	a: in std_logic;
	b: in std_logic;
	s: in std_logic;
	c: out std_logic);
end entity;

architecture beh of MUX is
begin
process(a,b,s)
begin
case s is
	when '0'=>
				c<=a;
	when others=>
				c<=b;
end case;
end process;
end beh;
