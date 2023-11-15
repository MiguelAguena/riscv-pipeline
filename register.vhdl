-------------------------------------------------------
--! @file EP3A4_reg.vhdl
--! @brief PoliLEG Registers.
--! @author Miguel Aguena (miguel.aguena@usp.br)
--! @date 2022-06-12
-------------------------------------------------------

entity d_latch is
    port(
        D, Clock, Reset : in  bit;
        Q               : out bit
    );
end d_latch;

architecture d_latch_1 of d_latch is
begin
    p0: process (D, Clock) is
    begin
        if(Clock = '1' AND Reset = '0') then
            Q <= D;
        end if;
        if(Reset = '1') then
            Q <= '0';
        end if;
    end process p0;
end architecture d_latch_1;

--Multiplexer 2x1

entity mux_2to1 is
    generic (
        size : natural := 2
    );
    port(
        I   : in bit_vector(size-1 downto 0);
        SEL : in bit;
        Y   : out bit
    );
end entity mux_2to1;

architecture mux_2to1_1 of mux_2to1 is
begin
    Y <= I(0) when SEL = '0' else
         I(1) when SEL = '1' else
         '0';
end architecture mux_2to1_1;

--D-flip-flop

entity d_flipflop is
    port(
        D, Clock, Reset, Enable : in  bit;
        Q                       : out bit
    );
end d_flipflop;

architecture d_flipflop_1 of d_flipflop is
    signal d_aux        : bit;
    signal m_to_s_aux   : bit;
    signal notclock_aux : bit;
    signal q_aux        : bit;
begin
    notclock_aux <= NOT Clock;

    DLM: entity work.d_latch(d_latch_1) port map (
        D => d_aux,
        Clock => notclock_aux,
        Q => m_to_s_aux,
        Reset => Reset
    );

    DLS: entity work.d_latch(d_latch_1) port map (
        D => m_to_s_aux,
        Clock => Clock,
        Q => q_aux,
        Reset => Reset
    );

    MUX: entity work.mux_2to1(mux_2to1_1) port map (
        I(0) => q_aux,
        I(1) => D,
        SEL => Enable,
        Y => d_aux
    );

    Q <= q_aux;
end architecture d_flipflop_1;

--D-Register

library ieee;
use ieee.numeric_bit.to_unsigned;

entity d_register is
    generic(
        width: natural := 4;
        reset_value: natural := 0
    );
    port(
        clock, reset, load : in bit;
        d : in  bit_vector(width-1 downto 0);
        q : out bit_vector(width-1 downto 0)
    );
end d_register;

architecture d_register_1 of d_register is
    signal q_aux : bit_vector(width-1 downto 0);
begin
    FFDS: for i in width - 1 downto 0 generate
        FFD: entity work.d_flipflop(d_flipflop_1) port map (
            D => d(i),
            Clock => clock,
            Reset => reset,
            Enable => load,
            Q => q_aux(i)
        );
    end generate;

    q <= q_aux when reset = '0' else
         bit_vector(to_unsigned(reset_value, width)) when reset = '1' else
         bit_vector(to_unsigned(0, width));
end architecture d_register_1;

library ieee;
use     ieee.math_real.all;
use     ieee.numeric_bit.all;
entity regfile is
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
end regfile;

architecture regfile_1 of regfile is
    type bit_matrix is array (0 to reg_n-1) of bit_vector(word_s-1 downto 0);

    component d_register is
        generic(
            width: natural := 4;
            reset_value: natural := 0
        );
        port(
            clock, reset, load : in bit;
            d : in  bit_vector(width-1 downto 0);
            q : out bit_vector(width-1 downto 0)
        );
    end component d_register;

    signal q_aux : bit_matrix;
    signal wr_aux : bit_vector(reg_n-1 downto 0);
    signal load_aux : bit_vector(reg_n-1 downto 0);
begin
    decode: process (wr, clock) is
    begin
        wr_aux <= bit_vector(to_unsigned(0, reg_n));
        wr_aux(to_integer(unsigned(wr))) <= '1';
    end process decode;

    MUX_RESET: for i in reg_n-1 downto 0 generate
        load_aux(i) <= wr_aux(i) AND regWrite;
    end generate;
    
    REGS: for i in reg_n-1 downto 0 generate
        REG_NONZ: if i < reg_n-1 generate
            REGI: d_register generic map (word_s, 0) port map(
                d => d,
                q => q_aux(i),
                clock => clock,
                reset => reset,
                load => load_aux(i)
            );
        end generate;
        REG_Z: if i = reg_n-1 generate
            REGZ: d_register generic map (word_s, 0) port map(
                d => bit_vector(to_unsigned(0, word_s)),
                q => q_aux(i),
                clock => clock,
                reset => reset,
                load => load_aux(i)
            );
        end generate;
    end generate;

    q1 <= q_aux(to_integer(unsigned(rr1)));
    q2 <= q_aux(to_integer(unsigned(rr2)));
end architecture;