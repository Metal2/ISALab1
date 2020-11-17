library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_sink is
  port (
    CLK   : in std_logic;
    RST_n : in std_logic;
    VIN   : in std_logic;
    DIN_0   : in std_logic_vector(7 downto 0);
    DIN_1   : in std_logic_vector(7 downto 0);
    DIN_2   : in std_logic_vector(7 downto 0)); --DIN è l'out del FIR
end data_sink;

architecture beh of data_sink is

begin  -- beh

  process (CLK, RST_n)
    file res_fp : text open WRITE_MODE is "./results.txt";
    variable line_out0,line_out1,line_out2 : line;    
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      null;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      if (VIN = '1') then
        write(line_out0, conv_integer(signed(DIN_0)));
        writeline(res_fp, line_out0);
        write(line_out1, conv_integer(signed(DIN_1)));
        writeline(res_fp, line_out1);
        write(line_out2, conv_integer(signed(DIN_2)));
        writeline(res_fp, line_out2);
      end if;
    end if;
  end process;

end beh;
