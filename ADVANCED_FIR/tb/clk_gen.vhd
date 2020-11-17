library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clk_gen is
  port (
    END_SIM : in  std_logic;
    CLK     : out std_logic;
	PAUSE   : out std_logic;--aggiunta
    RST_n   : out std_logic);
end clk_gen;

architecture beh of clk_gen is

  constant Ts : time := 10 ns; --si regola il tempo di clock
  constant pause_delay : time := 110 ns;


  signal CLK_i : std_logic;
  
begin  -- beh

  --genereation of PAUSE signal
    process
  	begin  -- process
    PAUSE <= '0';
    wait for pause_delay;
    PAUSE <= '1';
    wait for 30 ns;
	PAUSE<='0';
	wait;
   end process;
--PAUSE<='0';


  process
  begin  -- process
    if (CLK_i = 'U') then
      CLK_i <= '0';
    else
      CLK_i <= not(CLK_i);
    end if;
    wait for Ts/2;
  end process;

  CLK <= CLK_i and not(END_SIM);

  process
  begin  -- process
    RST_n <= '0';
    wait for 3*Ts/2; --tempo del reset
    RST_n <= '1';
    wait;
  end process;

end beh;
