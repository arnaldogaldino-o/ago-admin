# Pacotes NuGet - .NET 10 + EF Core 10

# Regra de compatibilidade (OBRIGATÓRIO)
- .NET 10 exige pacotes EF Core com maior versão **10.x.x**
- Maior versão do EF Core deve ser igual ao target framework (`net10.0`)

INSTRUÇÕES OBRIGATÓRIAS: Execute todos os comandos listados abaixo, sem pular passos, para criar a solução, os projetos, as classes e as referências. Os caminhos de exemplo usam a pasta `server/src` (ajuste `{caminho-completo}` conforme necessário).

# Comandos de criação do projeto

```bash
mkdir {caminho-completo}/api/{nome-projeto}
cd {caminho-completo}/api/{nome-projeto}
```

# Cria a Solução na caminho-completo (OBRIGATÓRIO)
```bash
dotnet new sln -n {nome-projeto} -o "{caminho-completo}/src"
```

# Cria o projeto da api (Service) (OBRIGATÓRIO)
```bash
dotnet new webapi -n {nome-projeto}.Api -f net10.0 -o "{caminho-completo}/src/{nome-projeto}.Api"

dotnet sln "{caminho-completo}/src/{nome-projeto}.slnx" add "{caminho-completo}/src/{nome-projeto}.Api/{nome-projeto}.Api.csproj"

copy "{caminho-completo}/src/{nome-projeto}.Api/appsettings.json" "{caminho-completo}/src/{nome-projeto}.Api/appsettings.Development.json"

dotnet add "{caminho-completo}/src/{nome-projeto}.Api/{nome-projeto}.Api.csproj" package Microsoft.AspNetCore.OpenApi 10.0.5

dotnet add "{caminho-completo}/src/{nome-projeto}.Api/{nome-projeto}.Api.csproj" package Scalar.AspNetCore 2.14.3
```

# Cria o projeto lib de aplicação (Application) (OBRIGATÓRIO)
```bash
dotnet new classlib -n {nome-projeto}.Application -o "{caminho-completo}/src/{nome-projeto}.Application"

dotnet sln "{caminho-completo}/src/{nome-projeto}.slnx" add "{caminho-completo}/src/{nome-projeto}.Application/{nome-projeto}.Application.csproj"
```

# Cria o projeto lib de dominio (Domain) (OBRIGATÓRIO)
```bash
dotnet new classlib -n {nome-projeto}.Domain -o "{caminho-completo}/src/{nome-projeto}.Domain"

dotnet sln "{caminho-completo}/src/{nome-projeto}.slnx" add "{caminho-completo}/src/{nome-projeto}.Domain/{nome-projeto}.Domain.csproj"
```
- no arquivo launchSettings.json alterar o valor da variável ASPNETCORE_ENVIRONMENT para Development

- no arquivo "{caminho-completo}/api/{nome-projeto}/src/{nome-projeto}.Api/appsettings.Development.json" adicionar:
```json
  "ConnectionStrings": {
    "DefaultConnection": "{DefaultConnection}"
  }
```

# Cria o projeto lib de infraestrutura data (Infrastructure-Data) (OBRIGATÓRIO)
```bash
dotnet new classlib -n {nome-projeto}.Infrastructure.Data -o "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data"

dotnet sln "{caminho-completo}/src/{nome-projeto}.slnx" add "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data/{nome-projeto}.Infrastructure.Data.csproj"

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data/{nome-projeto}.Infrastructure.Data.csproj" package Microsoft.EntityFrameworkCore 10.0.7

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data/{nome-projeto}.Infrastructure.Data.csproj" package Microsoft.EntityFrameworkCore.Design 10.0.7

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data/{nome-projeto}.Infrastructure.Data.csproj" package Dapper 2.1.72

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data/{nome-projeto}.Infrastructure.Data.csproj" package Microsoft.EntityFrameworkCore.Tools 10.0.7

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data/{nome-projeto}.Infrastructure.Data.csproj" package Npgsql.EntityFrameworkCore.PostgreSQL 10.0.1

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data/{nome-projeto}.Infrastructure.Data.csproj" package AspNetCore.HealthChecks.NpgSql 9.0.0
```

