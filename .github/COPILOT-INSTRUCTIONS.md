# Instruções para criação do Projeto AgoAdmin API usando Skill criar-api-aspnet

- Use a skill "criar-api-aspnet" para criar a estrutura básica do projeto.
- Forneça os seguintes argumentos para a skill (exemplo):
    - `nome-projeto`: AgoAdmin
    - `caminho-completo`: ./server
    - `string-de-conexao`: Host=localhost;Port=5432;Database=agoadmin;Username=postgres;Password=<NÃO_INCLUIR_NO_REPO>;Include Error Detail=false

- Crie os projetos seguindo uma convenção padronizada (ex.:)
    - `AgoAdmin.Api`
    - `AgoAdmin.Application`
    - `AgoAdmin.Domain`
    - `AgoAdmin.Infrastructure.Data`
    - `AgoAdmin.Infrastructure.CrossCutting.IoC`
    - `AgoAdmin.Infrastructure.CrossCutting.Identity`
    - `AgoAdmin.Tests`

- Observações de segurança e portabilidade:
    - **Não** deixe senhas em texto claro no repositório. Use variáveis de ambiente ou um secrets manager (ex.: `PG_PASSWORD`).
    - Evite caminhos absolutos (ex.: `C:/...`). Use caminhos relativos (`./server`) ou variáveis de workspace para portabilidade entre máquinas/CI.
    - `Include Error Detail=true` expõe detalhes de erro; defina como `false` em ambientes de produção.

- Exemplo de invocação (PowerShell):

```powershell
# definir a senha em variável de ambiente (somente sessão atual)
$env:PG_PASSWORD = 'sua_senha_aqui'

# exemplo de chamada (substitua pelo mecanismo de invocação da skill)
criar-api-aspnet --nome-projeto AgoAdmin --caminho-completo ./server --string-de-conexao "Host=localhost;Port=5432;Database=agoadmin;Username=postgres;Password=$env:PG_PASSWORD;Include Error Detail=false"
```

- Checklist de pré-requisitos e passos pós-criação:
    - .NET SDK (especifique a versão desejada, ex.: .NET 8) instalado e no PATH.
    - EF Core/Tools instalados conforme a versão do projeto.
    - PostgreSQL rodando localmente ou credenciais de acesso válidas.
    - Variáveis de ambiente com secrets configuradas (ex.: `PG_PASSWORD`).
    - Git configurado e branch de trabalho criado antes do scaffold.
    - Após scaffold: `dotnet restore`, ajustar `appsettings.*` com values seguros, criar e aplicar migrations (`dotnet ef migrations add Initial` / `dotnet ef database update`).

# Executar as tarefas de cada sprint seguindo as instruções detalhadas em cada arquivo de sprint:
- Sprint 1: [01-SPRINT.md](.github/sprints/sprint-01/01-SPRINT.md)

