library	 IEEE;
use IEEE.STD_LOGIC_1164.all;

entity oper_select is
port (En, s1,s0: in std_logic; --semnal ce indica daca e corect pinul si selectiile de meniu
   OP1, OP2, OP3, OP4: out std_logic); --se activeaza operatia selectata
end oper_select;

architecture OP of oper_select is  --se selecteaza operatia in mod concurent
begin
    
	OP1<= En  and (not s0)and (not s1);
	OP2<= En  and s0 and (not S1);
	OP3<= En  and (not s0) and s1;
	OP4<= En  and s0 and s1;

end OP;

library	 IEEE;
use IEEE.STD_LOGIC_1164.all;

entity bancomat is
port(
    wer:out STD_LOGIC; --led schimbare pin
	corect : out STD_LOGIC;--led pin corect 
	OP1, OP2, OP3, OP4: out std_logic; --led operatii
	eroare: out STD_LOGIC;-- led eroare
	
    cat : out STD_LOGIC_VECTOR (6 downto 0); --afisor
    an : out STD_LOGIC_VECTOR (3 downto 0); --afisor
    
	
	s1,s0: in std_logic; --selectii meniu
	sw: in STD_LOGIC_VECTOR (13 downto 0); -- switchuri 
    btnU: in STD_LOGIC; --verificare pin
    btnR : in STD_LOGIC; --schimbare pin
    btnD: in STD_LOGIC; -- depunere si extragere
    btnL: in STD_LOGIC; -- eliberare card
    btnC: in STD_LOGIC; --stergere suma introdusa la depunere si extragere
   
    clk : in STD_LOGIC --clock
    
	);
end bancomat;
	
architecture bc of bancomat is

component oper_select is --selecteaza operatia
       port (En, s1,s0: in std_logic; --semnal ce indica daca e corect pinul si selectiile de meniu
       OP1, OP2, OP3, OP4: out std_logic); --se activeaza operatia selectata
end component;

component pin_check_and_change is -- verifica si schimba pinul
port(
        cont : in STD_LOGIC_VECTOR (2 downto 0); --contul clientului
		Pin	 : in std_logic_vector(3 downto 0); --pinul
        pin_nou : in STD_LOGIC_VECTOR ( 3 downto 0); --pinul nou daca doreste sa il schimbe
		OP4 : in STD_LOGIC;   --indica daca operatia 4(scimbare pin) a fost selectata de client
        Enter : in STD_LOGIC; --la apasarea butonului se schimba pinul
        EN : in STD_LOGIC; -- buton verificare pin introdus
        Reset: in STD_LOGIC; --reseteaza pinul in caz de eliberare card
		corect : out STD_LOGIC;--returneaza daca pinul e corect
		change_pin_ok: out STD_LOGIC  -- indica ca pinul a fost schimbat cu succes
);
end component;
component ram_utilizator is  --RAM-ul pentru banii clientilor
port (cont : in std_logic_vector(2 downto 0); --contul clientului care e si adresa din RAM pentru banii din cont
        write_enable : in std_logic; --activeaza scrierea in RAM 
		ram_enable : in std_logic; --activeaza RAM-ul
        data_in : in std_logic_vector(11 downto 0); --informatia ce va fi scrisa in RAM - banii
        data_out : out std_logic_vector(11 downto 0) --informatia returnata de ram
     );
end component;
component afisor is --afisor zecimal pe 7 segmente
    Port ( clk : in STD_LOGIC; --clock-ul placutei
           cat : out STD_LOGIC_VECTOR (6 downto 0); --catozii
           an : out STD_LOGIC_VECTOR (3 downto 0); --anozi
          numar: in STD_LOGIC_VECTOR (11 downto 0) -- ceea ce trebuie sa se afiseze
           );
end component;
component ram_bancomat is --RAM-ul cu bancnotele
port (  write_enable : in std_logic; --activeaza scrierea in bancomat ( scade numarul de bancnote in caz de extragere)
        ram_enable : in std_logic; -- activeaza RAM-ul
        incarcare : in STD_LOGIC; -- aduna bancnotele introduse in caz de deounerfe numerar
		s_1, s_10,  s_100: in STD_LOGIC_VECTOR( 9 downto 0); -- numarul nou de bancnote 
		b_1, b_10,  b_100: out STD_LOGIC_VECTOR(9 downto 0) --numarul actual de bancnote
     );
