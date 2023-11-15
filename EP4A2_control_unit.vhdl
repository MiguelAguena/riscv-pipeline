-------------------------------------------------------
--! @file EP4A2_control_unit.vhdl
--! @brief PoliLEG control unit.
--! @author Miguel Aguena (miguel.aguena@usp.br)
--! @date 2022-06-20
-------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

entity alucontrol is
    port(
        aluOp : in bit_vector(1 downto 0);
        opcode : in bit_vector(10 downto 0);
        aluCtrl : out bit_vector(3 downto 0)
    );
end alucontrol;

architecture alucontrol_1 of alucontrol is

begin
    aluCtrl <= "0010" when (aluOp = "00") else
               "0111" when (aluOp = "01") else
               "0010" when (aluOp = "10" AND opcode = "10001011000") else
               "0110" when (aluOp = "10" AND opcode = "11001011000") else
               "0000" when (aluOp = "10" AND opcode = "10001010000") else
               "0001" when (aluOp = "10" AND opcode = "10101010000") else
               "0000";
end architecture;

entity pccontrol is
    port(
        uncondBranch : in bit;
        branch : in bit;
        zero : in bit;
        pcsrc : out bit    
    );
end pccontrol;

architecture pccontrol_1 of pccontrol is

begin
    pcsrc <= uncondBranch OR (branch AND zero);
end architecture;

library ieee;
use ieee.numeric_bit.all;

entity controlunit is
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
end controlunit;

architecture controlunit_1 of controlunit is
begin
    reg2loc <= '0' when (opcode(10) = '1' AND opcode(7 downto 4) = "0101" AND opcode(2 downto 0) = "000") else
               '1' when (opcode = "11111000010") else
               '1' when (opcode = "11111000000") else
               '1' when (opcode(10 downto 3) = "10110100") else
               '1' when (opcode(10 downto 5) = "000101") else
               '0';

    aluSrc <= '0' when (opcode(10) = '1' AND opcode(7 downto 4) = "0101" AND opcode(2 downto 0) = "000") else
              '1' when (opcode = "11111000010") else
              '1' when (opcode = "11111000000") else
              '0' when (opcode(10 downto 3) = "10110100") else
              '0' when (opcode(10 downto 5) = "000101") else
              '0';

    memToReg <= '0' when (opcode(10) = '1' AND opcode(7 downto 4) = "0101" AND opcode(2 downto 0) = "000") else
                '1' when (opcode = "11111000010") else
                '1' when (opcode = "11111000000") else
                '1' when (opcode(10 downto 3) = "10110100") else
                '1' when (opcode(10 downto 5) = "000101") else
                '0';

    regWrite <= '1' when (opcode(10) = '1' AND opcode(7 downto 4) = "0101" AND opcode(2 downto 0) = "000") else
                '1' when (opcode = "11111000010") else
                '0' when (opcode = "11111000000") else
                '0' when (opcode(10 downto 3) = "10110100") else
                '0' when (opcode(10 downto 5) = "000101") else
                '0';

    memRead <= '0' when (opcode(10) = '1' AND opcode(7 downto 4) = "0101" AND opcode(2 downto 0) = "000") else
               '1' when (opcode = "11111000010") else
               '0' when (opcode = "11111000000") else
               '0' when (opcode(10 downto 3) = "10110100") else
               '0' when (opcode(10 downto 5) = "000101") else
               '0';

    memWrite <= '0' when (opcode(10) = '1' AND opcode(7 downto 4) = "0101" AND opcode(2 downto 0) = "000") else
                '0' when (opcode = "11111000010") else
                '1' when (opcode = "11111000000") else
                '0' when (opcode(10 downto 3) = "10110100") else
                '0' when (opcode(10 downto 5) = "000101") else
                '0';

    branch <= '0' when (opcode(10) = '1' AND opcode(7 downto 4) = "0101" AND opcode(2 downto 0) = "000") else
              '0' when (opcode = "11111000010") else
              '0' when (opcode = "11111000000") else
              '1' when (opcode(10 downto 3) = "10110100") else
              '0' when (opcode(10 downto 5) = "000101") else
              '0';

    uncondBranch <= '0' when (opcode(10) = '1' AND opcode(7 downto 4) = "0101" AND opcode(2 downto 0) = "000") else
                    '0' when (opcode = "11111000010") else
                    '0' when (opcode = "11111000000") else
                    '0' when (opcode(10 downto 3) = "10110100") else
                    '1' when (opcode(10 downto 5) = "000101") else
                    '0';

    aluOp(1) <= '1' when (opcode(10) = '1' AND opcode(7 downto 4) = "0101" AND opcode(2 downto 0) = "000") else
                '0' when (opcode = "11111000010") else
                '0' when (opcode = "11111000000") else
                '0' when (opcode(10 downto 3) = "10110100") else
                '0' when (opcode(10 downto 5) = "000101") else
                '0';

    aluOp(0) <= '0' when (opcode(10) = '1' AND opcode(7 downto 4) = "0101" AND opcode(2 downto 0) = "000") else
                '0' when (opcode = "11111000010") else
                '0' when (opcode = "11111000000") else
                '1' when (opcode(10 downto 3) = "10110100") else
                '0' when (opcode(10 downto 5) = "000101") else
                '0';
end architecture;