# Cria o projeto lib de infraestrutura CrossCutting IoC(Infrastructure-CrossCutting-IoC) (OBRIGATÓRIO)
```bash
dotnet new classlib -n {nome-projeto}.Infrastructure.CrossCutting.IoC -o "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.IoC"

dotnet sln "{caminho-completo}/src/{nome-projeto}.slnx" add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.IoC/{nome-projeto}.Infrastructure.CrossCutting.IoC.csproj"

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.IoC/{nome-projeto}.Infrastructure.CrossCutting.IoC.csproj" package Microsoft.Extensions.Diagnostics.HealthChecks 10.0.7

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.IoC/{nome-projeto}.Infrastructure.CrossCutting.IoC.csproj" package Microsoft.Extensions.DependencyInjection 10.0.7

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.IoC/{nome-projeto}.Infrastructure.CrossCutting.IoC.csproj" package Microsoft.Extensions.Configuration.Abstractions 10.0.7

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.IoC/{nome-projeto}.Infrastructure.CrossCutting.IoC.csproj" package Microsoft.Extensions.Configuration.Abstractions 10.0.7

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.IoC/{nome-projeto}.Infrastructure.CrossCutting.IoC.csproj" package AspNetCore.HealthChecks.NpgSql 9.0.0

```

# Cria o projeto lib de infraestrutura CrossCutting Identity(Infrastructure-CrossCutting-Identity) (OBRIGATÓRIO)
```bash
dotnet new classlib -n {nome-projeto}.Infrastructure.CrossCutting.Identity -o "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.Identity"

dotnet sln "{caminho-completo}/src/{nome-projeto}.slnx" add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.Identity/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj"

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.Identity/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj" package Microsoft.Extensions.Configuration 10.0.7

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.Identity/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj" package Microsoft.Extensions.Configuration.Json 10.0.7

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.Identity/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj" package Microsoft.AspNetCore.Identity.EntityFrameworkCore 10.0.7

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.Identity/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj" package System.IdentityModel.Tokens.Jwt 8.17.0

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.Identity/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj" package Microsoft.AspNetCore.Authorization 8.17.0

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.Identity/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj" package Microsoft.AspNetCore.Authentication.JwtBearer 10.0.7

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.Identity/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj" package Microsoft.AspNetCore.Identity.UI 10.0.7

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.Identity/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj" package Microsoft.AspNetCore.Authentication.JwtBearer 10.0.7

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.Identity/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj" package Microsoft.AspNetCore.Authentication.Google 10.0.7

```

# Cria o projeto de testes (OBRIGATÓRIO)
```bash
dotnet new xunit -n {nome-projeto}.Tests -o "{caminho-completo}/src/{nome-projeto}.Tests"

dotnet sln "{caminho-completo}/src/{nome-projeto}.slnx" add "{caminho-completo}/src/{nome-projeto}.Tests/{nome-projeto}.Tests.csproj"
```

