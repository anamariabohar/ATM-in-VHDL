library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity pin_check_and_change is
port(
       cont : in STD_LOGIC_VECTOR (2 downto 0); --contul clientului
       Pin     : in std_logic_vector(3 downto 0); --pinul
       pin_nou : in STD_LOGIC_VECTOR ( 3 downto 0); --pinul nou daca doreste sa il schimbe
       OP4 : in STD_LOGIC;   --indica daca operatia 4(scimbare pin) a fost selectata de client
       Enter : in STD_LOGIC; --la apasarea butonului se schimba pinul
       EN : in STD_LOGIC; -- buton verificare pin introdus
       Reset: in STD_LOGIC; --reseteaza pinul in caz de eliberare card
       corect : out STD_LOGIC;--returneaza daca pinul e corect
       change_pin_ok: out STD_LOGIC  -- indica ca pinul a fost schimbat cu succes
);
end pin_check_and_change;

architecture PC of pin_check_and_change is

component ram_pin is --RAM cu pin-urile clientilor
port (
        cont : in std_logic_vector(2 downto 0); --contul clientului
        write_enable : in std_logic; --se activeaza scrierea in RAM
		ram_enable : in std_logic; --activeaza RAM-ul
        pin_in : in std_logic_vector(3 downto 0); --pin-ul nou ce se va scrie in RAM
        pin_out : out std_logic_vector(3 downto 0) --returneaza PIN-ul
     );
end component;
signal a,b : STD_LOGIC_VECTOR(3 downto 0); --semnale interne pentru transmiterea de informatii 
signal change: STD_LOGIC; --semnal intern pentru transmiterea de enable in cazul scrierii in RAM
begin
     schimbare: process(Enter, pin_nou,OP4) --proces pentru schimbare pin
                begin
	                   if (OP4='1')then
                            if (Enter = '1' and pin_nou /= "0000") then 
                                a<=pin_nou;
                                change<=Enter; --pinul se schimba numai daca e diferit de "0000"
                            else 
                                change<='0';
                            end if;
	                   end if;
                 end process;
    
    change_pin_ok<=change; -- indica schimbarea pinului realizata cu succes
	 -- semnalul de ram_enable il punem pe 1
	 C1 : ram_pin port map (cont , change, '1' ,a, b);
	 
    verificare: process (EN,Reset) --proces verificare pin
                begin
                if(EN='1' or Reset = '1') then  -- in caz de eliberare cardS, se va transmite revenirea la stara initiala
   	                if (Pin=b )then
   	                     corect<='1'; 
   	                else 
   	                    corect<='0';
    	            end if;
   	            end if;
   	        end process; 
end PC;