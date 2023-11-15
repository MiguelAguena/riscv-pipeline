------------------------------------------------------
--! @file ALU.vhdl
--! @brief Testbench for my very own ALU!
--! @author Miguel Aguena (miguel.aguena@usp.br)
--! @date 2021-11-08
-------------------------------------------------------

entity signExtend_tb is
end signExtend_tb;

architecture testbench_1 of signExtend_tb is
    component signExtend is
        port(
            i: in  bit_vector(31 downto 0);
            o: out bit_vector(63 downto 0)
        );
    end component signExtend;

    signal INSE : bit_vector(31 downto 0);
    signal OUTSE : bit_vector(63 downto 0);
begin
    SL: signExtend port map (
        i => INSE,
        o => OUTSE
    );

    p: process is
        type pattern_type is record
            i : bit_vector (31 downto 0);
            o : bit_vector (63 downto 0);
        end record;

        type pattern_array is array (natural range <>) of pattern_type;
        constant patterns : pattern_array := (
            ("11111000010011011011000000000000", "0000000000000000000000000000000000000000000000000000000011011011"),
            ("11111000000100100100000000000000", "1111111111111111111111111111111111111111111111111111111100100100"),
            ("10110100010101010101010101000000", "0000000000000000000000000000000000000000000000101010101010101010"),
            ("10110100101010101010101010100000", "1111111111111111111111111111111111111111111111010101010101010101"),
            ("00010101111111111111111111111111", "0000000000000000000000000000000000000001111111111111111111111111"),
            ("00010110000000000000000000000000", "1111111111111111111111111111111111111110000000000000000000000000")
        );
    begin
        for k in patterns'range loop
            INSE <= patterns(k).i;

            wait for 1 ns;

            assert OUTSE = patterns(k).o
                report "bad o" severity error;
        end loop;

        assert false report "end of test" severity note;
        wait;
    end process;
end architecture testbench_1;