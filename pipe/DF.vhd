library ieee;
use ieee.std_logic_1164.all;

entity DF is
    port(
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
            MemWriteM : out std_logic
        );
end entity;

architecture structural of DF is

    component DF_IF is
        port (
            Clock : in std_logic;
            Reset : in std_logic;
            PCTargetE : in std_logic_vector(31 downto 0);
            PCSrcE : in std_logic;
            StallIF : in std_logic;
            
            PCF : out std_logic_vector(31 downto 0);
            PCPlus4 : out std_logic_vector(31 downto 0)
          );
    end component;

    component DF_ID is
        port (
            Clock : in std_logic;
            Reset : in std_logic;
            InstrD : in std_logic_vector(31 downto 0);
            RegWriteW : in std_logic;
            ResultW : in std_logic_vector(31 downto 0);
            RdW : in std_logic_vector(4 downto 0);
            
            -- Entradas de Controle
            ImmSrcD : in std_logic_vector(1 downto 0);
            -- Saídas de fluxo
            RdD, RS1D, RS2D: out std_logic_vector(4 downto 0);
            RD1D, RD2D, ImmExtD: out std_logic_vector(31 downto 0)
        );
    end component;

    component DF_EX is
        port (
            Clock : in std_logic;
            Reset : in std_logic;
        --- Entradas
            RD1E : in std_logic_vector(31 downto 0);
            RD2E : in std_logic_vector(31 downto 0);
            PCE : in std_logic_vector(31 downto 0);
            ImmExtE : in std_logic_vector(31 downto 0);
            AluResultM : in std_logic_vector(31 downto 0);
            ResultW : in std_logic_vector(31 downto 0);
            ALUControlE : in std_logic_vector(2 downto 0);
            ALUsrcE : in std_logic;
            FowardAE : in std_logic_vector(1 downto 0);
            FowardBE : in std_logic_vector(1 downto 0);
        --- Saídas
            PCTargetE : out std_logic_vector(31 downto 0);
            WriteDataE : out std_logic_vector(31 downto 0);
            AluResultE : out std_logic_vector(31 downto 0);
            zeroE : out std_logic
      );
    end component;

    component DF_WB is
        port (
            -- Entradas
            ReadDataW : in std_logic_vector(31 downto 0);
            PCPlus4W  : in std_logic_vector(31 downto 0);
            AluResultW : in std_logic_vector(31 downto 0);
            ResultSrcW : in std_logic_vector(1 downto 0);
            -- Saídas
            ResultW : out std_logic_vector(31 downto 0)
          );
    end component;

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
    end component;

    component HAZARD_UNIT is
        port(
        -- Entradas
        Rs1D   : in std_logic_vector(4 downto 0);
        Rs2D   : in std_logic_vector(4 downto 0);
        RdE    : in std_logic_vector(4 downto 0);
        Rs2E   : in std_logic_vector(4 downto 0);
        Rs1E   : in std_logic_vector(4 downto 0);
        PCScrE : in std_logic;
        ResultSrcE_0 : in std_logic;
        RdM    : in std_logic_vector(4 downto 0);
        RegWriteM : in std_logic;
        RdW    : in std_logic_vector(4 downto 0);
        RegWriteW : in std_logic;
        -- Saidas
        StallF : out std_logic;
        StallD : out std_logic;
        FlushD : out std_logic;
        FlushE : out std_logic;
        ForwardAE : out std_logic_vector(1 downto 0);
        ForwardBE : out std_logic_vector(1 downto 0)
        );
    end component;

    signal PCTargetE : std_logic_vector(31 downto 0);
    signal PCSrcE : std_logic;
    signal StallF, FlushD, StallD, FlushE   : std_logic;
    signal PCPlus4F  : std_logic_vector(31 downto 0);

 
    signal InstrD : std_logic_vector(31 downto 0);
    signal ResultW : std_logic_vector(31 downto 0);
    signal RdW, RdE, RdM, RS1E, RS2E : std_logic_vector(4 downto 0);
    signal RD1D : std_logic_vector(31 downto 0);
    signal RD2D : std_logic_vector(31 downto 0);
    signal RdD : std_logic_vector(4 downto 0);
    signal RS1D : std_logic_vector(4 downto 0);
    signal RS2D : std_logic_vector(4 downto 0);
    signal ImmExtD : std_logic_vector(31 downto 0);


    signal RD1E : std_logic_vector(31 downto 0);
    signal RD2E : std_logic_vector(31 downto 0);
    signal PCE : std_logic_vector(31 downto 0);
    signal ImmExtE : std_logic_vector(31 downto 0);
    signal ForwardAE : std_logic_vector(1 downto 0);
    signal ForwardBE : std_logic_vector(1 downto 0);
    signal WriteDataE : std_logic_vector(31 downto 0);
    signal AluResultE : std_logic_vector(31 downto 0);
    signal zeroE : std_logic;


    signal s_AluResultM : std_logic_vector(31 downto 0);


    signal ReadDataW : std_logic_vector(31 downto 0);
    signal PCPlus4W : std_logic_vector(31 downto 0);
    signal AluResultW : std_logic_vector(31 downto 0);


    signal IF_ID_reg_IN, IF_ID_reg_OUT : std_logic_vector(95 downto 0);
    signal ID_EX_reg_IN, ID_EX_reg_OUT : std_logic_vector(255 downto 0);
    signal EX_MEM_reg_IN, EX_MEM_reg_OUT : std_logic_vector(127 downto 0);
    signal MEM_WB_reg_IN, MEM_WB_reg_OUT : std_logic_vector(127 downto 0);
    
    
    signal PCD, PCPlus4D, PCPlus4E, PCPlus4M : std_logic_vector(31 downto 0);
    signal RegWriteE, MemWriteE, jumpE, branchE, ALUSrcE, RegWriteM, RegWriteW : std_logic;
    signal ResultSrcE, ResultSrcM, ResultSrcW : std_logic_vector(1 downto 0);
    signal ALUControlE : std_logic_vector(2 downto 0);

