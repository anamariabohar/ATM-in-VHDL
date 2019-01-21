library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity afisor is
    Port ( clk : in STD_LOGIC; --clock-ul placutei
           cat : out STD_LOGIC_VECTOR (6 downto 0); --catozii
           an : out STD_LOGIC_VECTOR (3 downto 0); --anozi
           numar: in STD_LOGIC_VECTOR (11 downto 0) -- ceea ce trebuie sa se afiseze
           );
end afisor;

architecture Behavioral of afisor is
signal num:std_logic_vector(15 downto 0):="0000000000000000";
signal cifra:std_logic_vector(3 downto 0):="0000";
signal thousands :  std_logic_vector( 3 downto 0);
signal hundreds :  std_logic_vector (3 downto 0); 
signal tens :  std_logic_vector (3 downto 0); 
signal ones :  std_logic_vector (3 downto 0);

begin

bin_to_bcd : process (numar) --decodificator din binar in zecimal
	variable shift: unsigned( 27 downto 0);	
	
    alias numr is shift(11 downto 0); 
	alias one is shift(15 downto 12); 
	alias ten is shift(19 downto 16); 
	alias hun is shift(23 downto 20);
	alias tho is shift (27 downto 24);
	
begin
		
    numr := unsigned(numar); 
    one := X"0"; 
    ten := X"0"; 
    hun := X"0";
    tho := X"0";

        for i in 1 to numr'Length loop
            if one >= 5 then 
                one := one + 3; 
            end if;
            if ten >= 5 then 
                ten := ten + 3; 
            end if;
            if hun >= 5 then 
                hun := hun + 3; 
            end if;
            if tho>= 5 then
                tho := tho +3;
            end if;
        shift := shift_left(shift, 1); 
    end loop;

    thousands <= std_logic_vector (tho);
    hundreds <= std_logic_vector(hun); 
    tens <= std_logic_vector(ten); 
    ones <= std_logic_vector(one); 
end process;


process(clk)
begin
    if(clk'Event and clk='1')then
        num<=num+1;
      end if;
end process;
      
process(num(15 downto 14))
  begin
      case num(15 downto 14) is
                  when "00"   => an<="0111"; cifra<=thousands;
                  when "01"   => an<="1011"; cifra<=hundreds;
                  when "10"   => an<="1101"; cifra<=tens;
                  when others => an<="1110"; cifra<=ones;
      end case;
end process;
              
process(cifra)
      begin
        case cifra is
              when "0000" => cat<= "1000000";  --0
              when "0001" => cat<= "1111001";  --1
              when "0010" => cat<= "0100100";  --2
              when "0011" => cat<= "0110000";  --3
              when "0100" => cat<= "0011001";  --4
              when "0101" => cat<= "0010010";  --5
              when "0110" => cat<= "0000010";  --6
              when "0111" => cat<= "1111000";  --7
              when "1000" => cat<= "0000000";  --8
              when "1001" => cat<= "0010000";  --9
              when "1010" => cat<= "0001000";  --A
              when "1011" => cat<= "0000011";  --b
              when "1100" => cat<= "1000110";  --C
              when "1101" => cat<= "0100001";  --d
              when "1110" => cat<= "0000110";  --E
              when "1111" => cat<= "0001110";  --F
              
         end case;
end process;
end Behavioral;