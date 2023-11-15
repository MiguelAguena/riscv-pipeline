------------------------------------------------------
--! @file ALU.vhdl
--! @brief Testbench for my very own ALU!
--! @author Miguel Aguena (miguel.aguena@usp.br)
--! @date 2021-11-08
-------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.math_real.all;
use     ieee.numeric_bit.all;
entity reg_tb is
end entity reg_tb;

architecture testbench_1 of reg_tb is
    component regfile is
        generic (
            reg_n: natural := 10;
            word_s: natural := 64
        );
    
        port (
            clock:        in  bit;
            reset:        in  bit;
            regWrite:     in  bit;
            rr1, rr2, wr: in  bit_vector(natural(ceil(log2(real(reg_n)))) -1 downto 0);
            d:            in  bit_vector(word_s-1 downto 0);
            q1, q2:       out bit_vector(word_s-1 downto 0)
        );
    end component regfile;

    signal rr1, rr2, wr : bit_vector(natural(ceil(log2(real(10)))) -1 downto 0);
    signal d, q1, q2 : bit_vector(3 downto 0);
    signal clock, reset, regWrite : bit;
begin
    MY_REG: regfile generic map (10, 4) port map (
        clock => clock,
        reset => reset,
        regWrite => regWrite,
        rr1 => rr1,
        rr2 => rr2,
        wr => wr,
        d => d,
        q1 => q1,
        q2 => q2
    );

    p: process is
        type pattern_type is record
            clock, reset, regWrite : bit;
            rr1, rr2, wr : bit_vector(natural(ceil(log2(real(10)))) -1 downto 0);
            d, q1, q2 : bit_vector(3 downto 0);
        end record;

        type pattern_array is array (natural range <>) of pattern_type;
        constant patterns : pattern_array := (
            ('0', '0', '0', "0000", "0000", "0000", "0000", "0000", "0000"),
            ('1', '0', '1', "0001", "0000", "0001", "1010", "0000", "0000"),
            ('0', '0', '1', "0001", "0000", "0001", "1010", "0000", "0000"),
            ('1', '0', '1', "0001", "0000", "0001", "1010", "1010", "0000"),
            ('0', '0', '1', "0001", "0010", "0010", "1111", "1010", "0000"),
            ('1', '0', '1', "0001", "0010", "0010", "1111", "1010", "1111"),
            ('0', '0', '0', "0001", "0010", "0010", "0000", "1010", "1111"),
            ('1', '0', '0', "0010", "0001", "0010", "0000", "1111", "1010"),
            ('0', '0', '0', "0001", "0010", "0010", "0000", "1010", "1111"),
            ('1', '0', '0', "0010", "0001", "0010", "0000", "1111", "1010"),
            ('0', '0', '1', "0010", "0001", "0001", "0101", "1111", "1010"),
            ('1', '0', '1', "0010", "0001", "0001", "0101", "1111", "0101"),
            ('0', '0', '0', "0010", "0001", "0001", "1010", "1111", "0101"),
            ('1', '1', '0', "0010", "0001", "0001", "1010", "0000", "0000"),
            ('0', '0', '1', "0000", "0000", "1001", "1111", "0000", "0000"),
            ('1', '0', '1', "0000", "0000", "1001", "1111", "0000", "0000"),
            ('0', '0', '1', "0000", "0000", "1001", "1010", "0000", "0000"),
            ('1', '0', '1', "0000", "0000", "1001", "1010", "0000", "0000")
        );
    begin
        for k in patterns'range loop
            clock <= patterns(k).clock;
            reset <= patterns(k).reset;
            regWrite <= patterns(k).regWrite;
            rr1 <= patterns(k).rr1;
            rr2 <= patterns(k).rr2;
            wr <= patterns(k).wr;
            d <= patterns(k).d;

            wait for 1 ns;

            assert q1 = patterns(k).q1
                report "bad q1" severity error;
            assert q2 = patterns(k).q2
                report "bad q2" severity error;
        end loop;

        assert false report "end of test" severity note;
        wait;
    end process;
end architecture testbench_1;