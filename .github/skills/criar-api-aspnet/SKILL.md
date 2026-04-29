---
name: criar-api-aspnet
user-invocable: true
description: "Skill para scaffolding criar um projeto ASP.NET Core Web API completo do zero para qualquer entidade, usando Minimal APIs, EF Core 10 com PostgreSQL e Scalar. User sempre que o usuário pedir para criar uma API ASP.NET, scaffolding ou gerar uma Web API com .NET, ASP.NET, Minimal APIs, EF Core"
allowed-tools: Bash, Writer, Read
---

# Skill: Gerar API ASP.NET Core Web API
Esta skill documenta um fluxo de passos para criar o projeto

# Regra de compatibilidade (OBRIGATÓRIO)
- .NET 10 exige pacotes EF Core com maior versão **10.x.x**
- Maior versão do EF Core deve ser igual ao target framework (`net10.0`)

# Argumentos obrigatórios:
- nome-projeto - Nome da Api
- caminho-completo - Pasta para criar a API (o nome do projeto será o último segmento do caminho)
- string-de-conexao - DefaultConnection para PostgreSQL usando o nome do projeto como database

### Exemplo de entrada
```
nome-projeto: AgoAdmin
caminho-completo: C:\_prj\SysAdmin\AgoAdmin\server
string-de-conexao: Host=localhost;port=5432;Database=AgoAdmin;Username=postgres;Password=password;Include Error Detail=true
```

### Variáveis a derivar dos argumentos
| Variável        | Como derivar                                 | Exemplo            |
|-----------------|----------------------------------------------|--------------------|
| `{nome-projeto}` | Último segmento do caminho da pasta          | `AgoAdmin`      |
| `{caminho-completo}` | Caminho completo informado                   | `C:\_prj\SysAdmin` |
| `{string-de-conexao}` | String de conexão para PostgreSQL usando o nome do projeto como database | `Host=localhost;Database=AgoAdmin;Username=postgres;Password=postgres` |

# Requisito de Framework
- Todos os projetos gerados pelo scaffolding devem usar obrigatoriamente o TargetFramework `net10.0`.
- A skill passa a forçar a criação de `.csproj` com `<TargetFramework>net10.0</TargetFramework>` e exemplos/trechos devem refletir esse valor.

Passos:

- Passo 1 - Criar projetos
    - Use `dotnet new` com `-n` para o nome do projeto e `-o` para o diretório de saída. Exemplo (Windows/Unix):
        - API: `dotnet new webapi -n "{nome-projeto}.Api" -o "{caminho-completo}/src/{nome-projeto}.Api"`
        - Application: `dotnet new classlib -n "{nome-projeto}.Application" -o "{caminho-completo}/src/{nome-projeto}.Application"`
        - Domain: `dotnet new classlib -n "{nome-projeto}.Domain" -o "{caminho-completo}/src/{nome-projeto}.Domain"`
        - Infrastructure.Data: `dotnet new classlib -n "{nome-projeto}.Infrastructure.Data" -o "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data"`
        - Infrastructure.CrossCutting.IoC: `dotnet new classlib -n "{nome-projeto}.Infrastructure.CrossCutting.IoC" -o "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.IoC"`
        - Infrastructure.CrossCutting.Identity: `dotnet new classlib -n "{nome-projeto}.Infrastructure.CrossCutting.Identity" -o "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.Identity"`
        - Tests: `dotnet new xunit -n "{nome-projeto}.Tests" -o "{caminho-completo}/src/{nome-projeto}.Tests"`
    - Limpar de todos os projetos criados os arquivos de template (ex: `WeatherForecast.cs`, `Class1.cs`, `UnitTest1.cs`) usando `Remove-Item` ou equivalente.

- Passo 2 - Referenciar os projetos
    - Use `dotnet add <proj> reference <outro-proj>` com caminhos relativos ou absolutos. Exemplos:
        - `dotnet add "{caminho-completo}/src/{nome-projeto}.Api/{nome-projeto}.Api.csproj" reference "{caminho-completo}/src/{nome-projeto}.Application/{nome-projeto}.Application.csproj"`
        - `dotnet add "{caminho-completo}/src/{nome-projeto}.Api/{nome-projeto}.Api.csproj" reference "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data/{nome-projeto}.Infrastructure.Data.csproj"`
        - `dotnet add "{caminho-completo}/src/{nome-projeto}.Application/{nome-projeto}.Application.csproj" reference "{caminho-completo}/src/{nome-projeto}.Domain/{nome-projeto}.Domain.csproj"`
    - `API` deve referenciar `Application`, `Infrastructure.CrossCutting.IoC`, `Infrastructure.CrossCutting.Identity`
    - `Application` deve referenciar `Domain`, `Infrastructure.Data`
    - `Infrastructure.Data` deve referenciar `Domain`
    - `Infrastructure.CrossCutting.IoC` deve referenciar `Application`, `Infrastructure.Data`, `Domain`

