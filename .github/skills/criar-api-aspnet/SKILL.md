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
    - para criar um projeto deve usar o comando `dotnet new` com os seguintes parâmetros:
        - API: `dotnet new webapi -n "{nome-projeto}.Api" -o "{caminho-completo}/src/{nome-projeto}.Api"`
        - Application: `dotnet new classlib -n "{nome-projeto}.Application" -o "{caminho-completo}/src/{nome-projeto}.Application"`
        - Domain: `dotnet new classlib -n "{nome-projeto}.Domain" -o "{caminho-completo}/src/{nome-projeto}.Domain"`
        - Infrastructure.Data: `dotnet new classlib -n "{nome-projeto}.Infrastructure.Data" -o "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data"`
        - Infrastructure.CrossCutting.IoC: `dotnet new classlib -n "{nome-projeto}.Infrastructure.CrossCutting.IoC" -o "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.IoC"`
        - Infrastructure.CrossCutting.Identity: `dotnet new classlib -n "{nome-projeto}.Infrastructure.CrossCutting.Identity" -o "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.Identity"`
        - Tests: `dotnet new xunit -n "{nome-projeto}.Tests" -o "{caminho-completo}/src/{nome-projeto}.Tests"`

- Passo 2 - Referenciar os projetos
    - Para referenciar os projetos entre si, usar o comando `dotnet add reference` com os seguintes parâmetros:
        - API deve referenciar Application, Infrastructure.Data, Infrastructure.CrossCutting.IoC, Infrastructure.CrossCutting.Identity
        - Application deve referenciar Domain, Infrastructure.Data
        - Infrastructure.Data deve referenciar Domain    
        - Infrastructure.CrossCutting.IoC deve referenciar Application, Infrastructure.Data, Domain
        - Infrastructure.CrossCutting.Identity

- Passo 3 - Adicionar os pacotes NuGet necessários
    - Para adicionar os pacotes NuGet necessários, usar o comando `dotnet add package` com os seguintes parâmetros:
        - No projeto de API, adicionar os pacotes:
            - Microsoft.AspNetCore.OpenApi 10.0.5
            - Scalar.AspNetCore 2.14.3
        - No projeto de Infrastructure.CrossCutting.Identity, adicionar os pacotes:
            - Microsoft.EntityFrameworkCore.Design 10.0.7
            - Npgsql.EntityFrameworkCore.PostgreSQL 10.0.1
            - Microsoft.AspNetCore.Http.Abstractions 2.3.9
            - Microsoft.Extensions.Configuration 10.0.7
            - Microsoft.Extensions.Configuration.Json 10.0.7
            - Microsoft.AspNetCore.Identity.EntityFrameworkCore 10.0.7
            - System.IdentityModel.Tokens.Jwt 8.17.0
            - Microsoft.AspNetCore.Authorization 8.17.0
            - Microsoft.AspNetCore.Authentication.JwtBearer 10.0.7
            - Microsoft.AspNetCore.Identity.UI 10.0.7
            - Microsoft.AspNetCore.Authentication.JwtBearer 10.0.7
            - Microsoft.AspNetCore.Authentication.Google 10.0.7
        - No projeto de Infrastructure.CrossCutting.IoC, adicionar os pacotes:
            - Microsoft.Extensions.DependencyInjection 10.0.0
            - Microsoft.Extensions.Configuration 10.0.7
            - Microsoft.Extensions.Configuration.Json 10.0.7
            - Microsoft.EntityFrameworkCore 10.0.7
            - Npgsql.EntityFrameworkCore.PostgreSQL 10.0.1
            - Microsoft.Extensions.Diagnostics.HealthChecks 10.0.7
            - Microsoft.Extensions.DependencyInjection 10.0.7
            - Microsoft.Extensions.Configuration.Abstractions 10.0.7
            - AspNetCore.HealthChecks.NpgSql 9.0.0
        - No projeto Infrastructure.Data, adicionar os pacotes:
            - Microsoft.EntityFrameworkCore 10.0.7
            - Npgsql.EntityFrameworkCore.PostgreSQL 10.0.1
            - AspNetCore.HealthChecks.NpgSql 9.0.0
        - No projeto de Tests, adicionar os pacotes:
            - Microsoft.EntityFrameworkCore.InMemory 10.0.7
            - Microsoft.Extensions.Configuration 10.0.7
            - Microsoft.Extensions.Configuration.Json 10.0.7
            - Microsoft.Extensions.DependencyInjection 10.0.7
            - Moq 4.18.4

