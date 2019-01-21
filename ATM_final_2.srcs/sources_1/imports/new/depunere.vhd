library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.NUMERIC_STD.all;


entity depunere is
Port (
       EN: in STD_LOGIC; -- activeaza depunerea
       depus: in STD_LOGIC; --semnaleaza ca s-a apasat butonul de depunere
       b_1, b_10, b_100: in STD_LOGIC_VECTOR(9 downto 0);-- bancnotele existente in bancomat
       br_1, br_10, br_100: out STD_LOGIC_VECTOR(9 downto 0); --numarul nou de bancnote
       incarcare_sute: in STD_LOGIC; -- incarcare cu bancnote de o suta
       incarcare_zeci: in STD_LOGIC; -- incarcare cu bancnote de zece
       incarcare_unitati: in STD_LOGIC; -- incarcare cu bancnote de cate cinci
       clear: in STD_LOGIC; -- reseteaza suma depusa
       zecimal: in STD_LOGIC_VECTOR(9 downto 0); --transmite info de pe primele 10 switchuri de la stanga la dreapta
       suma_existenta : in std_logic_vector (11 downto 0); --suma actuala din cont
       suma_ramasa: out STD_LOGIC_VECTOR(11 downto 0);--suma noua pentru actualizare RAM
       suma_dorita: out STD_LOGIC_VECTOR(11 downto 0) --suma pe care doreste sa o expuna
 );
end depunere;

architecture Behavioral of depunere is

component formare_numar 
	port(
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

component intrare_cifra
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
	numar: out STD_LOGIC_VECTOR(11 downto 0):=(others =>'0')
	);
end component ;

signal cifra_binar : STD_LOGIC_VECTOR(3 downto 0);
signal sute : STD_LOGIC_VECTOR(3 downto 0);
signal zeci : STD_LOGIC_VECTOR(3 downto 0);
signal unitati : STD_LOGIC_VECTOR(3 downto 0);
signal numar : STD_LOGIC_VECTOR(11 downto 0);
signal stergere: STD_LOGIC ;  

begin
C1: intrare_cifra port map ( EN, zecimal, cifra_binar);
C2: formare_numar port map (cifra_binar, incarcare_sute ,incarcare_zeci, incarcare_unitati ,stergere ,sute,zeci,unitati);
C3: convertor_zecimal_binar port map (sute, zeci, unitati, numar);

suma_dorita<="000000000000"+numar;
-- depus o sa fie activ cand suntem in stare de depunere adica s0,s1= 10
stergere<=clear or depus; --se activeaza stergerea sumei introduse

 process(numar)       --se actualizeaza noile sume si numarul de bancnote
 begin
    suma_ramasa<=suma_existenta+ numar;
    if(unitati="0101") then
        br_1<=b_1+1; -- putem introduce pe unitatii doar 5 bacnote de 1;
    end if;
    br_10<=b_10+zeci;
    br_100<=b_100+sute;
end process;
end Behavioral;