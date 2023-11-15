------------------------------------------------------
--! @file ALU.vhdl
--! @brief Testbench for my very own ALU!
--! @author Miguel Aguena (miguel.aguena@usp.br)
--! @date 2021-11-08
-------------------------------------------------------

entity alu_tb is
end entity alu_tb;

architecture testbench_1 of alu_tb is
    component alu is
        generic (
            size : natural := 64
        );
    
        port (
            A, B : in  bit_vector(size-1 downto 0);
            F    : out bit_vector(size-1 downto 0);
            S    : in  bit_vector(3 downto 0);
            Z    : out bit;
            Ov   : out bit;
            Co   : out bit
        );
    end component alu;

    signal A, B, F : bit_vector(3 downto 0);
    signal S : bit_vector(3 downto 0);
    signal Z, Ov, Co : bit;
begin
    MY_ALU: alu generic map (4) port map (
        A => A,
        B => B,
        F => F,
        S => S,
        Z => Z,
        Ov => Ov,
        Co => Co
    );

    p: process is
        type pattern_type is record
            a, b, s, f : bit_vector(3 downto 0);
            z, ov, co : bit;
        end record;

        type pattern_array is array (natural range <>) of pattern_type;
        constant patterns : pattern_array := (
            ("0111", "0001", "0010", "1000", '0', '1', '0'),
            ("1001", "0110", "1100", "0000", '1', '0', '1')
        );
    begin
        for k in patterns'range loop
            A <= patterns(k).a;
            B <= patterns(k).b;
            S <= patterns(k).s;

            wait for 1 ns;

            assert F = patterns(k).f
                report "bad f" severity error;
            assert Z = patterns(k).z
                report "bad z" severity error;
            assert Ov = patterns(k).ov
                report "bad ov" severity error;
            assert Co = patterns(k).co
                report "bad co" severity error;
        end loop;

        assert false report "end of test" severity note;
        wait;
    end process;
end architecture testbench_1;