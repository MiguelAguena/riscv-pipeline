library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signExtend is
    port (
        i : in std_logic_vector(24 downto 0);
        imm_src : in std_logic_vector(1 downto 0);
        o : out std_logic_vector(31 downto 0)
    );
end signExtend;

architecture signExtend_1 of signExtend is
begin
    o <= (31 downto 12 => i(24)) & i(24 downto 13) when imm_src = "00" else
         (31 downto 12 => i(24)) & i(24 downto 18) & i(4 downto 0) when imm_src = "01" else
         (31 downto 12 => i(24)) & i(0) & i(23 downto 18) & i(4 downto 1) & '0' when imm_src = "10" else
         (31 downto 20 => i(24)) & i(12 downto 5) & i(13) & i(23 downto 14) & '0';
end architecture;