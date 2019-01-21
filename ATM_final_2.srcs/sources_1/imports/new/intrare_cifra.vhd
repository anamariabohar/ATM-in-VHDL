library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity intrare_cifra is
	port(
	    EN: in STD_LOGIC; --activeaza introducerea zecimala de cifre
        cifra : in STD_LOGIC_VECTOR(9 downto 0); --cifrea introdusa zecimal
        cifra_bin: out STD_LOGIC_VECTOR(3 downto 0) -- returneaza cifra introdusa in binar
	);
end entity;

architecture ic of intrare_cifra is
begin
	process (EN,cifra)
	begin
	if(EN='1') then
		case cifra is
			when "1000000000" => cifra_bin<= "0000";
			when "0100000000" => cifra_bin<= "0001";
			when "0010000000" => cifra_bin<= "0010";
			when "0001000000" => cifra_bin<= "0011";
			when "0000100000" => cifra_bin<= "0100";
			when "0000010000" => cifra_bin<= "0101";
			when "0000001000" => cifra_bin<= "0110";
			when "0000000100" => cifra_bin<= "0111";
			when "0000000010" => cifra_bin<= "1000";
			when "0000000001" => cifra_bin<= "1001"; 
			when others => cifra_bin<= "0000";
		end case;
		end if;
	end process;
	
end ic;
