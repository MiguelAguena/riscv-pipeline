library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity UC is
    port(
        --To Datapath
        RegWriteD : out std_logic;
        ResultSrcD : out std_logic_vector(1 downto 0);
        MemWriteD : out std_logic;
        JumpD : out std_logic;
        BranchD : out std_logic;
        ALUControlD : out std_logic_vector(2 downto 0);
        ALUSrcD : out std_logic;
        ImmSrcD : out std_logic_vector(1 downto 0);
        
        --From Datapath
        opcode : in std_logic_vector(6 downto 0);
        funct3 : in std_logic_vector(2 downto 0);
        funct7 : in std_logic_vector(6 downto 0)
    );

end UC;

architecture controlunit_1 of UC is
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
            ResultSrc => ResultSrcD,
            MemWrite => MemWriteD,
            Branch => BranchD,
            ALUSrc => ALUSrcD,
            RegWrite => RegWriteD,
            Jump => JumpD,
            ImmSrc => ImmSrcD,
            ALUOp => aluOp
        );
    ad: aludec port map(opcode(5), funct3, funct7(5), ALUOp, ALUControlD);
end architecture;