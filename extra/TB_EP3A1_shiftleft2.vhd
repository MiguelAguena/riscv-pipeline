------------------------------------------------------
--! @file ALU.vhdl
--! @brief Testbench for my very own ALU!
--! @author Miguel Aguena (miguel.aguena@usp.br)
--! @date 2021-11-08
-------------------------------------------------------

entity shiftleft2_tb is
    generic(
        ws : natural := 8
    );
    
end entity shiftleft2_tb;

architecture testbench_1 of shiftleft2_tb is
    component shiftleft2 is
        generic(
            ws: natural := ws
        );
        port(
            i: in  bit_vector(ws-1 downto 0);
            o: out bit_vector(ws-1 downto 0)
        );
    end component shiftleft2;

    signal INP, OUTP : bit_vector(ws-1 downto 0);
begin
    SL: entity work.shiftleft2(shiftleft2_1) generic map (8) port map (
        i => INP,
        o => OUTP
    );

    process_000_111: process is
        type pattern_type is record
            i : bit_vector (ws-1 downto 0);
            o : bit_vector (ws-1 downto 0);
        end record;

        type pattern_array is array (natural range <>) of pattern_type;
        constant patterns : pattern_array := (
            ("00001111", "00111100"),
            ("10101010", "10101000")
        );
    begin
        for k in patterns'range loop
            INP <= patterns(k).i;

            wait for 1 ns;

            assert OUTP = patterns(k).o
                report "bad o" severity error;
        end loop;

        assert false report "end of test" severity note;
        wait;
    end process;
end architecture testbench_1;