# Adiciona as referencias nos projetos (OBRIGATÓRIO)
```bash

dotnet add "{caminho-completo}/src/{nome-projeto}.Api/{nome-projeto}.Api.csproj" reference "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.Identity/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj"

dotnet add "{caminho-completo}/src/{nome-projeto}.Api/{nome-projeto}.Api.csproj" reference "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.IoC/{nome-projeto}.Infrastructure.CrossCutting.IoC.csproj"

dotnet add "{caminho-completo}/src/{nome-projeto}.Api/{nome-projeto}.Api.csproj" reference "{caminho-completo}/src/{nome-projeto}.Application/{nome-projeto}.Application.csproj"

dotnet add "{caminho-completo}/src/{nome-projeto}.Application/{nome-projeto}.Application.csproj" reference "{caminho-completo}/src/{nome-projeto}.Domain/{nome-projeto}.Domain.csproj"

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.IoC/{nome-projeto}.Infrastructure.CrossCutting.IoC.csproj" reference "{caminho-completo}/src/{nome-projeto}.Application/{nome-projeto}.Application.csproj"

dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.IoC/{nome-projeto}.Infrastructure.CrossCutting.IoC.csproj" reference "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data/{nome-projeto}.Infrastructure.Data.csproj"

dotnet add "{caminho-completo}/src/{nome-projeto}.Application/{nome-projeto}.Application.csproj" reference "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data/{nome-projeto}.Infrastructure.Data.csproj"

dotnet add "{caminho-completo}/src/{nome-projeto}.Application/{nome-projeto}.Application.csproj" reference "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.IoC/{nome-projeto}.Infrastructure.CrossCutting.IoC.csproj"

dotnet add "{caminho-completo}/src/{nome-projeto}.Application/{nome-projeto}.Application.csproj" reference "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.Identity/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj"

dotnet sln "{caminho-completo}/src/{nome-projeto}.slnx" add "{caminho-completo}/src/{nome-projeto}.Tests/{nome-projeto}.Tests.csproj"

dotnet add "{caminho-completo}/src/{nome-projeto}.Tests/{nome-projeto}.Tests.csproj" reference "{caminho-completo}/src/{nome-projeto}.Api/{nome-projeto}.Api.csproj"

dotnet add "{caminho-completo}/src/{nome-projeto}.Tests/{nome-projeto}.Tests.csproj" reference "{caminho-completo}/src/{nome-projeto}.Application/{nome-projeto}.Application.csproj"

dotnet add "{caminho-completo}/src/{nome-projeto}.Tests/{nome-projeto}.Tests.csproj" reference "{caminho-completo}/src/{nome-projeto}.Domain/{nome-projeto}.Domain.csproj"

dotnet add "{caminho-completo}/src/{nome-projeto}.Tests/{nome-projeto}.Tests.csproj" reference "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data/{nome-projeto}.Infrastructure.Data.csproj"

dotnet add "{caminho-completo}/src/{nome-projeto}.Tests/{nome-projeto}.Tests.csproj" reference "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.IoC/{nome-projeto}.Infrastructure.CrossCutting.IoC.csproj"

dotnet add "{caminho-completo}/src/{nome-projeto}.Tests/{nome-projeto}.Tests.csproj" reference "{caminho-completo}/src/{nome-projeto}.Infrastructure.CrossCutting.Identity/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj"
```

# Corrigir o arquivo "{caminho-completo}/src/{nome-projeto}.slnx" (OBRIGATÓRIO)
INSTRUÇÃO OBRIGATÓRIA: Atualize o arquivo de solução para refletir a organização de pastas abaixo. Não pule este passo — a solução deve ficar exatamente com a estrutura indicada.
Para que fique com a seguinte organização:

<Solution>
  <Folder Name="/1 - Service/">
    <Project Path="{nome-projeto}.Api/{nome-projeto}.Api.csproj" />
  </Folder>

  <Folder Name="/2 - Application/">
    <Project Path="{nome-projeto}.Application/{nome-projeto}.Application.csproj" />
  </Folder>

  <Folder Name="/4 - Domain/">
    <Project Path="{nome-projeto}.Domain/{nome-projeto}.Domain.csproj" />
  </Folder>

  <Folder Name="/5 - Infrastructure/5.1 - Data/">
      <Project Path="{nome-projeto}.Infrastructure.Data/{nome-projeto}.Infrastructure.Data.csproj" />
  </Folder>
  <Folder Name="/5 - Infrastructure/5.2 CrossCutting/">
      <Project Path="{nome-projeto}.Infrastructure.CrossCutting.IoC/{nome-projeto}.Infrastructure.CrossCutting.IoC.csproj" />
      <Project Path="{nome-projeto}.Infrastructure.CrossCutting.Identity/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj" />
  </Folder>

  <Folder Name="/6 - Tests/">
    <Project Path="{nome-projeto}.Tests/{nome-projeto}.Tests.csproj" />
  </Folder>
</Solution>
