library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity riscv is
    port(
        clock : in std_logic;
        reset : in std_logic;
        imOut, readData: in std_logic_vector(31 downto 0);
        imAddr , dmAddr, writeData : out std_logic_vector(31 downto 0)
    );
end riscv;

--- PIPELINE

architecture pipeline of riscv is
    signal 

begin
end pipeline;





 ---- BASE NO PIPELINE
architecture nopipeline of riscv is

    signal control_signal : std_logic_vector(4 downto 0);

    component riscv_nopipeline_data_flux is
        Port ( 
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
        ); end component;

    
    component riscv_nopipeline_control_unit is
        port(
            --To Datapath
            resultSrc : out std_logic;
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
    end component;

    signal resultSrc, pcSrc, aluSrc, regWrite, zero  : std_logic;
    signal aluCtrl : std_logic_vector(2 downto 0);
    signal opcode : std_logic_vector(6 downto 0);
    signal immSrc : std_logic_vector(1 downto 0);
    signal imAddr, imOut , dmAddr, writeData, readData: out std_logic_vector(31 downto 0);

begin

    control_unit: riscv_nopipeline_control_unit
        port map(
            resultSrc => resultSrc,
            pcSrc => pcSrc,
            immSrc => immSrc,
            aluControl => aluControl,
            memWrite => memWrite,
            aluSrc => aluSrc,
            regWrite => regWrite,
            zero => zero,
            opcode => opcode,
            funct3 => funct3,
            funct7 => funct7
        );


    data_flux: riscv_nopipeline_data_flux
        port map (
            clock => clock,
            reset => reset,
            immSrc => immSrc,
            resultSrc => resultSrc,
            pcSrc => pcSrc,
            aluCtrl => aluCtrl,
            aluSrc => aluSrc,
            regWrite => regWrite,
            opcode => opcode,
            zero => zero,
            imAddr => imAddr,
            imOut => imOut,
            dmAddr => dmAddr,
            writeData => writeData,
            readData => readData
        );

end nopipeline;
