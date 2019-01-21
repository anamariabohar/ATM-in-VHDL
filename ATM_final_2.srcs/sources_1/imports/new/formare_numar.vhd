library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.NUMERIC_STD.all;

entity formare_numar is
	port(
	cifra: in STD_LOGIC_VECTOR (3 downto 0);
	incarcare_sute : in STD_LOGIC;
	incarcare_zeci : in STD_LOGIC;
	incarcare_unitati : in STD_LOGIC;
	stergere : in STD_LOGIC;
	sute: out STD_LOGIC_VECTOR (3 downto 0);
	zeci: out STD_LOGIC_VECTOR (3 downto 0);
	unitati: out STD_LOGIC_VECTOR (3 downto 0)
	
	);
	
end entity ;

architecture fn of formare_numar is		  

begin						 
	process(incarcare_sute,incarcare_zeci, incarcare_unitati,stergere)
    begin		 
	   
		if(incarcare_sute='1' ) then
			sute<=cifra;
		end if;
        
               
        if(incarcare_zeci='1' ) then
             zeci<=cifra; 
             end if;
             
                       
       if(incarcare_unitati='1') then
       -- multiplu de 5
       if( (conv_integer(cifra) mod 5) = 0) then
            unitati<=cifra;
           end if;
         end if;
               
		if(stergere='1' and incarcare_sute ='0' and incarcare_zeci='0' and incarcare_unitati='0' ) then 
		    sute<="0000";
             zeci<="0000";
             unitati<="0000"; 
         end if;
       
	end process;
	
end fn;			