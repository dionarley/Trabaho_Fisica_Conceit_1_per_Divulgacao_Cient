# Curiosidades sobre o Projeto

*Última atualização: 02/05/2026*


Esta página apresenta estatísticas e curiosidades sobre o desenvolvimento do projeto Isaac Newton.

## Estatísticas do Código (via cloc)

```
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Markdown                        16            550              0           1424
Bourne Shell                    10            149             89            708
Text                             5             64              0            143
CSV                              4              9              0             77
YAML                             1              6              0             60
-------------------------------------------------------------------------------
SUM:                            36            778             89           2412
-------------------------------------------------------------------------------
```

### Detalhamento:

| Linguagem | Arquivos | Linhas em Branco | Comentários | Código |
|-----------|----------|-------------------|------------|--------|
| **Markdown** | 16 | 550 | 0 | 1424 |
| **Bourne Shell** | 10 | 149 | 89 | 708 |
| **Text** | 5 | 64 | 0 | 143 |
| **CSV** | 4 | 9 | 0 | 77 |
| **YAML** | 1 | 6 | 0 | 60 |
| **TOTAL** | **36** | **778** | **89** | **2412** |

!!! info "O que isso significa?"
    - **1424 linhas** de documentação Markdown (docs/)
    - **708 linhas** de scripts de automação (scripts/)
    - **89 linhas** de comentários nos scripts
    - **77 linhas** de dados estruturados (CSV)
    - **60 linhas** de configuração (mkdocs.yml)

## Estatísticas do Git

```bash
# Comandos executados:
git log --oneline | wc -l
git log --all --pretty=format:"%an" | sort | uniq -c
git log --all --pretty=format:"%ad" --date=short | sort | uniq -c
```

### Commits:

| Métrica | Quantidade |
|----------|-----------|
| **Total de commits** | 58 | |+ |
| **Primeiro commit** | 2026 (início do projeto) |
| **Último commit** | (ver `git log -1`) |