- Passo 5 - Criar a solução e adicionar os projetos
    - Criar a solução usando o comando `dotnet new sln -n "{nome-projeto}" -o "{caminho-completo}"`
    - Adicionar os projetos à solução usando o comando `dotnet sln add` com os seguintes parâmetros:
        - `dotnet sln add "{caminho-completo}/src/{nome-projeto}.Api/{nome-projeto}.Api.csproj"`
        - `dotnet sln add "{caminho-completo}/src/{nome-projeto}.Application/{nome-projeto}.Application.csproj"`
        - `dotnet sln add "{caminho-completo}/src/{nome-projeto}.Domain/{nome-projeto}.Domain.csproj"`
        - `dotnet sln add "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data/{nome-projeto}.Infrastructure.Data.csproj"`
        - `dotnet sln add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.IoC/{nome-projeto}.Infrastructure.CrossCutting.IoC.csproj"`
        - `dotnet sln add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.Identity/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj"`
        - `dotnet sln add "{caminho-completo}/src/{nome-projeto}.Tests/{nome-projeto}.Tests.csproj"`
    - Organizar os projetos na solução usando pastas para cada camada (Api, Application, Domain, Infrastructure, Tests):
        - Pasta "1 - Services" para o projeto de API
        - Pasta "2 - Application" para o projeto de Application
        - Pasta "3 - Domain" para o projeto de Domain
        - Pasta "4 - Infrastructure/4.1 - Data" para o projeto de Infrastructure.Data
        - Pasta "4 - Infrastructure/4.2 - CrossCutting" para os projetos de Infrastructure.CrossCutting.IoC, Infrastructure.CrossCutting.Identity
        - Pasta "5 - Tests" para o projeto de Tests
        - Exemplo do arquivo de solução (.slnx) organizado:
            ```xml
            <Solution>
            <Folder Name="/1 - Service/">
                <Project Path="{nome-projeto}.Api/{nome-projeto}.Api.csproj" />
            </Folder>

            <Folder Name="/2 - Application/">
                <Project Path="{nome-projeto}.Application/{nome-projeto}.Application.csproj" />
            </Folder>

            <Folder Name="/3 - Domain/">
                <Project Path="{nome-projeto}.Domain/{nome-projeto}.Domain.csproj" />
            </Folder>

            <Folder Name="/4 - Infrastructure/4.1 - Data/">
                <Project Path="{nome-projeto}.Infrastructure.Data/{nome-projeto}.Infrastructure.Data.csproj" />
            </Folder>
            <Folder Name="/4 - Infrastructure/4.2 CrossCutting/">
                <Project Path="{nome-projeto}.Infrastructure.CrossCutting.IoC/{nome-projeto}.Infrastructure.CrossCutting.IoC.csproj" />
                <Project Path="{nome-projeto}.Infrastructure.CrossCutting.Identity/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj" />
            </Folder>

            <Folder Name="/5 - Tests/">
                <Project Path="{nome-projeto}.Tests/{nome-projeto}.Tests.csproj" />
            </Folder>
            </Solution>
            ```

- Passo 5 - Limpar código do Program.cs e remover arquivos desnecessários no projeto de API
    - Remover o endpoint WeatherForecast do `Program.cs`
        ```csharp
        var summaries = new[]
        {
            "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
        };

        app.MapGet("/weatherforecast", () =>
        {
            var forecast =  Enumerable.Range(1, 5).Select(index =>
                new WeatherForecast
                (
                    DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
                    Random.Shared.Next(-20, 55),
                    summaries[Random.Shared.Next(summaries.Length)]
                ))
                .ToArray();
            return forecast;
        })
        .WithName("GetWeatherForecast");
        ```
    - Remover a classe `WeatherForecast` do template
        ```csharp
        record WeatherForecast(DateOnly Date, int TemperatureC, string? Summary)
        {
            public int TemperatureF => 32 + (int)(TemperatureC / 0.5556);
        }
        ```

    - Remover Class1.cs dos projetos Application, Domain, Infrastructure.Data,
    Infrastructure.CrossCutting.IoC, Infrastructure.CrossCutting.Identity e Tests

    - Remover a classe UnitTest1.cs do projeto de testes (AgoAdmin.Tests)

