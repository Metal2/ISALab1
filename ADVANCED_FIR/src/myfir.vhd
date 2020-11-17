library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;

--my package
library work;
use work.fir_package.all;


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
	
		DIN_0  : in std_logic_vector(N_BIT - 1 downto 0);		--input samples
		DIN_1  : in std_logic_vector(N_BIT - 1 downto 0);		--input samples
		DIN_2  : in std_logic_vector(N_BIT - 1 downto 0);		--input samples
		VIN   : in std_logic;	    									--valid input 
		RST_n : in std_logic;					    					--active low
		CLK   : in std_logic;											--clock
		VOUT  : out std_logic;											--valid output 
		DOUT_0  : out std_logic_vector(N_BIT - 1 downto 0);	--output samples
		DOUT_1  : out std_logic_vector(N_BIT - 1 downto 0);
		DOUT_2  : out std_logic_vector(N_BIT - 1 downto 0)); 
end myfir;

architecture struct of myfir is

signal ld_pipe: std_logic;
begin
ld_pipe<=VIN or VOUT_pipe(11);

----implementiamo senza pipeline
	h_coef(0)<=H0;
	h_coef(1)<=H1;
	h_coef(2)<=H2;
	h_coef(3)<=H3;
	h_coef(4)<=H4;
	h_coef(5)<=H5;
	h_coef(6)<=H6;
	h_coef(7)<=H7;
	h_coef(8)<=H8;
	h_coef(9)<=H9;
	h_coef(10)<=H10;
	
	
	
-----------------------------------------------
-----GENERAZIONE REGISTRI UNFOLDING------------


	--generiamo gli ingressi registrati (unfolding + pipeline). Il concetto è un ingresso va al suo moltiplicatore dopo un tot di registri
	d_in_0(0)<=DIN_0;
	unfolding_register_input_0: for I in 0 to 3 generate
	unfolding_registers_0_x: 
	reg generic map(
	N=>N_BIT)
	port map(
	clk    => CLK,
	RST_n  => RST_n,
	ld     => ld_pipe,
	d_in   => d_in_0(I),
	d_out  => d_in_0(I+1));
	end generate;
	 
	d_in_1(0)<=DIN_1;
	unfolding_register_input_1: for I in 0 to 3 generate
	unfolding_registers_1_x: 
	reg generic map(
	N=>N_BIT)
	port map(
	clk    => CLK,
	RST_n  => RST_n,
	ld     => ld_pipe,
	d_in   => d_in_1(I),
	d_out  => d_in_1(I+1));
	end generate;
	
	d_in_2(0)<=DIN_2;
	unfolding_register_input_2: for I in 0 to 4 generate
	unfolding_registers_2_x: 
	reg generic map(
	N=>N_BIT)
	port map(
	clk    => CLK,
	RST_n  => RST_n,
	ld     => ld_pipe,
	d_in   => d_in_2(I),
	d_out  => d_in_2(I+1));
	end generate;
	
