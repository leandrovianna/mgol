# Mgol Compiler

Mgol is the programming language for case study of Compiler class of 2019/1.

## Grammar

| No | Production                        |
|----|-----------------------------------|
| 0  | P' -> P                           |
| 1  | P -> inicio V A                   |
| 2  | V -> varinicio LV                 |
| 3  | LV -> D LV                        |
| 4  | LV -> varfim ;                    |
| 5  | D -> id TIPO ;                    |
| 6  | TIPO -> inteiro                   |
| 7  | TIPO -> real                      |
| 8  | TIPO -> literal                   |
| 9  | A -> ES A                         |
| 10 | ES -> leia id ;                   |
| 11 | ES -> escreva ARG ;               |
| 12 | ARG -> const_literal              |
| 13 | ARG -> num                        |
| 14 | ARG -> id                         |
| 15 | A -> CMD A                        |
| 16 | CMD -> id rcb LD ;                |
| 17 | LD -> OPRD opm OPRD               |
| 18 | LD -> OPRD                        |
| 19 | OPRD -> id                        |
| 20 | OPRD -> num                       |
| 21 | A -> COND A                       |
| 22 | COND -> CAB CORPO                 |
| 23 | CAB -> se ( EXP_R ) entao         |
| 24 | EXP_R -> OPRD opr OPRD            |
| 25 | CORPO -> ES CORPO                 |
| 26 | CORPO -> CMD CORPO                |
| 27 | CORPO -> COND CORPO               |
| 28 | CORPO -> fimse                    |
| 29 | A -> fim                          |
| 30 | A -> REP A                        |
| 31 | REP -> REPCAB REPCORPO            |
| 32 | REPCORPO -> ES REPCORPO           |
| 33 | REPCORPO -> CMD REPCORPO          |
| 34 | REPCORPO -> COND REPCORPO         |
| 35 | REPCORPO -> REP REPCORPO          |
| 36 | REPCORPO -> fimenquanto           |
| 37 | CORPO -> REP CORPO                |
| 38 | REPCAB -> enquanto ( EXP_R ) faca |