- Passo 6 - Criar a classe ApiEndpoints no projeto de API para organizar os endpoints da aplicação
    - Criar a classe ApiEndpoints.cs na pasta ApiEndpoints do projeto de API
    - Refatorar a classe ApiEndpoints.cs mudar o modificador da classe para static 
    - Criar o construtor da seguinte forma:
        ```csharp
            public static void MapBookEndpoints(this IEndpointRouteBuilder app)
            {
                var {nome-projeto}Group = app.MapGroup("{nome-projeto}");

                // Map endpoints here
            }
        ```

- Passo 7 - Criar a class ApplicationDbContext na pasta Data do projeto de infraestrutura data
    - Criar a pasta Data dentro do projeto de infraestrutura data
        ```bash 
        dotnet new classlib -n "{nome-projeto}.Infrastructure.Data.Context.ApplicationDbContext" -p "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data/Context"
        ```

    - Refatorar a classe ApplicationDbContext para herdar de DbContext e adicionar o construtor com DbContextOptions
        ```csharp
        public class ApplicationDbContext : DbContext
        {
            public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
            {
            }

            // DbSets here
        }
        ```

- Passo 8 - Criar PostgreSqlExtensions na pasta Extensions do projeto de infraestrutura crosscutting IoC
    - Criar a pasta Extensions dentro do projeto de infraestrutura crosscutting IoC
        ```bash
        dotnet new classlib -n "{nome-projeto}.Infrastructure.CrossCutting.IoC.Extensions.PostgreSqlExtensions" -p "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.IoC/Extensions"
        ```

    - Refatorar a classe PostgreSqlExtensions para criar um método de extensão que adicione o DbContext ao container de injeção de dependências
        ```csharp
        public static class PostgreSqlExtensions
        {
            private const string ConnectionString = "DefaultConnection";
            public static IServiceCollection AddPostgreSqlConfig(this IServiceCollection services,
                IConfiguration configuration)
            {
                services.AddDbContext<ApplicationDbContext>(
                    options => options.UseNpgsql(configuration.GetConnectionString(ConnectionString)));

                return services;
            }

            public static IHealthChecksBuilder AddPostgreSqlHealth(this IHealthChecksBuilder services,
                IConfiguration configuration)
            {
                services.AddNpgSql(configuration.GetConnectionString(ConnectionString)!);

                return services;
            }
        }
        ```

    - Adicionar a chamada para o método de extensão AddPostgreSqlConfig no `Program.cs` no projeto da API
        ```csharp
        builder.Services.AddPostgreSqlConfig(builder.Configuration)
                        .AddPostgreSqlHealth(builder.Configuration);
        ```

- Passo 9 - Criar o appsettings.json para os ambientes de desenvolvimento, homologação e produção
    - Criar o arquivo `appsettings.json` na pasta do projeto de API com a seguinte estrutura:
        ```json
        {
        "Logging": {
            "LogLevel": {
            "Default": "Information",
            "Microsoft.AspNetCore": "Warning"
            }
        },
        "AllowedHosts": "*"
        }
        ```

    - Criar os arquivos `appsettings.Development.json`, `appsettings.Homologation.json` e `appsettings.Production.json` com a mesma estrutura do `appsettings.json` e ajustar a string de conexão para cada ambiente, se necessário.

    - Criar a string de conexão nos arquivos appsettings.<ambiente>.json da API usando o valor de `{string-de-conexao}` dos argumentos
        ```json
        "ConnectionStrings": {
            "DefaultConnection": "{string-de-conexao}"
        }
        ```
