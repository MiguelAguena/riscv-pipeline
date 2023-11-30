library ieee;
use ieee.std_logic_1164.all;

entity riscv_pp is
    port (
        clock : in std_logic;
        reset : in std_logic;

        --- Mem In
        InstrF : in std_logic_vector(31 downto 0);
        ReadDataM : in std_logic_vector(31 downto 0);

        -- Mem Out
        PCF : out std_logic_vector(31 downto 0);
        ALUResultM : out std_logic_vector(31 downto 0);
        WriteDataM : out std_logic_vector(31 downto 0);
        MemWriteM : out std_logic
    );
end entity;

architecture structural of riscv_pp is

    component UC is
        port (
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

    end component;

    component DF is
        port (
            --- Control IN
            reset : in std_logic;
            clock : in std_logic;
            RegWriteD : in std_logic;
            ResultSrcD : in std_logic_vector(1 downto 0);
            MemWriteD : in std_logic;
            JumpD : in std_logic;
            BranchD : in std_logic;
            ALUControlD : in std_logic_vector(2 downto 0);
            ALUSrcD : in std_logic;
            ImmSrcD : in std_logic_vector(1 downto 0);

            --- Mem In
            InstrF : in std_logic_vector(31 downto 0);
            ReadDataM : in std_logic_vector(31 downto 0);

            -- Mem Out
            PCF : out std_logic_vector(31 downto 0);
            ALUResultM : out std_logic_vector(31 downto 0);
            WriteDataM : out std_logic_vector(31 downto 0);
            MemWriteM : out std_logic;

            -- To UC

            opcode : out std_logic_vector(6 downto 0);
            funct3 : out std_logic_vector(2 downto 0);
            funct7 : out std_logic_vector(6 downto 0)
        );
    end component;

    signal RegWriteD : std_logic;
    signal ResultSrcD : std_logic_vector(1 downto 0);
    signal MemWriteD : std_logic;
    signal JumpD : std_logic;
    signal BranchD : std_logic;
    signal ALUControlD : std_logic_vector(2 downto 0);
    signal ALUSrcD : std_logic;
    signal ImmSrcD : std_logic_vector(1 downto 0);
    signal opcode : std_logic_vector(6 downto 0);
    signal funct3 : std_logic_vector(2 downto 0);
    signal funct7 : std_logic_vector(6 downto 0);

begin

    UnidCtrl : UC
    port map(
        RegWriteD => RegWriteD,
        ResultSrcD => ResultSrcD,
        MemWriteD => MemWriteD,
        JumpD => JumpD,
        BranchD => BranchD,
        ALUControlD => ALUControlD,
        ALUSrcD => ALUSrcD,
        ImmSrcD => ImmSrcD,
        opcode => opcode,
        funct3 => funct3,
        funct7 => funct7
    );

    FluxDad : DF
    port map(
        reset => reset,
        clock => clock,
        RegWriteD => RegWriteD,
        ResultSrcD => ResultSrcD,
        MemWriteD => MemWriteD,
        JumpD => JumpD,
        BranchD => BranchD,
        ALUControlD => ALUControlD,
        ALUSrcD => ALUSrcD,
        ImmSrcD => ImmSrcD,
        InstrF => InstrF,
        ReadDataM => ReadDataM,
        PCF => PCF,
        ALUResultM => ALUResultM,
        WriteDataM => WriteDataM,
        MemWriteM => MemWriteM,
        opcode => opcode,
        funct3 => funct3,
        funct7 => funct7
    );

end structural; -- structural