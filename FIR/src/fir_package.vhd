library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

PACKAGE fir_package IS

	--FIR PARAMETERS AND TYPES
	constant N_BIT   : integer := 8;  --number of bits 
	constant N_TAP   : integer := 10; --number of taps
	
	type NTAP_8b_array is array(0 to 10) of std_logic_vector(7 downto 0); 
	signal x : NTAP_8b_array; -- shifted samples array

	type NTAP_9b_array is array(0 to 10) of std_logic_vector(8 downto 0);
	signal m : NTAP_9b_array;	
	signal s : NTAP_9b_array;  

	--TMP component wires
	signal tmp      : std_logic_vector(0 downto 0);
	signal tmp_vout : std_logic_vector(0 downto 0);
	signal tmp_vin  : std_logic_vector(0 downto 0);
		
	--COMPONENTS
	component sum is	
		generic(
			N: integer := 8);
		port(
			A_in   : in  std_logic_vector(N - 1 downto 0);
			B_in   : in  std_logic_vector(N - 1 downto 0);
			C_out  : out std_logic_vector(N - 1 downto 0));
	end component;
	
	component reg is	
		generic(
			N: integer := 8);
		port(
			clk   : in std_logic;
			rst_n : in std_logic;
			ld    : in std_logic;
			d_in  : in  std_logic_vector(N-1 downto 0);
			d_out : out std_logic_vector(N-1 downto 0));
	end component;

	component mpy is	
		generic(
			N: integer := 8);
		port(
			sample  : in  std_logic_vector(N - 1 downto 0);
			coeff   : in  std_logic_vector(N - 1 downto 0);
			mpy_out : out std_logic_vector(N downto 0));
	end component;
	
END fir_package;
