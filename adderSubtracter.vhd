--full adder

library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity fullAdder8Bit is
	port (		i_A : in std_logic_vector(7 downto 0);
			i_B : in std_logic_vector(7 downto 0);
			i_Carry_in : in std_logic;
			o_Sum : out std_logic_vector(7 downto 0);
			o_Carry_out : out std_logic);
end fullAdder8Bit;

architecture dataflow of fullAdder8Bit is
signal tempSig : std_logic_vector(8 downto 0);

begin
	tempSig(0) <= i_Carry_in;
	
	forGen: for i in 0 to 7 generate
	  o_Sum(i) <= (i_A(i) xor i_B(i) xor tempSig(i));
	  tempSig(i+1) <= (i_A(i) and i_B(i)) 
				or (i_A(i) and tempSig(i)) 
				or (i_B(i) and tempSig(i));
	end generate forGen;
	
	o_Carry_out <= tempSig(8);
	
end dataflow;





-- twos complement
library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity twosComplement is
	port (		i_A : in std_logic_vector(7 downto 0);
			o_twoComp_out : out std_logic_vector(7 downto 0));
end twosComplement;

architecture dataflow of twosComplement is
signal tempSig : std_logic_vector(7 downto 0);
signal tempCarry : std_logic;
signal binOne : std_logic_vector(7 downto 0) := ("00000001");
signal binZero : std_logic := '0';


begin

	forGen: for i in 0 to 7 generate
		tempSig(i) <= (not i_A(i));
	end generate forGen;
	
	FA1 : entity work.fullAdder8Bit port map(tempSig, binOne, binZero, o_twoComp_out, tempCarry);

end dataflow;





-- 2 to 1 multiplexer
library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity mux2to1primitive is
	port (		i_A : in std_logic_vector(7 downto 0);
			i_B : in std_logic_vector(7 downto 0);
			i_Select : in std_logic;
			o_mux_out : out std_logic_vector(7 downto 0));
end mux2to1primitive;

architecture dataflow of mux2to1primitive is

begin
	forGen: for i in 7 downto 0 generate
	  o_mux_out(i) <= (not i_Select AND i_A(i)) OR (i_Select AND i_B(i));
	end generate forGen;

end dataflow;





--adderSubtracter
library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity adderSubtracter is
	port (		i_A : in std_logic_vector(7 downto 0);
			i_B : in std_logic_vector(7 downto 0);
			i_Carry_in : in std_logic;
			i_Control : in std_logic;
			o_Sum : out std_logic_vector(7 downto 0);
			o_Carry_out : out std_logic);
end adderSubtracter;

architecture dataflow of adderSubtracter is
signal tempSig : std_logic_vector(8 downto 0);
signal BTwosComp : std_logic_vector(7 downto 0);
signal muxOut : std_logic_vector(7 downto 0);

begin

	TC1 : entity work.twosComplement port map (i_B, BTwosComp);
	
	MX1 : entity work.mux2to1primitive port map (i_B, BTwosComp, i_Control, muxOut);
	
	FA2 : entity work.fullAdder8Bit port map (i_A, muxOut, i_Carry_in, o_Sum, o_Carry_out);
	
end dataflow;