- Passo 3 - Adicionar pacotes NuGet (versões alinhadas)
    - Para garantir compatibilidade com `net10.0`, use explicitamente versões 10.x para pacotes do ASP.NET/EF Core quando disponíveis. Exemplo para API:
        - `dotnet add "{caminho-completo}/src/{nome-projeto}.Api/{nome-projeto}.Api.csproj" package Microsoft.AspNetCore.OpenApi --version 10.0.5`
        - `dotnet add "{caminho-completo}/src/{nome-projeto}.Api/{nome-projeto}.Api.csproj" package Scalar.AspNetCore --version 2.14.3`
    - Exemplo para `Infrastructure.CrossCutting.Identity` (alinhando versões onde aplicável):
        - `dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.Identity/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj" package Microsoft.EntityFrameworkCore.Design --version 10.0.7`
        - `dotnet add "..." package Npgsql.EntityFrameworkCore.PostgreSQL --version 10.0.1`
        - `dotnet add "..." package Microsoft.Extensions.Configuration --version 10.0.7`
        - `dotnet add "..." package Microsoft.AspNetCore.Identity.EntityFrameworkCore --version 10.0.7`
        - `dotnet add "..." package Microsoft.AspNetCore.Authentication.JwtBearer --version 10.0.7`
        - `dotnet add "..." package Microsoft.AspNetCore.Identity.UI --version 10.0.7`
    - Em `Infrastructure.CrossCutting.IoC` e `Infrastructure.Data`, adicione `Microsoft.EntityFrameworkCore` e `Npgsql.EntityFrameworkCore.PostgreSQL` na versão 10.x. Remova duplicações e padronize versões com `dotnet list package --outdated`/`dotnet list package`.
    - Em `API`, adicione `Microsoft.AspNetCore.OpenApi` na versão 10.0.5, `Scalar.AspNetCore` na versão 2.14.3
    - Em `Infrastructure.CrossCutting.Identity`, adicione `Microsoft.EntityFrameworkCore.Design` na versão 10.0.7, `Npgsql.EntityFrameworkCore.PostgreSQL` na versão 10.0.1, `Microsoft.AspNetCore.Http.Abstractions` na versão 2.3.9, `Microsoft.Extensions.Configuration` na versão 10.0.7, `Microsoft.Extensions.Configuration.Json` na versão 10.0.7, `Microsoft.AspNetCore.Identity.EntityFrameworkCore` na versão 10.0.7, `System.IdentityModel.Tokens.Jwt` na versão 8.17.0, `Microsoft.AspNetCore.Authorization` na versão 8.17.0, `Microsoft.AspNetCore.Authentication.JwtBearer` na versão 10.0.7, `Microsoft.AspNetCore.Identity.UI` na versão 10.0.7, `Microsoft.AspNetCore.Authentication.JwtBearer` na versão 10.0.7, `Microsoft.AspNetCore.Authentication.Google` na versão 10.0.7
    - Em `Infrastructure.CrossCutting.IoC`, adicione `Microsoft.Extensions.DependencyInjection` na versão 10.0.0, `Microsoft.Extensions.Configuration` na versão 10.0.7, `Microsoft.Extensions.Configuration.Json` na versão 10.0.7, `Microsoft.EntityFrameworkCore` na versão 10.0.7, `Npgsql.EntityFrameworkCore.PostgreSQL` na versão 10.0.1, `Microsoft.Extensions.Diagnostics.HealthChecks` na versão 10.0.7, `Microsoft.Extensions.DependencyInjection` na versão 10.0.7, `Microsoft.Extensions.Configuration.Abstractions` na versão 10.0.7, `AspNetCore.HealthChecks.NpgSql` na versão 9.0.0
    - Em `Infrastructure.Data`, adicione `Microsoft.EntityFrameworkCore` na versão 10.0.7, `Npgsql.EntityFrameworkCore.PostgreSQL` na versão 10.0.1, `AspNetCore.HealthChecks.NpgSql` na versão 9.0.0
    - Em `Tests`, adicione `Microsoft.EntityFrameworkCore.InMemory` na versão 10.0.7, `Microsoft.Extensions.Configuration` na versão 10.0.7, `Microsoft.Extensions.Configuration.Json` na versão 10.0.7, `Microsoft.Extensions.DependencyInjection` na versão 10.0.7, `Moq` na versão 4.18.4

