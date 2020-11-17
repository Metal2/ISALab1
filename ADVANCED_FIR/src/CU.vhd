library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity CU is 
port(
		clk      : in std_logic;
		rst_n    : in std_logic;
		VIN      : in std_logic;
		sel_mux_VOUT : out std_logic);
end CU;

architecture behavioral of CU is

	type state_type is (idle,input_data_valid,wait_one_period);
	signal state, next_state: state_type;
	signal tmp_sel_VOUT: std_logic;

	begin
	
	sel_mux_VOUT<=tmp_sel_VOUT;
	
	synch_proc:process(clk,rst_n)
			   begin 
			   if (rst_n = '0') then
					state <= idle;
			   elsif (rising_edge(clk)) then
			        state <= next_state;
			   end if;
			   end process;


	comb_proc: process(state,vin)
		begin

		tmp_sel_VOUT <= '0';
		
		case state is

			when idle   => if (VIN = '0') then
								next_state <= idle;
						   else
								next_state <= input_data_valid;
						   end if;

 			when input_data_valid => 
							  tmp_sel_VOUT <= '1';
							  if (VIN = '1') then
							    next_state <= input_data_valid;
							  else 
								next_state <= idle;
							  end if;

			when others => next_state <= idle;

		end case;
		end process;

	end behavioral;
