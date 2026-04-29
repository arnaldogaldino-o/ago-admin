---
name: criar-grupo-endpoint
user-invocable: true
description: "Skill para scaffolding que cria um novo grupo de endpoints"
allowed-tools: Bash, Writer, Read
---

# Skill: Criar um novo grupo de endpoints

### Argumentos obrigatórios:
nome-grupo-endpoint - Nome da Grupo de Endpoints

### Exemplo de entrada
```
Nome da Grupo de Endpoints: Produto
```

### Variáveis a derivar dos argumentos
| Variável        | Como derivar                                 | Exemplo            |
|-----------------|----------------------------------------------|--------------------|
| `{nome-grupo-endpoint}` | Nome do grupo de endpoints a ser criado | `Produto`      |

## Passo 1 - Criar o grupo de endpoints
- Criar uma nova classe estática de endpoints para o grupo especificado, seguindo a convenção `{nome-grupo-endpoint}Endpoints.cs` dentro da pasta `Endpoints` do projeto API.
- Nesta classe criada adicionar um método de extensão `Map{nome-grupo-endpoint}Endpoints` para configurar os endpoints relacionados ao grupo com o nome do grupo escrito no plural. 
- configurar o var {nome-grupo-endpoint}Group = app.MapGroup("/{nome-grupo-endpoint.ToLower()}").WithTags("{nome-grupo-endpoint}"); -- O nome do grupo no MapGroup deve ser o nome do grupo em letras minúsculas e no plural.
- O método de extensão deve ser chamado no `Program.cs` para registrar os endpoints do grupo na aplicação.

