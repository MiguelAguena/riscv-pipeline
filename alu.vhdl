-------------------------------------------------------
--! @file EP3A3_signext.vhdl
--! @brief PoliLEG ALU.
--! @author Miguel Aguena (miguel.aguena@usp.br)
--! @date 2022-06-12
-------------------------------------------------------

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