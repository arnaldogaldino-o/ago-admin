---
name: criar-endpoint
user-invocable: true
description: "Skill para scaffolding que cria um novo endpoint genérico em um projeto ASP.NET Core Web API, seguindo as melhores práticas de organização e estruturação de código. User sempre que o usuário pedir para criar um novo endpoint, adicionar um endpoint, criar um grupo de endpoints ou gerar um endpoint genérico com .NET, ASP.NET, Minimal APIs."
allowed-tools: Bash, Writer, Read
---

# Skill: Criar um novo endpoint

### Argumentos obrigatórios:
- nome-grupo-endpoint - Nome do Grupo de Endpoint
- nome-endpoint - Nome do Endpoint
- nome-service - Nome da Service
- campos-dto-request - Campos da DTO de request no formato Nome (Tipo), separados por vírgula
- campos-dto-response - Campos da DTO de response no formato Nome (Tipo), separados por

### Exemplo de entrada
```
Nome do Grupo de Endpoints: Produtos
Nome do Endpoints: Produto
Nome da Service: ProdutoService
Campos da DTO de request: Id (int), Nome (string), Preco (decimal)
Campos do DTO de response: Id (int), Nome (string), Preco (decimal)
```

### Variáveis a derivar dos argumentos
| Variável        | Como derivar                                 | Exemplo            |
|-----------------|----------------------------------------------|--------------------|
| `{nome-endpoint}` | Nome do endpoint a ser criado | `Produto`      |

## Passo 1 - Criar o endpoints
- Criar uma nova classe estática de endpoints para o grupo especificado, seguindo a convenção `{nome-grupo-endpoint}Endpoints.cs` dentro da pasta `Endpoints` do projeto API.
- Nesta classe criada adicionar um método de extensão `Map{nome-grupo-endpoint}Endpoints` para configurar os endpoints relacionados ao grupo. 
- configurar o var {nome-grupo-endpoint}Group = app.MapGroup("/{nome-grupo-endpoint.ToLower()}").WithTags("{nome-grupo-endpoint}");
- O método de extensão deve ser chamado no `Program.cs` para registrar os endpoints do grupo na aplicação.
|