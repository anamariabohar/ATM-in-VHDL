library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity ram_bancomat is
port (  write_enable : in std_logic; --activeaza scrierea in bancomat ( scade numarul de bancnote in caz de extragere)
        ram_enable : in std_logic; -- activeaza RAM-ul
        incarcare : in STD_LOGIC; -- aduna bancnotele introduse in caz de deounerfe numerar
		s_1, s_10,  s_100: in STD_LOGIC_VECTOR( 9 downto 0); -- numarul nou de bancnote 
		b_1, b_10,  b_100: out STD_LOGIC_VECTOR(9 downto 0) --numarul actual de bancnote
     );
end ram_bancomat;

architecture Arh of ram_bancomat is

type ram_t is array (0 to 2) of STD_LOGIC_VECTOR(9 downto 0);
signal ram : ram_t := ("111111000",   	--numarul de bacnote de 1 euro
                        "101111000",	--numarul de bacnote de 10 euro				
                        "101111000");	--numarul de bacnote de 100 euro				   
				   
begin
	  
process(ram_enable,write_enable,s_1, s_10, s_100,incarcare)
begin
    if(ram_enable = '1') then
        if(write_enable='1' and write_enable'EVENT) then
            -- in caz ca se activeaza scrierea 
            -- in memorie se va scrie noile numar de bacnote 
            ram(0)<= ram(0)-s_1;
			ram(1)<= ram(1)-s_10;
			ram(2)<= ram(2)-s_100;
		end if;	
			
	  if(incarcare='1' and incarcare'EVENT) then
            ram(0)<= ram(0)+s_1;
			ram(1)<= ram(1)+s_10;
			ram(2)<= ram(2)+s_100;
			
	   end if;
	
	b_1<= ram(0);
	b_10<= ram(1);
	b_100<= ram(2);
	end if;
end process;
end Arh;