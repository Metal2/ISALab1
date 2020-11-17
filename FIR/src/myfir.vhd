library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

--my package
library work;
use work.fir_package.all;

--8 bit, order 10 myfir filter (TOP LEVEL)
entity myfir is	
	port(
		--filter 8 bit coefficients
		H0  : in std_logic_vector(N_BIT - 1 downto 0);
		H1  : in std_logic_vector(N_BIT - 1 downto 0);
		H2  : in std_logic_vector(N_BIT - 1 downto 0);
		H3  : in std_logic_vector(N_BIT - 1 downto 0);
		H4  : in std_logic_vector(N_BIT - 1 downto 0);
		H5  : in std_logic_vector(N_BIT - 1 downto 0);
		H6  : in std_logic_vector(N_BIT - 1 downto 0);
		H7  : in std_logic_vector(N_BIT - 1 downto 0);
		H8  : in std_logic_vector(N_BIT - 1 downto 0);
		H9  : in std_logic_vector(N_BIT - 1 downto 0);
		H10 : in std_logic_vector(N_BIT - 1 downto 0);
	
		DIN   : in std_logic_vector(N_BIT - 1 downto 0);    --input samples
		VIN   : in std_logic;	    						--valid input 
		RST_n : in std_logic;					    		--active low
		CLK   : in std_logic;								--clock
		VOUT  : out std_logic;								--valid output 
		DOUT  : out std_logic_vector(N_BIT - 1 downto 0));  --output samples
end myfir;

architecture structural of myfir is

begin

----------------------------------------------------
-------------SHIFT REGISTER-------------------------
SHIFT_REG: for I in 0 to N_TAP - 1 generate
	REG0: if I = 0 generate
		R0: reg generic map(
					N => N_BIT)
				port map(
					clk    => CLK,
					RST_n  => RST_n,
					ld     => VIN,
					d_in   => DIN, 
					d_out  => x(I+1));
	end generate REG0;
	
	REGX: if I > 0 generate
		RX: reg generic map(
					N => N_BIT)
				port map(
					clk   => CLK,
					RST_n => RST_n,
					ld    => VIN,
					d_in  => x(I),
					d_out => x(I+1));
	end generate REGX;
end generate SHIFT_REG;

---------------------------------------
-------MULTIPLIERS---------------------
M0: mpy generic map(
			N=> N_BIT)
		port map(
			sample  =>  DIN,
			coeff   =>  H0,
			mpy_out =>	m(0));
M1: mpy generic map(
			N=> N_BIT)
		port map(
			sample  =>  x(1),
			coeff   =>  H1,
			mpy_out =>  m(1));

M2: mpy generic map(
			N=> N_BIT)
		port map(
			sample  => x(2),
			coeff   => H2,
			mpy_out => m(2));
		
M3: mpy generic map(
			N=> N_BIT)
		port map(
			sample  => x(3),
			coeff   => H3,
			mpy_out => m(3));
		
M4: mpy generic map(
			N=> N_BIT)
		port map(
			sample  => x(4),
			coeff   => H4,
			mpy_out => m(4));
		
M5: mpy generic map(
			N=> N_BIT)
		port map(
			sample  => x(5),
			coeff   => H5,
			mpy_out => m(5));
			
M6: mpy generic map(
			N=> N_BIT)
		port map(
			sample  => x(6),
			coeff   => H6,
			mpy_out => m(6));
		
M7: mpy generic map(
			N=> N_BIT)
		port map(
			sample  => x(7),
			coeff   => H7,
			mpy_out => m(7));
		
M8: mpy generic map(
			N=> N_BIT)
		port map(
			sample  => x(8),
			coeff   => H8,
			mpy_out => m(8));
		
M9: mpy generic map(
			N=> N_BIT)
		port map(
			sample  => x(9),
			coeff   => H9,
			mpy_out => m(9));
		
M10: mpy generic map(
			N=> N_BIT)
		port map(
			sample  => x(10),
			coeff   => H10,
			mpy_out => m(10));

-------------------------------
-------ADDER-------------------
ADDER_GEN: for I in 0 to N_TAP - 1 generate
	ADDER0: if I = 0 generate
			S0: sum generic map(
					N=>9)
				port map(
					A_IN  => m(0),
					B_IN  => m(1),
					C_OUT => s(0));
	end generate ADDER0;
	
	ADDERX: if I>0 generate	
			SX: sum generic map(
					N=>9)
				port map(
					A_IN  => m(I+1),
					B_IN  => s(I-1),
					C_OUT => s(I));
	end generate ADDERX;
end generate ADDER_GEN;

-------------------------------
----------OUTPUT REG-----------
DOUT_REG: reg  generic map(
					N=>N_BIT)
				port map(
					clk 	=> CLK,
					RST_n   => RST_n,
					ld  	=> VIN,
					d_in  	=> s(N_TAP - 1)(8 downto 1),
					d_out 	=> DOUT);
			

tmp(0) <= VIN;
VOUT <= tmp_vout(0);
-------------------------------
----------OUT VALID REG--------
VOUT_REG: reg  generic map(
					N=>1)
				port map(
					clk 	=> CLK,
					RST_n   => RST_n,
					ld  	=> '1',
					d_in  	=> tmp,
					d_out 	=> tmp_vout);
					
end structural;
