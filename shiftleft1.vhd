-------------------------------------------------------
--! @file EP3A1_shiftleft2.vhdl
--! @brief PoliLEG Shift Left 2 bits.
--! @author Miguel Aguena (miguel.aguena@usp.br)
--! @date 2022-06-12
-------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

entity shiftleft1 is
    generic(
        ws: natural := 64
    );
    port(
        i: in  bit_vector(ws-1 downto 0);
        o: out bit_vector(ws-1 downto 0)
    );
end shiftleft1;

architecture shiftleft1_1 of shiftleft1 is
begin
    GEN: for a in ws-1 downto 0 generate
        GEN_MAIN: if a >= 1 generate
            o(a) <= i(a - 1);
        end generate;
        GEN_LAST: if a < 1 generate
            o(a) <= '0';
        end generate;
    end generate;
end architecture;