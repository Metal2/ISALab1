library IEEE;
use ieee.std_logic_1164.all;

PACKAGE fir_package IS

	--FIR PARAMETERS AND TYPES
	constant N_BIT      : integer := 8;  --number of bits
	constant N_TAP      : integer := 10; --number of taps
	
	type NTAP_8b_array is array(0 to 10) of std_logic_vector(7 downto 0); 
	signal x : NTAP_8b_array; -- shifted samples array
	signal m : NTAP_8b_array; -- multiplied samples array
	signal s : NTAP_8b_array; -- added samples array (we only need NTAP - 1 components)
	
	
	signal h_coef: NTAP_8b_array;
	
	
	type NTAP_9b_array is array(0 to 10) of std_logic_vector(8 downto 0);
	type NTAPminus1_9b_array is array(0 to 9) of std_logic_vector(8 downto 0);
	
	signal MultoAdd_0,MultoAdd_1,MultoAdd_2: NtaP_9b_array;
	signal AddtoPipe_0,AddtoPipe_1,AddtoPipe_2: NtaP_9b_array;
	signal PipetoAdd_0,PipetoAdd_1,PipetoAdd_2: NtaP_9b_array;
	signal AddtoAdd_0,AddtoAdd_1,AddtoAdd_2: NtaPminus1_9b_array;
	
	signal output_0,output_1,output_2: std_logic_vector(7 downto 0);

	type thirteen_8b_array is array(0 to 13) of std_logic_vector(7 downto 0); 
	type twelve_8b_array is array(0 to 12) of std_logic_vector(7 downto 0); 
	type ten_1b_array is array(0 to 11) of std_logic; 
	signal d_in_0,d_in_1: twelve_8b_array;
	signal d_in_2: thirteen_8b_array;
	signal MultoAdd_0_pipe,MultoAdd_1_pipe,MultoAdd_2_pipe: NtaP_9b_array;
	signal AddtoAdd_0_pipe,AddtoAdd_1_pipe,AddtoAdd_2_pipe: NTAP_9b_array;
	signal VOUT_pipe: ten_1b_array;
	

-----------------------------------	
-------CONTROL UNIT----------------
	signal tmp_VOUT:std_logic;
	signal sel_mux_VOUT : std_logic;
	
	--COMPONENTS
	component sum is	
		generic(
			N: integer := 9);
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
			mpy_out : out std_logic_vector(N  downto 0));
	end component;
	
	component reg_1bit is	
		port(
			clk   : in std_logic;
			rst_n : in std_logic;
			ld    : in std_logic;
			d_in  : in  std_logic;
			d_out : out std_logic);
	end component;

		component CU is
		port (
		clk      : in std_logic;
		rst_n    : in std_logic;
		VIN      : in std_logic;
		sel_mux_VOUT: out std_logic);
	end component;

	component MUX is
	port(
		a: in std_logic;
		b: in std_logic;
		s: in std_logic;
		c: out std_logic);
	end component;
	
END fir_package;
