onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label CLOCK /riscv_pp_tb/clock_in
add wave -noupdate -divider -height 30 UC
add wave -noupdate -label {ALU CONTROL D} /riscv_pp_tb/uut/UnidCtrl/ALUControlD
add wave -noupdate -label {ALU OP} /riscv_pp_tb/uut/UnidCtrl/aluOp
add wave -noupdate -label {ALU SRC D} /riscv_pp_tb/uut/UnidCtrl/ALUSrcD
add wave -noupdate -label {BRANCH D} /riscv_pp_tb/uut/UnidCtrl/BranchD
add wave -noupdate -label F3 /riscv_pp_tb/uut/UnidCtrl/funct3
add wave -noupdate -label F7 /riscv_pp_tb/uut/UnidCtrl/funct7
add wave -noupdate -label {Imm Src D} /riscv_pp_tb/uut/UnidCtrl/ImmSrcD
add wave -noupdate -label {Jump D} /riscv_pp_tb/uut/UnidCtrl/JumpD
add wave -noupdate -label {MEM WRITE D} /riscv_pp_tb/uut/UnidCtrl/MemWriteD
add wave -noupdate -label OPCODE /riscv_pp_tb/uut/UnidCtrl/opcode
add wave -noupdate -label {REG WRITE D} /riscv_pp_tb/uut/UnidCtrl/RegWriteD
add wave -noupdate -label {RESULT SRC D} /riscv_pp_tb/uut/UnidCtrl/ResultSrcD
add wave -noupdate -divider -height 30 PC
add wave -noupdate -radix unsigned /riscv_pp_tb/uut/FluxDad/PCD
add wave -noupdate -divider -height 30 FETCH
add wave -noupdate /riscv_pp_tb/uut/FluxDad/StallF
add wave -noupdate -divider -height 30 EXECUTE
add wave -noupdate -color RED -label JUMP /riscv_pp_tb/uut/FluxDad/jumpE
add wave -noupdate -color RED -label BRANCH /riscv_pp_tb/uut/FluxDad/branchE
add wave -noupdate /riscv_pp_tb/uut/FluxDad/ALUControlE
add wave -noupdate /riscv_pp_tb/uut/FluxDad/AluResultE
add wave -noupdate /riscv_pp_tb/uut/FluxDad/ALUSrcE
add wave -noupdate /riscv_pp_tb/uut/FluxDad/FlushE
add wave -noupdate /riscv_pp_tb/uut/FluxDad/ForwardAE
add wave -noupdate /riscv_pp_tb/uut/FluxDad/ForwardBE
add wave -noupdate /riscv_pp_tb/uut/FluxDad/ImmExtE
add wave -noupdate /riscv_pp_tb/uut/FluxDad/MemWriteE
add wave -noupdate /riscv_pp_tb/uut/FluxDad/PCE
add wave -noupdate /riscv_pp_tb/uut/FluxDad/PCPlus4E
add wave -noupdate /riscv_pp_tb/uut/FluxDad/PCSrcE
add wave -noupdate /riscv_pp_tb/uut/FluxDad/PCTargetE
add wave -noupdate /riscv_pp_tb/uut/FluxDad/RD1E
add wave -noupdate /riscv_pp_tb/uut/FluxDad/RD2E
add wave -noupdate /riscv_pp_tb/uut/FluxDad/RdE
add wave -noupdate /riscv_pp_tb/uut/FluxDad/RegWriteE
add wave -noupdate /riscv_pp_tb/uut/FluxDad/ResultSrcE
add wave -noupdate /riscv_pp_tb/uut/FluxDad/RS1E
add wave -noupdate /riscv_pp_tb/uut/FluxDad/RS2E
add wave -noupdate /riscv_pp_tb/uut/FluxDad/WriteDataE
add wave -noupdate /riscv_pp_tb/uut/FluxDad/zeroE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {6950 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 338
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ps} {225285 ps}