------------------------------------
------------------------------------
-----GENERAZIONE MOLTIPLICATORI-----


	--generazione prima fila di mult
	
	--generiamo moltiplicatori della prima fila collegati all'ingresso 0
	
	mults_00: for I in 0 to 3 generate
	mults_00_x1: if I<2 generate
	a:mpy generic map(
	N=>N_BIT)
	port map(
	sample  =>  d_in_0(I),
	coeff   =>  h_coef(I*3),
	mpy_out =>  MultoAdd_0(I*3));
	end generate;
	mults_00_x2: if I>1 generate
	b:mpy generic map(
	N=>N_BIT)
	port map(
	sample  =>  d_in_0(I+1),
	coeff   =>  h_coef(I*3),
	mpy_out =>  MultoAdd_0(I*3));
	end generate;
	end generate;
	
	--generiamo moltiplicatori della prima fila collegati all'ingresso 1
	
	mults_01: for I in 0 to 2 generate
	mults_01_x1: if I<2 generate
	c:mpy generic map(
	N=>N_BIT)
	port map(
	sample  =>  d_in_1(I+1),
	coeff   =>  h_coef(2+I*3),
	mpy_out =>  MultoAdd_0(2+I*3));
	end generate;
	mults_01_x2: if I>1 generate
	d: mpy generic map(
	N=>N_BIT)
	port map(
	sample  =>  d_in_1(I+2),
	coeff   =>  h_coef(2+I*3),
	mpy_out =>  MultoAdd_0(2+I*3));
	end generate;
	end generate;
	
	--generiamo moltiplicatori della prima fila collegati all'ingresso 2
	
	mults_02: for I in 0 to 3 generate
	mults_02_x1: if I<2 generate
	e: mpy generic map(
	N=>N_BIT)
	port map(
	sample  =>  d_in_2(I+1),
	coeff   =>  h_coef(1+I*3),
	mpy_out =>  MultoAdd_0(1+I*3));
	end generate;
	mults_02_x2: if I>1 generate
	f: mpy generic map(
	N=>N_BIT)
	port map(
	sample  =>  d_in_2(I+2),
	coeff   =>  h_coef(1+I*3),
	mpy_out =>  MultoAdd_0(1+I*3));
	end generate;
	end generate;
	
	--generazione seconda fila di mux
	
	--generiamo moltiplicatori della seconda fila collegati all'ingresso 0
	
	mults_10: for I in 0 to 3 generate
	mults_10_x1: if I<2 generate
	g:mpy generic map(
	N=>N_BIT)
	port map(
	sample  =>  d_in_0(I),
	coeff   =>  h_coef(1+I*3),
	mpy_out =>  MultoAdd_1(1+I*3));
	end generate;
	mults_10_x2: if I>1 generate
	h:mpy generic map(
	N=>N_BIT)
	port map(
	sample  =>  d_in_0(I+1),
	coeff   =>  h_coef(1+I*3),
	mpy_out =>  MultoAdd_1(1+I*3));
	end generate;
	end generate;
	
	--generiamo moltiplicatori della seconda fila collegati all'ingresso 1
	
	mults_11: for I in 0 to 3 generate
	mults_11_x1: if I<2 generate
	j:mpy generic map(
	N=>N_BIT)
	port map(
	sample  =>  d_in_1(I),
	coeff   =>  h_coef(I*3),
	mpy_out =>  MultoAdd_1(I*3));
	end generate;
	mults_11_x2: if I>1 generate
	k:mpy generic map(
	N=>N_BIT)
	port map(
	sample  =>  d_in_1(I+1),
	coeff   =>  h_coef(I*3),
	mpy_out =>  MultoAdd_1(I*3));
	end generate;
	end generate;
	
	--generiamo moltiplicatori della seconda fila collegati all'ingresso 2
	
	mults_12: for I in 0 to 2 generate
	mults_12_x1: if I<2 generate
	l:mpy generic map(
	N=>N_BIT)
	port map(
	sample  =>  d_in_2(I+1),
	coeff   =>  h_coef(2+I*3),
	mpy_out =>  MultoAdd_1(2+I*3));
	end generate;
	mults_12_x2: if I>1 generate
	m:mpy generic map(
	N=>N_BIT)
	port map(
	sample  =>  d_in_2(I+2),
	coeff   =>  h_coef(2+I*3),
	mpy_out =>  MultoAdd_1(2+I*3));
	end generate;
	end generate;
	
		--generazione terza fila di mux
	
	--generiamo moltiplicatori della terza fila collegati all'ingresso 0
	
	mults_20: for I in 0 to 2 generate
	mults_20_x1: if I<2 generate
	n:mpy generic map(
	N=>N_BIT)
	port map(
	sample  =>  d_in_0(I),
	coeff   =>  h_coef(2+I*3),
	mpy_out =>  MultoAdd_2(2+I*3));
	end generate;
	mults_20_x2: if I>1 generate
	o:mpy generic map(
	N=>N_BIT)
	port map(
	sample  =>  d_in_0(I+1),
	coeff   =>  h_coef(2+I*3),
	mpy_out =>  MultoAdd_2(2+I*3));
	end generate;
	end generate;
	
	--generiamo moltiplicatori della terza fila collegati all'ingresso 1
	
	mults_21: for I in 0 to 3 generate
	mults_21_x1: if I<2 generate
	p:mpy generic map(
	N=>N_BIT)
	port map(
	sample  =>  d_in_1(I),
	coeff   =>  h_coef(1+I*3),
	mpy_out =>  MultoAdd_2(1+I*3));
	end generate;
	mults_21_x2: if I>1 generate
	q:mpy generic map(
	N=>N_BIT)
	port map(
	sample  =>  d_in_1(I+1),
	coeff   =>  h_coef(1+I*3),
	mpy_out =>  MultoAdd_2(1+I*3));
	end generate;
	end generate;
	--generiamo moltiplicatori della terza fila collegati all'ingresso 2
	
	mults_22: for I in 0 to 3 generate
	mults_22_x1: if I<2 generate
	r:mpy generic map(
	N=>N_BIT)
	port map(
	sample  =>  d_in_2(I),
	coeff   =>  h_coef(I*3),
	mpy_out =>  MultoAdd_2(I*3));
	end generate;
	mults_22_x2: if I>1 generate
	s:mpy generic map(
	N=>N_BIT)
	port map(
	sample  =>  d_in_2(I+1),
	coeff   =>  h_coef(I*3),
	mpy_out =>  MultoAdd_2(I*3));
	end generate;
	end generate;
