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
entity proc_tb is
end entity proc_tb;

architecture testbench_1 of reg_tb is
    component datapath is
        port(
            --Common
            clock : in bit;
            reset : in bit;
            -- From Control Unit
            reg2loc : in bit;
            pcsrc : in bit;
            memToReg : in bit;
            aluCtrl : in bit_vector(3 downto 0);
            aluSrc : in bit;
            regWrite : in bit;
            -- To Control Unit
            opcode : out bit_vector(10 downto 0);
            zero : out bit;
            --IM interface
            imAddr : out bit_vector(63 downto 0);
            imOut : in bit_vector(31 downto 0);
            --DM interface
            dmAddr : out bit_vector(63 downto 0);
            dmIn : out bit_vector(63 downto 0);
            dmOut : in bit_vector(63 downto 0)
        );
    end component datapath;

    

    signal clock, reset, reg2loc, pcsrc, memToReg, aluSrc, regWrite, zero : bit;
    signal aluCtrl : bit_vector(3 downto 0);
    signal opcode : bit_vector(10 downto 0);
    signal imOut : bit_vector(31 downto 0);
    signal imAddr, dmAddr, dmIn, dmOut : bit_vector(63 downto 0);
begin
    DATAPATH: datapath port map (
            clock : in bit;
            reset : in bit;
            reg2loc : in bit;
            pcsrc : in bit;
            memToReg : in bit;
            aluCtrl : in bit_vector(3 downto 0);
            aluSrc : in bit;
            regWrite : in bit;
            -- To Control Unit
            opcode : out bit_vector(10 downto 0);
            zero : out bit;
            --IM interface
            imAddr : out bit_vector(63 downto 0);
            imOut : in bit_vector(31 downto 0);
            --DM interface
            dmAddr : out bit_vector(63 downto 0);
            dmIn : out bit_vector(63 downto 0);
            dmOut : in bit_vector(63 downto 0)
    );

    p: process is
        type pattern_type is record
            signal clock, reset, reg2loc, pcsrc, memToReg, aluSrc, regWrite, zero : bit;
            signal aluCtrl : bit_vector(3 downto 0);
            signal opcode : bit_vector(10 downto 0);
            signal imOut : bit_vector(31 downto 0);
            signal imAddr, dmAddr, dmIn, dmOut : bit_vector(63 downto 0);
        end record;

        type pattern_array is array (natural range <>) of pattern_type;
        constant patterns : pattern_array := (

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