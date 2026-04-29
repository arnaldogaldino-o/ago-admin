---
name: example-step-skill
user-invocable: true
description: "Skill de exemplo que descreve 5 passos sequenciais (ex: passo 1 - faz uma coisa, passo 2 - faz outra coisa). Útil para demonstrar fluxo simples de tarefas." 
allowed-tools: Bash, Writer, Read
---

# Skill: Exemplo de Steps

Esta skill documenta um fluxo de 5 passos de exemplo. Cada passo descreve a ação esperada e fornece um comando Bash opcional que ilustra a ação.

Passos:

- Passo 1 - Criar pasta de trabalho
  - Descrição: Cria uma pasta temporária para as ações subsequentes.
  - Comando exemplo:

```bash
mkdir -p ./tmp/example-skill-workdir
```

- Passo 2 - Criar um arquivo de exemplo
  - Descrição: Gera um arquivo `step2.txt` com conteúdo demonstrativo.
  - Comando exemplo:

```bash
echo "Conteúdo do passo 2" > ./tmp/example-skill-workdir/step2.txt
```

- Passo 3 - Listar conteúdo
  - Descrição: Confirma que os arquivos esperados existem listando o diretório.
  - Comando exemplo:

```bash
ls -la ./tmp/example-skill-workdir
```

- Passo 4 - Executar uma verificação simples
  - Descrição: Verifica se `step2.txt` contém o texto esperado.
  - Comando exemplo:

```bash
grep -q "Conteúdo do passo 2" ./tmp/example-skill-workdir/step2.txt && echo "ok" || echo "falhou"
```

- Passo 5 - Limpar ambiente
  - Descrição: Remove a pasta de trabalho criada no passo 1.
  - Comando exemplo:

```bash
rm -rf ./tmp/example-skill-workdir
```

### Exemplo de uso

Execute os 5 passos localmente em um terminal Bash (os comandos são idempotentes para fins de demonstração):

```bash
mkdir -p ./tmp/example-skill-workdir
echo "Conteúdo do passo 2" > ./tmp/example-skill-workdir/step2.txt
ls -la ./tmp/example-skill-workdir
grep -q "Conteúdo do passo 2" ./tmp/example-skill-workdir/step2.txt && echo "ok" || echo "falhou"
rm -rf ./tmp/example-skill-workdir
```

---
Fim da skill de exemplo.