-------------------------------------
-----GENERAZIONE SOMMATORI-----------


	--generiamo sommatori della prima fila
	adder0: for I in 0 to 9 generate
	
	adder00: if I=0 generate
		A00: sum generic map(
		N=>N_BIT+1)
		port map(
		A_in  =>  MultoAdd_0_pipe(0),
		B_in   =>  MultoAdd_0_pipe(1),
		C_out =>  AddtoAdd_0(0));
		end generate;
		
		adder0x1: if (I>0 and I<5) generate
		A0X1: sum generic map(
		N=>N_BIT+1)
		port map(
		A_in  =>  MultoAdd_0_pipe(I+1),
		B_in   =>  AddtoAdd_0(I-1),
		C_out =>  AddtoAdd_0(I));
		end generate;

		adder0x5: if I=5 generate
		A0X5: sum generic map(
		N=>N_BIT+1)
		port map(
		A_in  =>  MultoAdd_0_pipe(I+1),
		B_in   =>  AddtoAdd_0_pipe(I-1),
		C_out =>  AddtoAdd_0(I));
		end generate;

		adder0x2: if I>5 generate
		A0X2: sum generic map(
		N=>N_BIT+1)
		port map(
		A_in  =>  MultoAdd_0_pipe(I+1),
		B_in   =>  AddtoAdd_0(I-1),
		C_out =>  AddtoAdd_0(I));
		end generate;
		
	end generate;
	
	--generiamo sommatori della seconda fila
	adder1: for I in 0 to 9 generate
	
	adder10: if I=0 generate
		A10: sum generic map(
		N=>N_BIT+1)
		port map(
		A_in  =>  MultoAdd_1_pipe(0),
		B_in   =>  MultoAdd_1_pipe(1),
		C_out =>  AddtoAdd_1(0));
		end generate;
		
		adder1x1: if (I>0 and I<5) generate
		A1x1: sum generic map(
		N=>N_BIT+1)
		port map(
		A_in  =>  MultoAdd_1_pipe(I+1),
		B_in   =>  AddtoAdd_1(I-1),
		C_out =>  AddtoAdd_1(I));
		end generate;

		adder1x5: if I=5 generate
		A1x5: sum generic map(
		N=>N_BIT+1)
		port map(
		A_in  =>  MultoAdd_1_pipe(I+1),
		B_in   =>  AddtoAdd_1_pipe(I-1),
		C_out =>  AddtoAdd_1(I));
		end generate;

		adder1x2: if I>5 generate
		A1x2: sum generic map(
		N=>N_BIT+1)
		port map(
		A_in  =>  MultoAdd_1_pipe(I+1),
		B_in   =>  AddtoAdd_1(I-1),
		C_out =>  AddtoAdd_1(I));
		end generate;
		
	end generate;
	
	--generiamo sommatori della terza fila
	adder2: for I in 0 to 9 generate
	
	adder20: if I=0 generate
		A20: sum generic map(
		N=>N_BIT+1)
		port map(
		A_in  =>  MultoAdd_2_pipe(0),
		B_in   =>  MultoAdd_2_pipe(1),
		C_out =>  AddtoAdd_2(0));
		end generate;
		
		adder2x1: if (I>0 and I<5) generate
		A2x1: sum generic map(
		N=>N_BIT+1)
		port map(
		A_in  =>  MultoAdd_2_pipe(I+1),
		B_in   =>  AddtoAdd_2(I-1),
		C_out =>  AddtoAdd_2(I));
		end generate;

		adder2x5: if I=5 generate
		A2x5: sum generic map(
		N=>N_BIT+1)
		port map(
		A_in  =>  MultoAdd_2_pipe(I+1),
		B_in   =>  AddtoAdd_2_pipe(I-1),
		C_out =>  AddtoAdd_2(I));
		end generate;

		adder2x2: if I>5 generate
		A2x2: sum generic map(
		N=>N_BIT+1)
		port map(
		A_in  =>  MultoAdd_2_pipe(I+1),
		B_in   =>  AddtoAdd_2(I-1),
		C_out =>  AddtoAdd_2(I));
		end generate;
		
	end generate;
	
