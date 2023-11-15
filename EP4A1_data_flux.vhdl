-------------------------------------------------------
--! @file EP4A1_data_flux.vhdl
--! @brief PoliLEG data flux.
--! @author Miguel Aguena (miguel.aguena@usp.br)
--! @date 2022-06-19
-------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

entity shiftleft2 is
    generic(
        ws: natural := 64
    );
    port(
        i: in  bit_vector(ws-1 downto 0);
        o: out bit_vector(ws-1 downto 0)
    );
end shiftleft2;

architecture shiftleft2_1 of shiftleft2 is
begin
    o <= bit_vector(to_unsigned(to_integer(unsigned(i(ws-1 downto 0) & "00")), ws));
end architecture;

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

entity full_adder is
    port(
        A, B, Ci  : in bit;
        Co, S     : out bit
    );
end entity full_adder;

architecture full_adder_1 of full_adder is
begin
    S <= ((A XOR B) XOR Ci);
    Co <= (A AND B) OR (A AND Ci) OR (B AND Ci);
end architecture full_adder_1;

entity alu_1_bit is
    port (
        A, B       : in  bit;
        F          : out bit;
        NOTA, NOTB : in  bit;
        LESS       : in  bit;
        SET        : out bit;
        Ci         : in  bit;
        Ov         : out bit;
        Co         : out bit;
        Op         : in  bit_vector(1 downto 0)
    );
end alu_1_bit;

architecture alu_1_bit_1 of alu_1_bit is
    component full_adder is
        port(
            A, B, Ci  : in bit;
            Co, S     : out bit
        );
    end component full_adder;

    signal a_aux, b_aux : bit;
    signal and_aux : bit;
    signal or_aux : bit;
    signal adder_aux : bit;
    signal result_aux : bit;
begin
    a_aux <= A when NOTA = '0' else
       (NOT A) when NOTA = '1' else
       '0';

    b_aux <= B when NOTB = '0' else
       (NOT B) when NOTB = '1' else
       '0';

    and_aux <= a_aux AND b_aux;
    or_aux <= a_aux OR b_aux;

    FA: full_adder port map(
        A => a_aux,
        B => b_aux,
        S => adder_aux,
        Ci => Ci,
        Co => Co
    );

    result_aux <= and_aux when Op = "00" else
         or_aux when Op = "01" else
         adder_aux when Op = "10" else
         LESS when Op = "11" else
         '0';

    SET <= adder_aux;

    Ov <= (NOT(adder_aux) AND a_aux AND b_aux) OR (adder_aux AND NOT(a_aux) AND NOT(b_aux));
    
    F <= result_aux;
end architecture;

entity my_or is
    port(
        A : in bit;
        B : in bit;
        Y : out bit
    );
end entity my_or;

architecture my_or_1 of my_or is
begin
    Y <= A OR B;
end architecture my_or_1;

entity alu is
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
end alu;

architecture alu_1 of alu is
    component alu_1_bit is
        port (
            A, B       : in  bit;
            F          : out bit;
            NOTA, NOTB : in  bit;
            LESS       : in  bit;
            SET        : out bit;
            Ci         : in  bit;
            Ov         : out bit;
            Co         : out bit;
            Op         : in  bit_vector(1 downto 0)
        );
    end component alu_1_bit;

    component my_or is
        port(
            A : in bit;
            B : in bit;
            Y   : out bit
        );
    end component my_or;

    signal not_a_aux : bit;
    signal not_b_aux : bit;
    signal less : bit;
    signal less_aux : bit;
    signal result_aux : bit_vector(size-1 downto 0);
    signal op_aux : bit_vector(1 downto 0);
    signal ov_aux : bit;
    signal co_aux : bit_vector(size-1 downto 0);
    signal my_or_aux : bit_vector(size-2 downto 0);
begin
    op_aux <= S(1 downto 0);     

    not_b_aux <= '0' when S(2) = '0' else
                 '1' when S(2) = '1' else
                 '0';

    not_a_aux <= '0' when S(3) = '0' else
                 '1' when S(3) = '1' else
                 '0';

    ALUS: for i in size-1 downto 0 generate
        LAST: if i = size-1 generate
            ALU_LAST: alu_1_bit port map (
                A => A(i),
                B => B(i),
                F => result_aux(i),
                NOTA => not_a_aux,
                NOTB => not_b_aux,
                LESS => '0',
                SET => less,
                Ci => co_aux(i - 1),
                Co => co_aux(i),
                Op => op_aux,
                Ov => ov_aux
            );
        end generate;

        MID: if (i /= size-1) AND (i /= 0) generate
            ALU_I: alu_1_bit port map (
                A => A(i),
                B => B(i),
                F => result_aux(i),
                NOTA => not_a_aux,
                NOTB => not_b_aux,
                LESS => '0',
                Ci => co_aux(i - 1),
                Co => co_aux(i),
                Op => op_aux
            );
        end generate;

        FIRST: if i = 0 generate
            ALU_FIRST: alu_1_bit port map (
                A => A(i),
                B => B(i),
                F => result_aux(i),
                NOTA => not_a_aux,
                NOTB => not_b_aux,
                LESS => less_aux,
                Ci => not_b_aux,
                Co => co_aux(i),
                Op => op_aux
            );
        end generate;
    end generate;

    N_WAY_OR: for i in size - 1 downto 0 generate
        MY_OR0: if i = 0 generate
            MY_OR_FIRST: my_or port map (
                A => result_aux(i),
                B => result_aux(i + 1),
                Y => my_or_aux(i)
            );
        end generate;

        MY_ORI: if i > 1 generate
            MY_OR_LAST: my_or port map (
                A => my_or_aux(i - 2),
                B => result_aux(i),
                Y => my_or_aux(i - 1)
            );
        end generate;
    end generate N_WAY_OR;

    Ov <= ov_aux;

    less_aux <= (NOT(A(size-1) XOR B(size-1)) AND less) OR (A(size-1) AND NOT(B(size-1)));

    Z <= NOT my_or_aux(size-2);
    Co <= co_aux(size-1);
    F <= result_aux;
