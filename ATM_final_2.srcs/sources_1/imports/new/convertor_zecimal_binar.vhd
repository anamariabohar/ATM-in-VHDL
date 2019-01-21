library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

use IEEE.NUMERIC_STD.all; 

entity convertor_zecimal_binar is
	port(	
	sute: in STD_LOGIC_VECTOR(3 downto 0);
	zeci : in STD_LOGIC_VECTOR(3 downto 0);
	unitati : in STD_LOGIC_VECTOR(3 downto 0);
	numar: out STD_LOGIC_VECTOR(11 downto 0):=(others =>'0') --rezulta numarul in binar 
	);
end entity;

architecture CZB of	convertor_zecimal_binar is
begin
	  numar<="000000000000"+ (unitati * "01")+(zeci* "1010")+ (sute *"1100100");
end CZB;					 