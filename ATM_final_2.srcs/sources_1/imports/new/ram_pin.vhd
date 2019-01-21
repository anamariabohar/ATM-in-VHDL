library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity ram_pin is
port (
        cont : in std_logic_vector(2 downto 0);
        write_enable : in std_logic;
		ram_enable : in std_logic;
        pin_in : in std_logic_vector(3 downto 0);
        pin_out : out std_logic_vector(3 downto 0)
     );
end ram_pin;

architecture Arh of ram_pin is
-- memoria de pinuri
type ram_t is array (0 to 7 ) of std_logic_vector(3 downto 0);
signal ram : ram_t := ("0101",   
"1010",					
"0011",					   
"1101",
"1111",
others => "0000");					   

begin

process(ram_enable,write_enable,cont )
begin
    if(ram_enable= '1') then --event!
        if(write_enable='1') then
            ram(conv_integer(cont)) <= pin_in;
        end if;
        pin_out <= ram(conv_integer(cont));
	end if;
end process;
end Arh;