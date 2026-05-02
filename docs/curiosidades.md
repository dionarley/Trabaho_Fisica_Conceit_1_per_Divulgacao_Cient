# Curiosidades sobre o Projeto

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
| **Total de commits** | 15+ |
| **Primeiro commit** | 2026 (início do projeto) |
| **Último commit** | (ver `git log -1`) |

### Contribuidores:

| Autor | Commits |
|--------|---------|
| Dionarley Ruas Vieira | 15+ |

!!! tip "Curiosidade"
    Como o projeto é colaborativo, espera-se que outros membros do grupo também façam commits após configurarem o Git!

## Estatísticas dos Documentos

### Tamanho dos Arquivos:

| Arquivo | Tamanho | Descrição |
|---------|---------|------------|
| `Referencias_PDFs/monografia-Durval-Araujo-de-Mendonça.pdf` | 7,9 MB | Monografia acadêmica |
| `site/documento-isaac-newton.pdf` | ~543 KB | PDF gerado pelo mkdocs-with-pdf |
| `LICENSE` | ~34 KB | Licença CC BY-NC-SA 4.0 |
| `README.md` | ~15 KB | Este arquivo de documentação |
| `AGENTS.md` | ~5 KB | Guia para agentes IA |

### Planilhas (planilhas/):

| Arquivo | Linhas | Descrição |
|---------|--------|------------|
| `materiais-papel.csv` | 16 | Preços de papel |
| `impressoras-comparacao.csv` | 16 | Comparação de impressoras |
| `orcamento-projeto.csv` | 44 | Orçamento completo |
| `membros-grupo.csv` | 6 | Cadastro de membros |

## Membros do Grupo

| # | Nome | Função | Status |
|---|------|--------|--------|
| 1 | Amanda | Administradora do WhatsApp | ✅ Confirmada |
| 2 | Sara | Coordenadora | ✅ Confirmada |
| 3 | Bernado | A definir | ✅ Confirmada |
| 4 | Miguel | A definir | ✅ Confirmada |
| 5 | Dionarley Ruas Vieira | TI, Documentos, Ilustração | ✅ Confirmada |
| 6 | ? (WhatsApp final 6144) | A definir | ✅ Confirmada |

!!! info "Total: 6 membros"
    Todos os membros confirmaram participação via formulário Google!

## Tecnologias Utilizadas

### Core:
- **Python 3.x** - Linguagem base
- **MkDocs 1.4.8** - Gerador de documentação estática
- **MkDocs-Material 1.5.5** - Tema visual
- **mkdocs-with-pdf 0.9.3** - Plugin para geração de PDF

### Ferramentas Recomendadas:
- **Scribus** - Desktop Publishing (layout final do gibi)
- **Manuskript** - Escrita de roteiro e story
- **Git** - Controle de versão
- **GitHub Pages** - Hospedagem do site

## Curiosidades Interessantes

### 1. O Nome do Repositório
O repositório foi renomeado de `Trabaho_Fisica_Conceit_1_per_Divulgacao_Cient` (com erro de grafia) para **`Trabalho_Fisica_Conceit_1_per_Divulgacao_Cient`** (correto). Todas as URLs e documentos foram atualizados!

### 2. PDF Único vs. Múltiplos
Inicialmente tentamos usar o `mkdocs-pdf-export-plugin`, mas ele criava um PDF **para cada página**. Mudamos para `mkdocs-with-pdf` que gera um **PDF único** com todo o conteúdo.

### 3. Automação Completa
O projeto possui **9 scripts de automação**:
- Verificação de URLs quebradas
- Verificação de segurança e vazamento de dados
- Geração de PDF
- Backup automático
- Testes automatizados (20/20 passando!)

### 4. Site GitHub Pages
O site está hospedado gratuitamente no GitHub Pages:
- **URL:** https://dionarley.github.io/Trabalho_Fisica_Conceit_1_per_Divulgacao_Cient/
- **PDF:** https://dionarley.github.io/Trabalho_Fisica_Conceit_1_per_Divulgacao_Cient/documento-isaac-newton.pdf
- **Atualização:** Automática via `mkdocs gh-deploy`

### 5. Licença CC BY-NC-SA 4.0
Esta licença permite:
- ✅ Compartilhamento
- ✅ Adaptação
- ❌ Uso comercial proibido
- ♻️ Obras derivadas sob a mesma licença

### 6. Formulário Google
O cadastro dos membros é feito via Google Forms:
- **Link:** https://forms.gle/xCesouPkVSyFJ43F7
- **Dados:** Salvos em `planilhas/membros-grupo.csv`
- **Integração:** Dados alimentam `mkdocs.yml` e tabelas no site

## Linha do Tempo do Projeto

```
2026-05-02: Início do projeto
         ├── Criação do repositório
         ├── Configuração inicial do MkDocs
         └── Primeiro commit

2026-05-02: Desenvolvimento
         ├── Adição de tutoriais (Manuskript, Scribus)
         ├── Criação de scripts de automação (9 scripts)
         ├── Correção de URLs quebradas
         ├── Implementação de verificação de segurança
         └── Geração de PDF único

2026-05-02: Deploy
         ├── Site no GitHub Pages (8+ deploys)
         ├── PDF acessível online
         └── Documentação completa (14 páginas)
```

## Como Gerar Estatísticas Você Mesmo

```bash
# Instalar cloc (se não tiver)
sudo apt install cloc  # Linux
brew install cloc           # macOS

# Gerar estatísticas
cd Isaac_Newton
cloc . --exclude-dir=site,.git,backups,__pycache__

# Verificar commits
git log --oneline | wc -l

# Verificar contribuidores
git log --all --pretty=format:"%an" | sort | uniq -c
```

!!! success "Projeto em Andamento"
    Este projeto está em desenvolvimento ativo. Novas funcionalidades e conteúdos estão sendo adicionados regularmente!
