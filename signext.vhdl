-------------------------------------------------------
--! @file EP3A2_signext.vhdl
--! @brief PoliLEG Sign Extend.
--! @author Miguel Aguena (miguel.aguena@usp.br)
--! @date 2022-06-12
-------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

entity signExtend is
    port(
        i: in  bit_vector(31 downto 0);
        o: out bit_vector(63 downto 0)
    );
end signExtend;

architecture signExtend_1 of signExtend is
    signal selector: bit_vector(1 downto 0);
    signal aux_1: bit_vector(63 downto 0);
    signal aux_0: bit_vector(63 downto 0);
    signal d_aux: bit_vector(63 downto 0);
    signal b_aux: bit_vector(63 downto 0);
    signal cbz_aux: bit_vector(63 downto 0);
begin
    selector <= "00" when (i(31) AND i(30) AND i(29) AND i(28) AND i(27)) = '1' else
                "01" when (NOT(i(31)) AND NOT(i(30)) AND NOT(i(29)) AND i(28) AND NOT(i(27)) AND i(26)) = '1' else
                "10" when (i(31) AND NOT(i(30)) AND i(29) AND i(28) AND NOT(i(27)) AND i(26)) = '1' else
                "00";

    SIGN_1: for a in 63 downto 0 generate
        aux_1(a) <= '1';
    end generate;
    SIGN_0: for a in 63 downto 0 generate
        aux_0(a) <= '0';
    end generate;

    D_MUX_SIGN: for a in 63 downto 0 generate
        D_EXTEND: if a > 8 generate
            d_aux(a) <= aux_1(a) when i(20) = '1' else
                    aux_0(a) when i(20) = '0' else
            '0';
        end generate;
        D_IMM: if a <= 8 generate
            d_aux(a) <= i(12 + a);
        end generate;
    end generate;

    B_MUX_SIGN: for a in 63 downto 0 generate
        B_EXTEND: if a > 25 generate
            b_aux(a) <= aux_1(a) when i(25) = '1' else
                    aux_0(a) when i(25) = '0' else
            '0';
        end generate;
        B_IMM: if a <= 25 generate
            b_aux(a) <= i(a);
        end generate;
    end generate;

    CB_MUX_SIGN: for a in 63 downto 0 generate
        CB_EXTEND: if a > 18 generate
            cbz_aux(a) <= aux_1(a) when i(23) = '1' else
                    aux_0(a) when i(23) = '0' else
            '0';
        end generate;
        CB_IMM: if a <= 18 generate
            cbz_aux(a) <= i(5 + a);
        end generate;
    end generate;

    o <= d_aux when selector = "00" else
         b_aux when selector = "01" else
         cbz_aux when selector = "10" else
         bit_vector(to_unsigned(0, 64));
end architecture;