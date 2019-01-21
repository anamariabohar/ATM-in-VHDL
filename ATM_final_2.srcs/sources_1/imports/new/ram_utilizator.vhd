library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity ram_utilizator is
port (  cont : in std_logic_vector(2 downto 0); --contul clientului care e si adresa din RAM pentru banii din cont
        write_enable : in std_logic; --activeaza scrierea in RAM 
	    ram_enable : in std_logic; --activeaza RAM-ul
        data_in : in std_logic_vector(11 downto 0); --informatia ce va fi scrisa in RAM - banii
        data_out : out std_logic_vector(11 downto 0) --informatia returnata de ram
     );
end ram_utilizator;

architecture Arh of ram_utilizator is
-- memoria RAM a banici cu suma de bani detinuta de fiecare client in functie de idCont
-- (0-7 pentru ca avem IdCOnt pe 3 biti 2^3=8 conturi posibile)
type ram_t is array (0 to 7) of std_logic_vector(11 downto 0);
signal ram : ram_t := ( "111000011010",    -- 3610   
                        "000001010101",	  --85				
                        "000100010110",   --278					   
                        "001100000000",   --770
                        "001111101011",
                        others=>"000000000000");  --1003				   

begin

process(ram_enable,write_enable,cont)
begin
    if(ram_enable = '1') then
            if(write_enable='1' and  write_enable'event) then
                ram(conv_integer(cont)) <= data_in; -- in memorie se a scrie suma de bani noua a clientului
  		    end if;
            data_out <= ram(conv_integer(cont));   -- daca writeEnable nu e actiat atunci la iesire o sa avem suma din contul Pinului selectat
     else 
        data_out<= "000000000000";
     end if;
end process;
end Arh;