begin
    
 
    ---- IF
    IF_inst: DF_IF
        port map(
            Clock => Clock,
            Reset => Reset,
            PCTargetE => PCTargetE,
            PCSrcE => PCSrcE,
            StallIF => StallF,
            PCF => PCF,
            PCPlus4 => PCPlus4F            
        );
    
    IF_ID_reg_IN <= InstrF & PCF & PCPlus4F;

    IF_ID_reg : register_d generic map (96) port map(
        clock => Clock,
        clear => FlushD,
        enable => StallD,
        D => IF_ID_reg_IN,
        Q => IF_ID_reg_OUT
    );

    InstrD <= IF_ID_reg_OUT(95 downto 64);
    PCD <= IF_ID_reg_OUT(63 downto 32);
    PCPlus4D <= IF_ID_reg_OUT(31 downto 0);

    ---- ID
    ID_inst: DF_ID
        port map(
            Clock => Clock,
            Reset => Reset,
            InstrD => InstrD,
            RegWriteW => RegWriteW,
            ResultW => ResultW,
            RdW => RdW,
            ImmSrcD => ImmSrcD,
            RD1D => RD1D,
            RD2D => RD2D,
            RdD => RdD,
            RS1D => RS1D,
            RS2D => RS2D,
            ImmExtD => ImmExtD
        );

    
    ID_EX_reg_IN <= RegWriteD & ResultSrcD & MemWriteD & JumpD & BranchD & ALUControlD & ALUSrcD & RD1D & RD2D & PCD & RS1D & RS2D & RdD & ImmExtD & PCPlus4D; -- + 10 controle

    ID_EX_reg : register_d generic map(185) port map (
        clock => Clock,
        clear => FlushE,
        enable => '1',
        D => ID_EX_reg_IN,
        Q => ID_EX_reg_OUT
    );

    RegWriteE <= ID_EX_reg_OUT(184);
    ResultSrcE <= ID_EX_reg_OUT(183 downto 182);
    MemWriteE <= ID_EX_reg_OUT(181);
    JumpE <= ID_EX_reg_OUT(180);
    BranchE <= ID_EX_reg_OUT(179);
    ALUControlE <= ID_EX_reg_OUT(178 downto 176);
    AluSrcE <= ID_EX_reg_OUT(175);
    RD1E <= ID_EX_reg_OUT(174 downto 143);
    RD2E <= ID_EX_reg_OUT(142 downto 111);
    PCE <= ID_EX_reg_OUT(110 downto 79);
    RS1E <= ID_EX_reg_OUT(78 downto 74);
    RS2E <= ID_EX_reg_OUT(73 downto 69);
    RdE <= ID_EX_reg_OUT(68 downto 64);
    ImmExtE <= ID_EX_reg_OUT(63 downto 32);
    PCPlus4E <= ID_EX_reg_OUT(31 downto 0);

    ---- EX

    EX_inst: DF_EX
        port map(
            Clock => Clock,
            Reset => Reset,
            RD1E => RD1E,
            RD2E => RD2E,
            PCE => PCE,
            ImmExtE => ImmExtE,
            AluResultM => s_AluResultM,
            ResultW => ResultW,
            ALUControlE => ALUControlE,
            ALUsrcE => ALUsrcE,
            FowardAE => FowardAE,
            FowardBE => FowardBE,
            PCTargetE => PCTargetE,
            WriteDataE => WriteDataE,
            AluResultE => AluResultE,
            zeroE => zeroE
        );

        EX_MEM_reg_IN <= RegWriteE & ResultSrcE & MemWriteE & AluResultE & WriteDataE & RdE & PCPlus4E; -- + 4 de controle
        
        EX_MEM_reg : register_d generic map(105) port map (
            clock => Clock,
            clear => '0',
            enable => '1',
            D => EX_MEM_reg_IN,
            Q => EX_MEM_reg_OUT
        );

        RegWriteM <= EX_MEM_reg_OUT(104);
        ResultSrcM <= EX_MEM_reg_OUT(103 downto 102);
        MemWriteM <= Ex_MEM_reg_OUT(101);
        s_AluResultM <= EX_MEM_reg_OUT(100 downto 69);
        WriteDataM <= EX_MEM_reg_OUT(68 downto 37);
        RdM <= EX_MEM_reg_OUT(36 downto 32);
        PCPlus4M <= EX_MEM_reg_OUT(31 downto 0);
        AluResultM <= s_AluResultM;


    ----- MEM
        
        MEM_WB_reg_IN <= RegWriteM & ResultSrcM & s_ALUResultM & ReadDataM & RdM & PCPlus4M; -- + 3 sinais de controle

        MEM_WB_reg : register_d generic map(104) port map (
            clock => Clock,
            clear => '0',
            enable => '1',
            D => MEM_WB_reg_IN,
            Q => MEM_WB_reg_OUT
        );

        RegWriteW <= MEM_WB_reg_OUT(103);
        ResultSrcW <= MEM_WB_reg_out(102 downto 101);
        ALUResultW <= MEM_WB_reg_OUT(100 downto 69);
        ReadDataW <= MEM_WB_reg_OUT(68 downto 37);
        RdW <= MEM_WB_reg_OUT(36 downto 32);
        PCPlus4W <= MEM_WB_reg_OUT(31 downto 0);

            	
    ----- WB
    WB_inst : DF_WB
        port map(
            ReadDataW => ReadDataW,
            PCPlus4W => PCPlus4W,
            AluResultW => AluResultW,
            ResultSrcW => ResultSrcW,
            ResultW => ResultW
        );

    
    HU: HAZARD_UNIT
        port map(
            Rs1D => Rs1D,
            Rs2D => Rs2D,
            RdE => RdE,
            Rs2E => Rs2E,
            Rs1E => Rs1E,
            PCScrE => PCScrE,
            ResultSrcE_0 => ResultSrcE(0),
            RdM => RdM,
            RegWriteM => RegWriteM,
            RdW => RdW,
            RegWriteW => RegWriteW,
            StallF => StallF,
            StallD => StallD,
            FlushD => FlushD,
            FlushE => FlushE,
            ForwardAE => ForwardAE,
            ForwardBE => ForwardBE
        );



end structural ; -- structural