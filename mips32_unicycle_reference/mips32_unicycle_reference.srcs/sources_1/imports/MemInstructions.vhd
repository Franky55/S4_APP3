---------------------------------------------------------------------------------------------
--
--	Université de Sherbrooke 
--  Département de génie électrique et génie informatique
--
--	S4i - APP4 
--	
--
--	Auteur: 		Marc-André Tétrault
--					Daniel Dalle
--					Sébastien Roy
-- 
---------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; -- requis pour la fonction "to_integer"
use work.MIPS32_package.all;

entity MemInstructions is
Port ( 
    i_addresse 		: in std_logic_vector (31 downto 0);
    o_instruction 	: out std_logic_vector (31 downto 0)
);
end MemInstructions;

architecture Behavioral of MemInstructions is
    signal ram_Instructions : RAM(0 to 255) := (
------------------------
-- Insérez votre code ici
------------------------
--  TestMirroir
--X"20100024",
--X"3c011001",
--X"00300821",
--X"8c240000",
--X"0004c820",
--X"0c100007",
--X"08100015",
--X"00805020",
--X"00001020",
--X"200cffff",
--X"340b8000",
--X"000b5c00",
--X"20090020",
--X"11200006",
--X"00021042",
--X"014b4024",
--X"00481025",
--X"000a5040",
--X"2129ffff",
--X"0810000d",
--X"03e00008",
--X"00402820",
--X"22100004",
--X"3c011001",
--X"00300821",
--X"ac220000",
--X"2002000a",
--X"0000000c",

-- TestMirroir sans $t4
--X"20100024",
--X"3c011001",
--X"00300821",
--X"8c240000",
--X"0004c820",
--X"0c100007",
--X"08100015",
--X"00805020",
--X"00001020",
--X"2018ffff",
--X"340b8000",
--X"000b5c00",
--X"20090020",
--X"11200006",
--X"00021042",
--X"014b4024",
--X"00481025",
--X"000a5040",
--X"2129ffff",
--X"0810000d",
--X"03e00008",
--X"00402820",
--X"22100004",
--X"3c011001",
--X"00300821",
--X"ac220000",
--X"2002000a",
--X"0000000c",

--X"3c011001",
--X"8c280000",
--X"2002000a",
--X"0000000c",

--Only LWV
--X"341DFFF0",
--X"23bdfff0",  
--X"24080005",  
--X"afa80000",  
--X"24080002",  
--X"afa80004",  
--X"24080001",  
--X"afa80008",  
--X"24080004",  
--X"afa8000c",  
--X"53AE0000",  
--X"2002000a",
--X"0000000c",


-- LWV SWV
--X"341DFFF0",
--X"23bdfff0",  
--X"24080005",  
--X"afa80000",  
--X"24080002",  
--X"afa80004",  
--X"24080001",  
--X"afa80008",  
--X"24080004",  
--X"afa8000c",  
--X"53AE0000",  
--X"23bdffec",
--X"57AE0000",
--X"2002000a",
--X"0000000c",


--SIMD_TEST_LWV_SWV_ADDV_MINV
--X"341DFFF0",
--X"3C011001",
X"23bdfff0",
X"24080004",
X"afa80000",
X"24080003",
X"afa80004",
X"24080002",
X"afa80008",
X"24080006",
X"afa8000c",
X"53ae0000",
X"23bdfff0",
X"57ae0000",
X"53aD0000", --lwv $t5, 0($sp)
X"59CD6020", --addv
X"5dad4820", --minv $t1, $t5, $t5
X"2002000a",
X"0000000c",


--viterbi
--X"3c011001",
--X"34240000",
--X"3c011001",
--X"34250040",
--X"3c011001",
--X"34260050",
--X"0c100017",
--X"2002000a",
--X"0000000c",
--X"00004020",

--X"508c0000",
--X"50ad0000",
--X"598d7020",
--X"5dce5020",

--X"00067821",
--X"8de90000",
--X"0149c02a",
--X"24090001",
--X"13090002",
--X"03e00008",
--X"00000000",
--X"adeb0000",
--X"03e00008",
--X"23bdffe0",
--X"afbf0000",
--X"afa40004",
--X"afa60008",
--X"afa5000c",
--X"afb00010",
--X"00008020",

--X"3c011001",
--X"502c0060",
--X"54cd0000",

--X"20010004",
--X"1030000e",
--X"8fa40004",
--X"8fa60008",
--X"8fa5000c",
--X"20010004",
--X"72015002",
--X"20010004",
--X"71414802",
--X"00ca5820",
--X"000b3021",
--X"00895820",
--X"000b2021",
--X"0c100009",
--X"22100001",
--X"08100020",
--X"8fb00010",
--X"8fbf0000",
--X"23bd0014",
--X"03e00008",












------------------------
-- Fin de votre code
------------------------
    others => X"00000000"); --> SLL $zero, $zero, 0  

    signal s_MemoryIndex : integer range 0 to 255;

begin
    -- Conserver seulement l'indexage des mots de 32-bit/4 octets
    s_MemoryIndex <= to_integer(unsigned(i_addresse(9 downto 2)));

    -- Si PC vaut moins de 127, présenter l'instruction en mémoire
    o_instruction <= ram_Instructions(s_MemoryIndex) when i_addresse(31 downto 10) = (X"00400" & "00")
                    -- Sinon, retourner l'instruction nop X"00000000": --> AND $zero, $zero, $zero  
                    else (others => '0');

end Behavioral;

