---
name: criar-api-aspnet
user-invocable: true
description: "Skill para scaffolding criar um projeto ASP.NET Core Web API completo do zero para qualquer entidade, usando Minimal APIs, EF Core 10 com PostgreSQL e Scalar. User sempre que o usuário pedir para criar uma API ASP.NET, scaffolding ou gerar uma Web API com .NET, ASP.NET, Minimal APIs, EF Core"
allowed-tools: Bash, Writer, Read
---

# Skill: Gerar API ASP.NET Core Web API  (Genérica)

## Passo 0 - Ler referências e interpretar $ARGUMENTS
Leia os dois arquivos de referência antes de qualquer ação:

- → [references/package.md](./references/packages.md)

### Argumentos obrigatórios:
- nome-projeto - Nome da Api
- caminho-completo - Pasta para criar a API (o nome do projeto será o último segmento do caminho)
- string-de-conexao - DefaultConnection para PostgreSQL usando o nome do projeto como database

### Requisito de Framework
- Todos os projetos gerados pelo scaffolding devem usar obrigatoriamente o TargetFramework `net10.0`.
- A skill passa a forçar a criação de `.csproj` com `<TargetFramework>net10.0</TargetFramework>` e exemplos/trechos devem refletir esse valor.

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

## Passo 2 - Limpar código de exemplo do template
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

- Remover Class1.cs dos projetos de classlib (Application, Domain, Infrastructure.Data,
Infrastructure.CrossCutting.IoC, Infrastructure.CrossCutting.Identity) e do projeto de testes (Tests)

- Remover a classe UnitTest1.cs do projeto de testes (AgoAdmin.Tests)

## Passo 3 - Criar a classe ApiEndpoints

- Criar a pasta `ApiEndpoints` dentro do projeto da API
```bash
mkdir "{caminho-completo}/src/{nome-projeto}.Api/Endpoints/ApiEndpoints"
```

- Refatorar a classe ApiEndpoints.cs
mudar o modificador da classe para static 

- Criar o construtor da seguinte forma:
```csharp
    public static void MapBookEndpoints(this IEndpointRouteBuilder app)
    {
        var {nome-projeto}Group = app.MapGroup("{nome-projeto}");

        // Map endpoints here
    }
```

## Passo 4 - Criar a class ApplicationDbContext na pasta Data do projeto de infraestrutura data
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

## Passo 5 - Criar PostgreSqlExtensions na pasta Extensions do projeto de infraestrutura crosscutting IoC
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

- Criar a string de conexão no `appsettings.json` da API usando o valor de `{string-de-conexao}` dos argumentos
```json
  "ConnectionStrings": {
    "DefaultConnection": "{string-de-conexao}"
  }
```

- Adicionar a chamada para o método de extensão AddPostgreSqlConfig no `Program.cs` da API
```csharp
builder.Services.AddPostgreSqlConfig(builder.Configuration)
                .AddPostgreSqlHealth(builder.Configuration);
```