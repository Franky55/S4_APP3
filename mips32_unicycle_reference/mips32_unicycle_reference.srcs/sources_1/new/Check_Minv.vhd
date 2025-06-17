----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/17/2025 04:10:08 PM
-- Design Name: 
-- Module Name: Check_Minv - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MIPS32_package.all;

entity Check_Minv is
    Port ( i_vecA : in STD_LOGIC_VECTOR (127 downto 0);
           o_val_min : out STD_LOGIC_VECTOR (31 downto 0));
end Check_Minv;

architecture Behavioral of Check_Minv is

signal s_vecA_1 : std_logic_vector(31 downto 0) := i_vecA(31 downto 0);
signal s_vecA_2 : std_logic_vector(31 downto 0) := i_vecA(63 downto 32);
signal s_vecA_3 : std_logic_vector(31 downto 0) := i_vecA(95 downto 64);
signal s_vecA_4 : std_logic_vector(31 downto 0) := i_vecA(127 downto 96);
signal s_min     : std_logic_vector(31 downto 0);

begin
    s_vecA_1 <= i_vecA(31 downto 0);
    s_vecA_2 <= i_vecA(63 downto 32);
    s_vecA_3 <= i_vecA(95 downto 64);
    s_vecA_4 <= i_vecA(127 downto 96);

    process(s_vecA_1, s_vecA_2, s_vecA_3, s_vecA_4)
        variable v1, v2, v3, v4 : unsigned(31 downto 0);
        variable v_min : unsigned(31 downto 0);
    begin
        v1 := unsigned(s_vecA_1);
        v2 := unsigned(s_vecA_2);
        v3 := unsigned(s_vecA_3);
        v4 := unsigned(s_vecA_4);

        v_min := v1;
        if v2 < v_min then
            v_min := v2;
        end if;
        if v3 < v_min then
            v_min := v3;
        end if;
        if v4 < v_min then
            v_min := v4;
        end if;

        s_min <= std_logic_vector(v_min);
    end process;

    o_val_min <= s_min;

end Behavioral;
