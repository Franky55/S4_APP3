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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MIPS32_package.all;

entity BancRegistres is
    Port ( clk       : in  std_logic;
           reset     : in  std_logic;
           i_RS1     : in  std_logic_vector (4 downto 0);
           i_RS2     : in  std_logic_vector (4 downto 0);
           i_Wr_DAT  : in  std_logic_vector (31 downto 0);
           i_Wr_DAT_vec: in  std_logic_vector (127 downto 0);
           i_WDest   : in  std_logic_vector (4 downto 0);
           i_WE 	 : in  std_logic;
           o_RS1_DAT : out std_logic_vector (127 downto 0);
           o_RS2_DAT : out std_logic_vector (127 downto 0));
end BancRegistres;

architecture comport of BancRegistres is
    signal regs: RAM(0 to 31) := (29 => X"100103FC", -- registre $SP
                                others => (others => '0'));
    signal regsV: RAM128(0 to 2) := (others => (others => '0'));     
                        
begin
    process( clk, i_WE, reset, i_WDest, regs, regsV, i_RS1, i_RS2 )
    begin
        if clk='1' and clk'event then
            if i_WE = '1' and reset = '0' and i_WDest /= "00000" then
                if (unsigned(i_WDest) = 15 or unsigned(i_WDest) = 14 or unsigned(i_WDest) = 13 or unsigned(i_WDest) = 12) then
                    regsV( to_integer( unsigned(i_WDest))- 12) <= i_Wr_DAT_vec;
                else
                    regs( to_integer( unsigned(i_WDest))) <= i_Wr_DAT;
                end if;
            end if;
        end if;
        
        if (unsigned(i_RS1) = 15 or unsigned(i_RS1) = 14 or unsigned(i_RS1) = 13 or unsigned(i_RS1) = 12) then  -- si registre $t4 - $t7
            o_RS1_DAT <= regsV( to_integer(unsigned(i_RS1))-12);                                                -- vector -12 pour drop a 0
        else
            o_RS1_DAT(31 downto 0) <= regs( to_integer(unsigned(i_RS1)));
            o_RS1_DAT(127 downto 32) <=  (others => '0');
        end if;
        if (unsigned(i_RS2) = 15 or unsigned(i_RS2) = 14 or unsigned(i_RS2) = 13 or unsigned(i_RS2) = 12) then
            o_RS2_DAT <= regsV( to_integer(unsigned(i_RS2))-12);
        else
            o_RS2_DAT(31 downto 0) <= regs( to_integer(unsigned(i_RS2)));
            o_RS2_DAT(127 downto 32) <=  (others => '0');
        end if;
    end process;
end comport;