- Passo 4 - Criar a solução e adicionar os projetos
    - `dotnet new sln -n "{nome-projeto}" -o "{caminho-completo}"`
    - Adicionar projetos:
        - `dotnet sln "{caminho-completo}/{nome-projeto}.slnx" add "{caminho-completo}/src/{nome-projeto}.Api/{nome-projeto}.Api.csproj"`
        - Repita para os demais projetos (`.Application`, `.Domain`, `.Infrastructure.Data`, `.Infrastructure.CrossCutting.IoC`, `.Infrastructure.CrossCutting.Identity`, `.Tests`).
    - Observação: criar pastas (solution folders) normalmente é feito via IDE ou editando a `.slnx`; o `dotnet` CLI não expõe criação de solution folders diretamente.

- Passo 5 - Limpar código do `Program.cs` e remover arquivos de template
    - Remover o endpoint de exemplo `WeatherForecast` e a classe `WeatherForecast` do projeto de API.
    - Exemplos de remoção (PowerShell):
        - `Remove-Item -Path "{caminho-completo}/src/{nome-projeto}.Api/WeatherForecast.cs" -Force`
        - `Remove-Item -Path "{caminho-completo}/src/{nome-projeto}.Application/Class1.cs" -Force`

- Passo 6 - Criar a classe `ApiEndpoints` no projeto de API
    - Criar arquivo `ApiEndpoints.cs` em `src/{nome-projeto}.Api/Endpoints/ApiEndpoints/` com a classe estática e método de extensão. Exemplo:
        ```csharp
        public static class ApiEndpoints
        {
            public static void MapBookEndpoints(this IEndpointRouteBuilder app)
            {
                var grupo = app.MapGroup("/{nome-projeto}");
                // Map endpoints here
            }
        }
        ```

- Passo 7 - Criar `ApplicationDbContext` (arquivo dentro de `Infrastructure.Data`)
    - Não crie um novo projeto só para o `DbContext`. Em vez disso, adicione um arquivo `ApplicationDbContext.cs` em `src/{nome-projeto}.Infrastructure.Data/Data/` com:
        ```csharp
        public class ApplicationDbContext : DbContext
        {
            public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }
            // DbSets here
        }
        ```

- Passo 8 - Criar `PostgreSqlExtensions` em `Infrastructure.CrossCutting.IoC` (arquivo)
    - Adicione `Extensions/PostgreSqlExtensions.cs` no projeto `Infrastructure.CrossCutting.IoC` com uma extensão para `IServiceCollection` e para `IHealthChecksBuilder`. Exemplo:
        ```csharp
        public static class PostgreSqlExtensions
        {
            private const string ConnectionString = "DefaultConnection";
            public static IServiceCollection AddPostgreSqlConfig(this IServiceCollection services, IConfiguration configuration)
            {
                services.AddDbContext<ApplicationDbContext>(options =>
                    options.UseNpgsql(configuration.GetConnectionString(ConnectionString)));
                return services;
            }

            public static IHealthChecksBuilder AddPostgreSqlHealth(this IHealthChecksBuilder builder, IConfiguration configuration)
            {
                return builder.AddNpgSql(configuration.GetConnectionString(ConnectionString)!);
            }
        }
        ```
    - Chamar em `Program.cs`:
        ```csharp
        builder.Services.AddPostgreSqlConfig(builder.Configuration);
        builder.Services.AddHealthChecks().AddPostgreSqlHealth(builder.Configuration);
        ```

- Passo 9 - Criar `appsettings.json` e arquivos por ambiente
    - `appsettings.json` mínimo:
        ```json
        {
          "Logging": { "LogLevel": { "Default": "Information", "Microsoft.AspNetCore": "Warning" } },
          "AllowedHosts": "*",
          "ConnectionStrings": { "DefaultConnection": "{string-de-conexao}" }
        }
        ```
    - Criar `appsettings.Development.json`, `appsettings.Homologation.json` e `appsettings.Production.json` com a mesma estrutura e ajustar `ConnectionStrings` conforme ambiente.

Observações finais:
- Renumerados os passos e removida a instrução de criar projetos extras apenas para classes (usar arquivos dentro dos projetos existentes).
- Corrigidos exemplos `dotnet new` para usar `-o` e incluídas instruções explícitas `dotnet add reference` e `dotnet add package` com exemplos.
- Recomenda-se revisar e padronizar as versões NuGet (usar `dotnet list package` e atualizar para 10.x onde aplicável) e testar as APIs de HealthChecks/Extensions no ambiente de desenvolvimento.
