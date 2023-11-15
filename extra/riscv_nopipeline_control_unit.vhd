library ieee;
use ieee.numeric_std.all;

entity riscv_nopipeline_control_unit is
    port(
        --To Datapath
        resultSrc : out std_logic_vector(1 downto 0);
        pcSrc : out std_logic;
        immSrc : out std_logic_vector(1 downto 0);
        aluControl : out std_logic_vector(2 downto 0);
        memWrite : out std_logic;
        aluSrc : out std_logic;
        regWrite : out std_logic;
        
        --From Datapath
        zero   : in std_logic;
        opcode : in std_logic_vector(6 downto 0);
        funct3 : in std_logic_vector(2 downto 0);
        funct7 : in std_logic
    );

end riscv_nopipeline_control_unit;

architecture controlunit_1 of riscv_nopipeline_control_unit is
    signal aluOp : std_logic_vector(1 downto 0);
    signal branch, jump : std_logic;
    
    component maindec
        port(
            op: in std_logic_vector(6 downto 0);
            ResultSrc: out std_logic_vector(1 downto 0);
            MemWrite: out std_logic;
            Branch, ALUSrc: out std_logic;
            RegWrite, Jump: out std_logic;
            ImmSrc: out std_logic_vector(1 downto 0);
            ALUOp: out std_logic_vector(1 downto 0)
        );
    end component;

    component aludec
        port(
            opb5: in std_logic;
            funct3: in std_logic_vector(2 downto 0);
            funct7b5: in std_logic;
            ALUOp: in std_logic_vector(1 downto 0);
            ALUControl: out std_logic_vector(2 downto 0)
        );
    end component;
begin
    maindeci: maindec 
        port map(
            op => opcode,
            ResultSrc => resultSrc,
            MemWrite => memWrite,
            Branch => branch,
            ALUSrc => aluSrc,
            RegWrite => regWrite,
            Jump => jump,
            ImmSrc => immSrc,
            ALUOp => aluOp
        );
    ad: aludec port map(opcode(5), funct3, funct7, ALUOp, ALUControl);
    pcSrc <= jump or (branch and zero);
end architecture;