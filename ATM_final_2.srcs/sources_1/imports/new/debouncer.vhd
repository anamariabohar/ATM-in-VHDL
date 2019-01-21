library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity debouncer is
    port(
        clk: in std_logic; --clock-ul placii
       btn: in std_logic; --butonul pentru debounce
       en: out std_logic --butonul trecut prin "filtru"
    );
end entity;

architecture Behavioral of debouncer is
signal nr:std_logic_vector(15 downto 0):=x"0000";
signal Q1 : std_logic;
signal Q2 : std_logic;
signal Q3 : std_logic;
begin
   
    process (clk)
    begin
        if clk='1' and clk'event then
        nr <= nr + 1;
        end if;
    end process;
    
    process (clk)
    begin
    if clk'event and clk='1' then
      if nr(15 downto 0) = "1111111111111111" then
      Q1 <= btn;
      end if;
    end if;
    end process;
    
    process (clk)
    begin
    if clk'event and clk='1' then
        Q2 <= Q1;
        Q3 <= Q2;
    end if;
    end process;
    
    en <= Q2 AND (not Q3);
end Behavioral;