library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.NUMERIC_STD.all;

entity formare_numar_extragere is
	port(
	   b_1, b_10, b_100: in STD_LOGIC_VECTOR(9 downto 0); --bancnotele bancomatului
       cifra: in STD_LOGIC_VECTOR (3 downto 0); --cifra ce se va introduce pe sute, zeci sau unitati
       incarcare_sute : in STD_LOGIC;
       incarcare_zeci : in STD_LOGIC;
       incarcare_unitati : in STD_LOGIC;
       stergere : in STD_LOGIC; ---reseteaza suma
       sute: out STD_LOGIC_VECTOR (3 downto 0); --returneaza sutele
       zeci: out STD_LOGIC_VECTOR (3 downto 0); --returneaza zecile
       unitati: out STD_LOGIC_VECTOR (3 downto 0) -- returneaza unitatile
	
	);
	
end entity ;

architecture fn of formare_numar_extragere is		  

begin						 
	process(incarcare_sute,incarcare_zeci, incarcare_unitati,stergere) 
    begin		 
	   --se formeaza numarul numai daca exista bancnotele necesare in bancomat
	   -- se activeaza butonul de incarcare sute
		if(incarcare_sute='1' and cifra<=b_100) then
			sute<=cifra;
		end if;
        
         -- se activeaza butonul de incarcare zeci      
        if(incarcare_zeci='1' and cifra<=b_10) then
             zeci<=cifra; 
        end if;
             
       -- se activeaza butonul de incarcare unitati                
       if(incarcare_unitati='1' and b_1/="0000000000") then
                -- doar daca e multiplu de 5
              if( (conv_integer(cifra) mod 5) = 0) then
                    unitati<=cifra;
              end if;
         end if;
         
         -- se resetaza suma de introdus      
		if(stergere='1' and incarcare_sute ='0' and incarcare_zeci='0' and incarcare_unitati='0' ) then 
		     sute<="0000";
             zeci<="0000";
             unitati<="0000"; 
         end if;
       
	end process;
	
end fn;			