----------------------------------------
----------PIPELINE---------------------
  reg_pipe_vert_0:reg generic map(
							N=>N_BIT+1)
							port map(
							clk 	=> CLK,
							RST_n   => RST_n,
							ld  	=> ld_pipe,
							d_in  	=> AddtoAdd_0(4),
							d_out 	=> AddtoAdd_0_pipe(4));

  reg_pipe_vert_1:reg generic map(
							N=>N_BIT+1)
							port map(
							clk 	=> CLK,
							RST_n   => RST_n,
							ld  	=> ld_pipe,
							d_in  	=> AddtoAdd_1(4),
							d_out 	=> AddtoAdd_1_pipe(4));

  reg_pipe_vert_2:reg generic map(
							N=>N_BIT+1)
							port map(
							clk 	=> CLK,
							RST_n   => RST_n,
							ld  	=> ld_pipe,
							d_in  	=> AddtoAdd_2(4),
							d_out 	=> AddtoAdd_2_pipe(4));

--------------------------------------------------
---PIPELINE TRA MOLTIPLICATORE E SOMMATORE--------
reg_pipe_oriz_0: for I in 0 to 10 generate
  reg_pipe_oriz_impl_0:reg generic map(
							N=>N_BIT+1)
							port map(
							clk 	=> CLK,
							RST_n   => RST_n,
							ld  	=> ld_pipe,
							d_in  	=> MultoAdd_0(I),
							d_out 	=> MultoAdd_0_pipe(I));
end generate;

reg_pipe_oriz_1: for I in 0 to 10 generate
  reg_pipe_oriz_impl_1:reg generic map(
							N=>N_BIT+1)
							port map(
							clk 	=> CLK,
							RST_n   => RST_n,
							ld  	=> ld_pipe,
							d_in  	=> MultoAdd_1(I),
							d_out 	=> MultoAdd_1_pipe(I));
end generate;

reg_pipe_oriz_2: for I in 0 to 10 generate
  reg_pipe_oriz_impl_2:reg generic map(
							N=>N_BIT+1)
							port map(
							clk 	=> CLK,
							RST_n   => RST_n,
							ld  	=> ld_pipe,
							d_in  	=> MultoAdd_2(I),
							d_out 	=> MultoAdd_2_pipe(I));
end generate;

--------------------------------------
-------REGISTRI DI USCITA DOUT--------
	reg_dout0: reg generic map(
					N=>N_BIT)
					port map(
					clk 	=> CLK,
					RST_n   => RST_n,
					ld  	=> '1',
					d_in  	=> AddtoAdd_0(N_TAP-1)(8 downto 1),
					d_out 	=> DOUT_0);
	reg_dout1: reg generic map(
					N=>N_BIT)
					port map(
					clk 	=> CLK,
					RST_n   => RST_n,
					ld  	=> '1',
					d_in  	=> AddtoAdd_1(N_TAP-1)(8 downto 1),
					d_out 	=> DOUT_1);
	reg_dout2: reg generic map(
					N=>N_BIT)
					port map(
					clk 	=> CLK,
					RST_n   => RST_n,
					ld  	=> '1',
					d_in  	=> AddtoAdd_2(N_TAP-1)(8 downto 1),
					d_out 	=> DOUT_2);
---------------------------------------
------PIPELINE VOUT--------------------
VOUT_pipe(0)<='1';
	pipe_VOUT_reg: for I in 0 to 1 generate
	reg_VOUT_pipe0: reg_1bit port map(
					clk 	=> CLK,
					RST_n   => RST_n,
					ld  	=> VIN,
					d_in  	=> VOUT_pipe(I),
					d_out 	=> VOUT_pipe(I+1));
	end generate;


---------------------------------------
----multiplexer che selezione VOUT-----
mux_out: MUX port map(
		a=>'0',
		b=>VOUT_pipe(2),
		s=>sel_mux_VOUT,
		c=>tmp_VOUT);


--------------------------------------
----REGISTRO DI USCITA VOUT-----------
		reg_vout: reg_1bit port map(
				clk 	=> CLK,
				RST_n   => RST_n,
				ld  	=> '1',
				d_in  	=> tmp_vout,
				d_out 	=> VOUT);

---------------------------------------
---------CONTROL UNIT------------------
control_unit : cu 	port map(
		clk       		=>CLK,
		rst_n     		=>RST_n,
		VIN      		=>VIN,
		sel_mux_VOUT 	=> sel_mux_VOUT);
end struct;
