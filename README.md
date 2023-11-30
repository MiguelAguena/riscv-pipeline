# riscv-pipeline

## - [:label: Descrição](Descrição)

Repositório de projeto desenvolvido em grupo para a disciplina PCS3612 - Arquitetura e Organização de Computadores I, oferecida no segundo semestre de 2023. A atividade consiste na implementação, em linguagem VHDL, do pipeline para um processador com tecnologia RISC-V.

## - [💻: Tecnologias Utilizadas](TecnologiasUtilizadas)

* Linguagem VHDL
  * Bibliotecas ieee, ieee.std_logic_1164.all, ieee.numeric_std.all, ieee.math_real.all, std.textio.all e ieee.numeric_bit.all
* IDE VSCode 1.82.3 (código)
* Questa 2021.2 (simulação)
* ModelSim 2020.1 (simulação)
* Quartus Prime 20.1 (simulação)
  
## - [🔰: Inicialização](Inicialização)

Para acessar o processador desenvolvido, abra a pasta pipe no ModelSim ou Questa e, após a compilação de todos os 
arquivos, inicie a simulação da entidade riscv_pp_tb. Essa simulação é carregada com o código presente em program.txt. 
Para realizar testes adicionais, altere o conteúdo desse arquivo para a representação hexadecimal das instruções a
serem executadas. Os sinais observados na simulação podem ser escolhidos pela interface do ModelSim ou Questa.


## - [📂: Organização](Organização)
```bash
.
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
|   ├── maindec.vhd        # Componente de decodificador dos sinais de controle
|   ├── program.vhd        # Código do RISC-V de Harris e Harris usado como referência para testes 
|   ├── ram.vhd            # Componente de RAM
|   ├── regfile.vhd        # Componente de banco de registradores
|   ├── register_d.vhd     # Componente de registrador do tipo D
|   ├── riscv_pp.vhd       # Arquivo principal do pipeline do risc-v
|   ├── riscv_pp_tb.vhd    # Arquivo de teste do pipeline
|   ├── rom.vhd            # Componente de ROM
|   ├── signExtend.vhd     # Componente de extensor de sinal
|   ├── signExtend.vhd.bak # Output da simulação
|   ├── vsim.wlf           # Output da simulação
│   └── wave.do            # Output da simulação
├── .gitignore              
├── CITATION.cff
└── README.md
```
