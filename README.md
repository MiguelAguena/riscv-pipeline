# riscv-pipeline

## - [:label: Descrição](Descrição)

Repositório de projeto desenvolvido em grupo para a disciplina PCS3612 - Arquitetura e Organização de Computadores I, oferecida no segundo semestre de 2023. A atividade consiste na implementação, em linguagem VHDL, do pipeline para um processador com tecnologia RISC-V.

## - [💻: Tecnologias Utilizadas](Tecnologias Utilizadas)

* Linguagem VHDL
  * Bibliotecas ieee, ieee.std_logic_1164.all, ieee.numeric_std.all, ieee.math_real.all, std.textio.all e ieee.numeric_bit.all
* IDE VSCode
  
## - [🔰: Inicialização](Inicialização)

## - [📂: Organização](Organização)
.
├── extra
├── pipe                   # Arquivos do pipeline
│   ├── work               # Pasta work do VHDL
│   ├── DF.vhd             # Componente do Fluxo de dados
|   ├── DF_EX.vhd          # Módulo do estágio EX
|   ├── DF_ID.vhd          # Módulo do estágio ID
|   ├── DF_IF.vhd          # Módulo do estágio IF
|   ├── DF_WB.vhd          # Módulo do estágio WB
|   ├── HAZARD_UNIT.vhd    # Componente da unidade de Hazard
|   ├── UC.vhd             # Componente da Unidade de Controle
│   ├── alu.vhd            # Componente da ULA
|   ├── alu_1_bit.vhd      # Componente de ULA de 1 bit
|   ├── aludecoder.vhd     # Componente de decodificador de ULA
|   ├── maindec.vhd  
|   ├── program.vhd  
|   ├── ram.vhd  
|   ├── regfile.vhd  
|   ├── register_d.vhd  
|   ├── riscv_pp.vhd  
|   ├── riscv_pp_tb.vhd  
|   ├── rom.vhd  
|   ├── signExtend.vhd  
|   ├── signExtend.vhd.bak
|   ├── vsim.wlf
│   └── wave.do               
├── .gitignore              
├── CITATION.cff
└── README.md
