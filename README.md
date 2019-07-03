# Mgol Compiler

Mgol is the programming language for case study of Compiler class of 2019/1.

## Grammar

| No | Production                              |
|----|-----------------------------------------|
| 1  | P' -> P                                 |
| 2  | P -> inicio V A                         |
| 3  | V -> varinicio LV                       |
| 4  | LV -> D LV                              |
| 5  | LV -> varfim ;                          |
| 6  | D -> id TIPO ;                          |
| 7  | TIPO -> inteiro                         |
| 8  | TIPO -> real                            |
| 9  | TIPO -> literal                         |
| 10 | A -> ES A                               |
| 11 | ES -> leia id ;                         |
| 12 | ES -> escreva ARG ;                     |
| 13 | ARG -> const_literal                    |
| 14 | ARG -> num                              |
| 15 | ARG -> id                               |
| 16 | A -> CMD A                              |
| 17 | CMD -> id rcb LD ;                      |
| 18 | LD -> OPRD opm OPRD                     |
| 19 | LD -> OPRD                              |
| 20 | OPRD -> id                              |
| 21 | OPRD -> num                             |
| 22 | A -> COND A                             |
| 23 | COND -> CAB CORPO                       |
| 24 | CAB -> se ( EXP_R ) entao               |
| 25 | EXP_R -> OPRD opr OPRD                  |
| 26 | CORPO -> ES CORPO                       |
| 27 | CORPO -> CMD CORPO                      |
| 28 | CORPO -> COND CORPO                     |
| 29 | CORPO -> fimse                          |
| 30 | A -> fim                                |
| 31 | A -> REP A                              |
| 32 | REP -> enquanto ( EXP_R ) faca REPCORPO |
| 33 | REPCORPO -> ES REPCORPO                 |
| 34 | REPCORPO -> CMD REPCORPO                |
| 35 | REPCORPO -> COND REPCORPO               |
| 36 | REPCORPO -> REP REPCORPO                |
| 37 | REPCORPO -> fimenquanto                 |
| 38 | CORPO -> REP CORPO                      |
