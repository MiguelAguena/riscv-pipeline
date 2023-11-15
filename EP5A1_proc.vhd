library ieee;
use     ieee.math_real.all;
use     ieee.numeric_bit.all;
entity polilegsc is
    port (
        clock, reset : in bit;
        --Data Memory
        dmem_addr : out bit_vector(63 downto 0);
        dmem_dati : out bit_vector(63 downto 0);
        dmem_dato : in bit_vector(63 downto 0);
        dmem_we : out bit;
        --Instruction Memory
        imem_addr : out bit_vector(63 downto 0);
        imem_data : in bit_vector(31 downto 0)
    );
end entity;

architecture polilegsc_1 of polilegsc is
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
    component controlunit is
        port(
            --To Datapath
            reg2loc : out bit;
            uncondBranch : out bit;
            branch : out bit;
            memRead : out bit;
            memToReg : out bit;
            aluOp : out bit_vector(1 downto 0);
            memWrite : out bit;
            aluSrc : out bit;
            regWrite : out bit;
            --From Datapath
            opcode : in bit_vector(10 downto 0)
        );
    end component controlunit;
    component alucontrol is
        port(
            aluOp : in bit_vector(1 downto 0);
            opcode : in bit_vector(10 downto 0);
            aluCtrl : out bit_vector(3 downto 0)
        );
    end component alucontrol;
    component pccontrol is
        port(
            uncondBranch : in bit;
            branch : in bit;
            zero : in bit;
            pcsrc : out bit    
        );
    end component pccontrol;
    signal reg2loc_aux, pcsrc_aux, memToReg_aux, aluSrc_aux, regWrite_aux, zero_aux, uncondBranch_aux, branch_aux : bit;
    signal aluCtrl_aux : bit_vector(3 downto 0);
    signal opcode_aux : bit_vector(10 downto 0);
    signal aluOp_aux : bit_vector(1 downto 0);
begin
    DF: datapath port map(
        --Common
        clock => clock,
        reset => reset,
        -- From Control Unit
        reg2loc => reg2loc_aux,
        pcsrc => pcsrc_aux,
        memToReg => memToReg_aux,
        aluCtrl => aluCtrl_aux,
        aluSrc => aluSrc_aux,
        regWrite => regWrite_aux,
        -- To Control Unit
        opcode => opcode_aux,
        zero => zero_aux,
        --IM interface
        imAddr => imem_addr,
        imOut => imem_data,
        --DM interface
        dmAddr => dmem_addr,
        dmIn => dmem_dati,
        dmOut => dmem_dato
    );

    UC: controlunit port map(
        --To Datapath
        reg2loc => reg2loc_aux,
        uncondBranch => uncondBranch_aux,
        branch => branch_aux,
        --memRead : out bit;
        memToReg => memToReg_aux,
        aluOp => aluOp_aux,
        memWrite => dmem_we,
        aluSrc => aluSrc_aux,
        regWrite => regWrite_aux,
        --From Datapath
        opcode => opcode_aux
    );

    PCCTRL: pccontrol port map(
        uncondBranch => uncondBranch_aux,
        branch => branch_aux,
        zero => zero_aux,
        pcsrc => pcsrc_aux
    );

    ALUCTRL: alucontrol port map(
        aluOp => aluOp_aux,
        opcode => opcode_aux,
        aluCtrl => aluCtrl_aux
    );
end architecture;