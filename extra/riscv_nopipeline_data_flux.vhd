library ieee;
use     ieee.math_real.all;
use     ieee.numeric_std.all;
use     ieee.numeric_std_1164.all;

entity riscv_nopipeline_data_flux is
    port(
        --Common
        clock : in std_logic;
        reset : in std_logic;
        -- From Control 
        immSrc : in std_logic_vector(1 downto 0);
        resultSrc : in std_logic;
        pcSrc : in std_logic;
        aluCtrl : in std_logic_vector(2 downto 0);
        aluSrc : in std_logic;
        regWrite : in std_logic;
        -- To Control Unit
        opcode : out std_logic_vector(6 downto 0);
        zero : out std_logic;
        --IM interface
        imAddr : out std_logic_vector(31 downto 0); -- Saída do PC
        imOut : in std_logic_vector(31 downto 0); 
        --DM interface
        dmAddr : out std_logic_vector(31 downto 0);
        writeData : out std_logic_vector(31 downto 0);
        readData : in std_logic_vector(31 downto 0)
    );
end entity riscv_nopipeline_data_flux;

architecture datapath_1 of riscv_nopipeline_data_flux is
    component signExtend is
        port(
            i: in  std_logic_vector(24 downto 0);
            imm_src: in std_logic_vector(1 downto 0);
            o: out std_logic_vector(31 downto 0)
        );
    end component signExtend;

    component alu is
        generic (
            size : natural := 64
        );
    
        port (
            A, B : in  std_logic_vector(size-1 downto 0);
            F    : out std_logic_vector(size-1 downto 0);
            S    : in  std_logic_vector(3 downto 0);
            Z    : out std_logic;
            Ov   : out std_logic;
            Co   : out std_logic
        );
    end component alu;

    component register_d is
        generic (
            constant N: integer := 8 
        );
        port (
            clock  : in  std_logic;
            clear  : in  std_logic;
            enable : in  std_logic;
            D      : in  std_logic_vector (N-1 downto 0);
            Q      : out std_logic_vector (N-1 downto 0) 
        );
    end component register_d;

    component regfile is
        generic (
            reg_n: natural := 10;
            word_s: natural := 32
        );
    
        port (
            clock:        in  std_logic;
            reset:        in  std_logic;
            regWrite:     in  std_logic;
            rr1, rr2, wr: in  std_logic_vector(natural(ceil(log2(real(reg_n)))) -1 downto 0);
            d:            in  std_logic_vector(word_s-1 downto 0);
            q1, q2:       out std_logic_vector(word_s-1 downto 0)
        );
    end component regfile;

    signal pc_in : std_logic_vector(31 downto 0);
    signal pc_load : std_logic;
    signal pc_out : std_logic_vector(31 downto 0);

    signal number_4_aux : std_logic_vector(31 downto 0) := (2 => '1', others => '0');
    signal adder_4_out : std_logic_vector(31 downto 0);
    signal add_op : std_logic_vector(3 downto 0) := "0010"; ---VERIFICAR SE OS OPS VÃO MUDAR

    signal reg_rr1 : std_logic_vector(4 downto 0);
    signal reg_rr2 : std_logic_vector(4 downto 0);
    signal reg_wr : std_logic_vector(4 downto 0);
    signal reg_in : std_logic_vector(31 downto 0);
    signal reg_load : std_logic;
    signal reg_out1 : std_logic_vector(31 downto 0);
    signal reg_out2 : std_logic_vector(31 downto 0);

    signal between_signext_sl2 : std_logic_vector(31 downto 0);
    signal sl2_out : std_logic_vector(31 downto 0);

    signal adder_pc_out: std_logic_vector(31 downto 0);

    signal alu_b_in : std_logic_vector(31 downto 0);
    signal alu_out : std_logic_vector(31 downto 0);
begin
    pc_load <= '1';
    
    PC: register_d generic map(32, 0) port map(
        clock => clock,
        reset => reset,
        load => pc_load,
        d => pc_in,
        q => pc_out
    );

    ADDER_4: alu generic map(31) port map(
        A => pc_out,
        B => number_4_aux,
        F => adder_4_out,
        S => add_op
    );

    imAddr <= pc_out;

    opcode <= imOut(6 downto 0);

    REG_BANK: regfile generic map(32, 32) port map(
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
    
    reg_rr1 <= imOut(19 downto 15);
    reg_rr2 <= imOut(24 downto 20);
    reg_wr <= imOut(11 downto 7);

    SIGNEXT: signExtend port map( ---CORRIGIR
        i => imOut,
        imm_src => immSrc,
        o => sl2_out
    );

    ADDER_PC_TARGET: alu generic map(32) port map(
        A => pc_out,
        B => sl2_out,
        F => adder_pc_out,
        S => add_op
    );

    pc_in <= adder_4_out when pcsrc = '0' else
             adder_pc_out when pcsrc = '1' else
             (others => '0');

    ALU_MAIN: alu generic map(32) port map(
        A => reg_out1,
        B => alu_b_in,
        F => alu_out,
        S => aluCtrl,
        Z => zero
    );

    alu_b_in <= reg_out2 when aluSrc = '0' else
                sl2_out when aluSrc = '1' else
                (others => '0');

    dmAddr <= alu_out;
    writeData <= reg_out2;
    
    reg_in <= alu_out when resultSrc = '0' else
               readData when resultSrc = '1' else
              (others => '0');
end architecture;