end architecture;

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

library ieee;
use     ieee.math_real.all;
use     ieee.numeric_bit.all;
entity datapath is
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
end entity datapath;

architecture datapath_1 of datapath is
    component shiftleft2 is
        generic(
            ws: natural := 64
        );
        port(
            i: in  bit_vector(ws-1 downto 0);
            o: out bit_vector(ws-1 downto 0)
        );
    end component shiftleft2;

    component signExtend is
        port(
            i: in  bit_vector(31 downto 0);
            o: out bit_vector(63 downto 0)
        );
    end component signExtend;

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

    signal pc_in : bit_vector(63 downto 0);
    signal pc_load : bit;
    signal pc_out : bit_vector(63 downto 0);

    signal number_4_aux : bit_vector(63 downto 0) := bit_vector(to_unsigned(4, 64));
    signal adder_4_out : bit_vector(63 downto 0);
    signal add_op : bit_vector(3 downto 0) := "0010";

    signal reg_rr1 : bit_vector(4 downto 0);
    signal reg_rr2 : bit_vector(4 downto 0);
    signal reg_wr : bit_vector(4 downto 0);
    signal reg_in : bit_vector(63 downto 0);
    signal reg_load : bit;
    signal reg_out1 : bit_vector(63 downto 0);
    signal reg_out2 : bit_vector(63 downto 0);

    signal between_signext_sl2 : bit_vector(63 downto 0);
    signal sl2_out : bit_vector(63 downto 0);

    signal adder_pc_out: bit_vector(63 downto 0);

    signal alu_b_in : bit_vector(63 downto 0);
    signal alu_out : bit_vector(63 downto 0);
begin
    pc_load <= '1';
    
    PC: d_register generic map(64, 0) port map(
        clock => clock,
        reset => reset,
        load => pc_load,
        d => pc_in,
        q => pc_out
    );

    ADDER_4: alu generic map(64) port map(
        A => pc_out,
        B => number_4_aux,
        F => adder_4_out,
        S => add_op
    );

    imAddr <= pc_out;

    opcode <= imOut(31 downto 21);

    REG_BANK: regfile generic map(32, 64) port map(
        clock => clock,
        reset => reset,
        regWrite => reg_load,
        rr1 => reg_rr1,
        rr2 => reg_rr2,
        wr => reg_wr,
        d => reg_in,
        q1 => reg_out1,
        q2 => reg_out2
    );

    reg_load <= regWrite;
    
    reg_rr1 <= imOut(9 downto 5);
    reg_rr2 <= imOut(20 downto 16) when reg2loc = '0' else
               imOut(4 downto 0) when reg2loc = '1' else
               bit_vector(to_unsigned(0, 64));

    reg_wr <= imOut(4 downto 0);

    SIGNEXT: signExtend port map(
        i => imOut,
        o => between_signext_sl2
    );

    SLL2: shiftleft2 generic map(64) port map(
        i => between_signext_sl2,
        o => sl2_out
    );

    ADDER_PC: alu generic map(64) port map(
        A => pc_out,
        B => sl2_out,
        F => adder_pc_out,
        S => add_op
    );

    pc_in <= adder_4_out when pcsrc = '0' else
             adder_pc_out when pcsrc = '1' else
             bit_vector(to_unsigned(0, 64));

    ALU_MAIN: alu generic map(64) port map(
        A => reg_out1,
        B => alu_b_in,
        F => alu_out,
        S => aluCtrl,
        Z => zero
    );

    alu_b_in <= reg_out2 when aluSrc = '0' else
                between_signext_sl2 when aluSrc = '1' else
                bit_vector(to_unsigned(0, 64));

    dmAddr <= alu_out;
    dmIn <= reg_out2;
    
    reg_in <= alu_out when memToReg = '0' else
              dmOut when memToReg = '1' else
              bit_vector(to_unsigned(0, 64));
end architecture;