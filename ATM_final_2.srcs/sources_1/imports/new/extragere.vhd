library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.NUMERIC_STD.all;


entity extragere is
Port (
       EN: in STD_LOGIC; -- activeaza extragerea
       clk: in STD_LOGIC; --clk-ul placii
       start: in STD_LOGIC; -- cand s-a apasat pe butonul de extragere numerar
       b_1, b_10, b_100: in STD_LOGIC_VECTOR(9 downto 0); --numarul de bancnote din RAM
       br_1, br_10, br_100: out STD_LOGIC_VECTOR(9 downto 0); --returneza numarul de bancnote ramase
       incarcare_sute: in STD_LOGIC; --buton pentru numarul de sute
       incarcare_zeci: in STD_LOGIC; --buton pentru numaul de zeci
       incarcare_unitati: in STD_LOGIC; -- buton incarcare numarul de unitati
       clear: in STD_LOGIC; --reseteaza suma introdusa
       zecimal: in STD_LOGIC_VECTOR(9 downto 0); --pimeste info de pe primele 10 switch-uri de la stanga la dreapta
       suma_existenta : in std_logic_vector (11 downto 0);--suma din cont
       suma_ramasa: out STD_LOGIC_VECTOR(11 downto 0);--suma ramasa dupa extragere
       suma_dorita: out STD_LOGIC_VECTOR(11 downto 0); --suma pe care o doreste clientul
       eroare : out STD_LOGIC --se activeaza daca nu exista bani in cont-bancomat
 );
end extragere;

architecture Behavioral of extragere is

component formare_numar_extragere is 
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
end component ;

component intrare_cifra is --convertor bcd-binar
	port(
	EN: in STD_LOGIC; --activeaza introducerea zecimala de cifre
	cifra : in STD_LOGIC_VECTOR(9 downto 0); --cifrea introdusa zecimal
	cifra_bin: out STD_LOGIC_VECTOR(3 downto 0) -- returneaza cifra introdusa in binar
	);
end component ;	

component convertor_zecimal_binar is
	port(	
	sute: in STD_LOGIC_VECTOR(3 downto 0);
	zeci : in STD_LOGIC_VECTOR(3 downto 0);
	unitati : in STD_LOGIC_VECTOR(3 downto 0);
	numar: out STD_LOGIC_VECTOR(11 downto 0):=(others =>'0') --rezulta numarul in binar 
	);
end component ;
--semnale interne
signal num: STD_LOGIC_VECTOR(22 downto 0):="00000000000000000000000"; --vector de 23 de biti pentru efect
signal cifra_binar : STD_LOGIC_VECTOR(3 downto 0); 
signal sute : STD_LOGIC_VECTOR(3 downto 0);
signal zeci : STD_LOGIC_VECTOR(3 downto 0);
signal unitati : STD_LOGIC_VECTOR(3 downto 0);
signal numar : STD_LOGIC_VECTOR(11 downto 0); 
signal numar1 : STD_LOGIC_VECTOR(11 downto 0);
signal stergere: STD_LOGIC ; 
 

begin
C1: intrare_cifra port map ( EN, zecimal, cifra_binar);
C2: formare_numar_extragere port map (b_1, b_10, b_100, cifra_binar, incarcare_sute ,incarcare_zeci, incarcare_unitati ,stergere ,sute,zeci,unitati);
C3: convertor_zecimal_binar port map (sute, zeci, unitati, numar);

suma_dorita<="000000000000"+numar1;
stergere<= clear or start; --semnal ce indica daca sa se reseteze suma

 process(numar,start,EN)
 begin
    if(numar <= suma_existenta) then --daca e ok, se calculeaza noua suma si numarul de bancnote
        suma_ramasa<=suma_existenta- numar;
        eroare<='0'; 
            if(unitati="0101") then
                br_1<=b_1-1;
            end if;         
        br_10<=b_10-zeci;
        br_100<=b_100-sute;

        else            --- daca suma e mai mare sau nu exista bancnote
            eroare<=EN;
            suma_ramasa<=suma_existenta;
        end if;
 end process;
numar1 <=numar;

-----------------------------
end Behavioral;