end component;
component extragere is --extragerea de numerar
Port (
       EN: in STD_LOGIC; -- activeaza extragerea
       clk: in STD_LOGIC; --clk-ul placii
       start: in STD_LOGIC; -- cand s-a apasat pe butonul de extragere 
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
end component;
component  depunere is --depunerea de numerar
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
end component;
component debouncer is --debounce la butoane
    port(
    clk: in std_logic; --clock-ul placii
    btn: in std_logic; --butonul pentru debounce
    en: out std_logic --butonul trecut prin "filtru"
    );
end component;

--semnale interne

signal ebtnU: STD_LOGIC; --buton filtrat
signal ebtnR: STD_LOGIC; --buton filtrat
signal ebtnD: STD_LOGIC; --buton filtrat
signal ebtnL: STD_LOGIC; --buton filtrat
signal ebtnC: STD_LOGIC; --buton filtrat
signal Pass : STD_LOGIC:='0';  --semnal intern pentru corectitudinea pinului
signal clear : STD_LOGIC; -- semnal intern pentru stergerea sumei de la depunere-extragere
signal incarcare_sute : STD_LOGIC; --smenal intern
signal incarcare_zeci : STD_LOGIC; --semnal intern
signal incarcare_unitati : STD_LOGIC;--smenal intern 
signal oper1, oper2, oper3, oper4: STD_LOGIC; --retin operatia selectata la un moment dat
signal bani_nou,bani, afisare: STD_LOGIC_VECTOR(11 downto 0); -- banii care circula si care trebuie afisati
signal cont: STD_LOGIC_VECTOR(2 downto 0); -- salvam contul clientului
signal Pin :  STD_LOGIC_VECTOR (3 downto 0); -- salvam pinul clientului
signal Pin_nou:  STD_LOGIC_VECTOR(3 downto 0); --salvam pinul nou
signal zecimal : STD_LOGIC_VECTOR(9 downto 0); --info de pe primele 10 switch-uri
signal extrag_depun: STD_LOGIC; --se activeaza daca e selectata depunerea/extragerea
signal extrag: STD_LOGIC; --semnaleaza apasarea butonului de extragere
signal depun: STD_LOGIC; --semnaleaza apasarea butonului de depunere
signal activare_ram_utilizator : STD_LOGIC; --activeaza RAM-ul in functie de stare
signal activare_ram_bancomat : STD_LOGIC;  --activeaza RAM-ul in functie de stare
signal 	s_1, s_10, s_100:  STD_LOGIC_VECTOR( 9 downto 0); --nr. nou de bancnote ce le va inscrie in RAM
signal 	se_1, se_10, se_100:  STD_LOGIC_VECTOR( 9 downto 0); --nr. nou de bancnote ce le va inscrie in RAM in caz de extragere
signal 	sd_1, sd_10, sd_100:  STD_LOGIC_VECTOR( 9 downto 0); --nr. nou de bancnote ce le va inscrie in RAM in caz de depunere
signal   b_1, b_10, b_100:  STD_LOGIC_VECTOR(9 downto 0); --nr de bancnote existent in bancomat
signal suma_dorita: STD_LOGIC_VECTOR(11 downto 0); --suma dorita la extraagere
signal suma_ramasa_extragere: STD_LOGIC_VECTOR(11 downto 0); --suma ramasa dupa extragere
signal suma_ramasa_depunere: STD_LOGIC_VECTOR(11 downto 0); --suma ramasa dupa depunere
signal suma_dorita_depunere: STD_LOGIC_VECTOR(11 downto 0); --suma dorita pentru depunere
begin

--atribuie semnalelor interne valorile de pe switch-uri sau butoane in funtie de stare
ct: process (btnU,btnL)
begin
    -- initial pornim cu pasul 1 care este citirea id si a pinului
       if(Pass='0') then
	       if(btnU='1' )then 
	           cont<= sw(13 downto 11); --contul de pe switch-uri
		       Pin<=sw(9 downto 6); -- pinul de pe switch-uri
	       end if;
	   end if;
	  -- daca nu suntem in extragere sau in depunere si apasam btnL atunci se reseteaza 
	  -- cont si pin; 
	if(oper2='0') then
	   if(btnL='1' and oper3='0')then 
	        cont<= "000"; -- in caz de eliberare card
            Pin<="0000"; -- in caz de eliberare card
          end if;
    end if;
end process;

--atribuie semnalelor interne valorile de pe switch-uri sau butoane in funtie de stare 
pn: process (oper4,btnR,btnL)
begin
    if(oper4='1') then --schimbare pin
        if(btnR='1')then
             Pin_nou<=sw(13 downto 10); -- se ia pinul de pe switch-uri
	       end if;
	       
	      if(btnL='1')then
	        Pin_nou<="0000"; -- in caz de eliberare card, se reseteaza si pinul din motive de securitate
	        end if;
	  end if;
end process;

-- se citesc de pe switch-uri si butoane informatiile in functie de stare
process(oper2,oper3, ebtnL, ebtnU, ebtnR, ebtnD, ebtnC)
begin
    if(oper2='1' or oper3='1') then --daca e activa operatia de extragere/depunere
        zecimal<=sw(13 downto 4);
        incarcare_sute<=ebtnL;
        incarcare_zeci<=ebtnU;
        incarcare_unitati<=ebtnR;
        clear<=ebtnC;
        extrag_depun<= ebtnD;
        
            if(oper2='1') then -- daca e activa numai operatia de extragere
                extrag<= ebtnD;
                afisare<=suma_dorita;
             elsif(oper3='1') then -- daca e activa numai operatia de extragere
             depun<= ebtnD;
             afisare<=suma_dorita_depunere;
            end if;
        else    ---daca nu e selectata nici extragerea si nici depunerea, se opresc semnalele, devenind 0
            zecimal<="0000000000";
            incarcare_sute<='0';
            incarcare_zeci<='0';
            incarcare_unitati<='0';
            clear<='0';
            extrag_depun<= '0';
            extrag<= '0';
            depun<= '0';
            afisare<=bani; 
    end if;
end process;
--se face debounce pe butoane
D1: debouncer port map (clk, btnU, ebtnU);
D2: debouncer port map (clk, btnR, ebtnR);
D3: debouncer port map (clk, btnL, ebtnL);
D4: debouncer port map (clk, btnD, ebtnD);
D5: debouncer port map (clk, btnC, ebtnC);

--se apeleaza componentele si se citesc informatiile rezultate 

C1: pin_check_and_change port map (cont,Pin,Pin_nou ,oper4, btnR,btnU,btnL, Pass,wer); -- verificare si schimbare pin( verificarea se face instant(concurent)

corect<=Pass; --indica coectitudinea pinului

C2: oper_select port map (Pass, s1, s0, oper1, oper2, oper3, oper4);  --se selecteaza operatia in mod concurent


-- setam ledurile
OP1<= oper1;
OP2<= oper2;
OP3<= oper3;
OP4<= oper4;

--semnale pentru activare componente
activare_ram_utilizator<= oper1 or oper2 or oper3;
activare_ram_bancomat<= oper2 or oper3;

--- se citesc informatiile rezultate din componente
bani_nou<= suma_ramasa_depunere when oper3='1' else suma_ramasa_extragere;
s_1<= sd_1 when oper3='1' else se_1;
s_10<= sd_10 when oper3='1' else se_10;
s_100<= sd_100 when oper3='1' else se_100;

 
C3: ram_utilizator port map (cont, extrag_depun, activare_ram_utilizator, bani_nou, bani); 
C4: ram_bancomat port map( extrag , activare_ram_bancomat,  depun, s_1, s_10, s_100, b_1, b_10, b_100);
C5: extragere port map (oper2,clk,extrag, b_1, b_10, b_100, se_1, se_10, se_100, incarcare_sute, incarcare_zeci, incarcare_unitati, clear, zecimal, bani, suma_ramasa_extragere,suma_dorita, eroare);

--componenta pentru afisorul cu 7 segmente care afiseaza zecimal

c6: afisor port  map ( clk, cat, an, afisare);


c7: depunere port map( oper3,depun, b_1, b_10, b_100, sd_1, sd_10, sd_100, incarcare_sute, incarcare_zeci, incarcare_unitati, clear, zecimal, bani, suma_ramasa_depunere, suma_dorita_depunere);

end bc;