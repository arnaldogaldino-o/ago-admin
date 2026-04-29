# Sprint 1

## Objetivo da Sprint: Implementar no projeto {nome-projeto} o ASP.NET Core Identity para gerenciar autenticação e autorização nas API do projeto {nome-projeto}

# Escopo: Implementar o ASP.NET Core Identity no projeto {nome-projeto}

# Tarefas:

# Criar o Context
- No projeto {nome-projeto}.Infrastructure.CrossCutting.Identity criar a classe {nome-projeto}.Infrastructure.CrossCutting.Identity.Data.{nome-projeto}IdentityContext
- A classe deve herdar IdentityDbContext
- O construtor da classe deve ser adequado para 
```csharp
public {nome-projeto}IdentityContext(DbContextOptions<{nome-projeto}IdentityContext> options) : base(options) { }
```
- dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj" package Microsoft.AspNetCore.Identity.EntityFrameworkCore 10.0.7
- dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj" package Microsoft.EntityFrameworkCore.Design 10.0.7
- dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj" package Npgsql.EntityFrameworkCore.PostgreSQL 10.0.1
- dotnet add "{caminho-completo}/src/{nome-projeto}.Infrastructure.Data/{nome-projeto}.Infrastructure.CrossCutting.Identity.csproj" package Microsoft.AspNetCore.Http.Abstractions 2.3.9

- Criar uma nova classe Data.{nome-projeto}IdentityContextFactory
- Refatorar a classe Data.{nome-projeto}IdentityContextFactory:
```csharp
    public class {nome-projeto}IdentityContextFactory : IDesignTimeDbContextFactory<{nome-projeto}IdentityContext>
    {
        public {nome-projeto}IdentityContext CreateDbContext(string[] args)
        {
            var environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Development";

            var configuration = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json", optional: true)
                .AddJsonFile($"appsettings.{environment}.json", optional: true)
                .Build();

            var builder = new DbContextOptionsBuilder<{nome-projeto}IdentityContext>();

            var connectionString = configuration.GetConnectionString("DefaultConnection");
            builder.UseNpgsql(configuration.GetConnectionString(ConnectionString));

            return new {nome-projeto}IdentityContext(builder.Options);
        }
    }
```

# Criar as Classes
- Criar a classe {nome-projeto}.Infrastructure.CrossCutting.Identity.Extensions.ClaimsPrincipalExtensions
- Refatorar a classe usando como exemplo o script ClaimsPrincipalExtensions.cs

- Criar a classe interface {nome-projeto}.Infrastructure.CrossCutting.Identity.User.IAspNetUser
- Refatorar a classe usando como exemplo o script IAspNetUser.cs

- Criar a classe {nome-projeto}.Infrastructure.CrossCutting.Identity.User.AspNetUser
- Refatorar a classe usando como exemplo o script AspNetUser.cs
- incluir o using Microsoft.AspNetCore.Http;
- incluir o using System.Security.Claims;

- Criar a classe {nome-projeto}.Infrastructure.CrossCutting.Identity.Configuration.AspNetIdentityConfig
- Refatorar a classe usando como exemplo o script AspNetIdentityConfig.cs

- Criar a classe {nome-projeto}.Infrastructure.CrossCutting.Identity.API.AppJwtSettings
- Refatorar a classe usando como exemplo o script AppJwtSettings.cs

- Criar a classe {nome-projeto}.Infrastructure.CrossCutting.Identity.API.JwtBuilder
- Refatorar a classe usando como exemplo o script JwtBuilder.cs

- Criar a classe {nome-projeto}.Infrastructure.CrossCutting.Identity.Authorization.CustomAuthorizationValidation
- Refatorar a classe usando como exemplo o script CustomAuthorizationValidation.cs

- Criar a classe {nome-projeto}.Infrastructure.CrossCutting.Identity.Authorization.CustomAuthorizeAttribute
- Refatorar a classe usando como exemplo o script CustomAuthorizeAttribute.cs

- Criar as classe {nome-projeto}.Infrastructure.CrossCutting.Identity.Models.LoginUser, {nome-projeto}.Infrastructure.CrossCutting.Identity.Models.RegisterUser, {nome-projeto}.Infrastructure.CrossCutting.Identity.Models.UserClaim, {nome-projeto}.Infrastructure.CrossCutting.Identity.Models.UserResponse, {nome-projeto}.Infrastructure.CrossCutting.Identity.Models.UserToken
- Refatorar a classe usando como exemplo os scripts\Models

# Configura o Program.cs
- using {nome-projeto}.Api.Endpoints.ApiEndpoints
- Implementar na classe:
```csharp
builder.AddApiConfiguration()                   // Api Configurations
       .AddDatabaseConfiguration()              // Setting DBContexts
       .AddApiIdentityConfiguration()           // ASP.NET Identity Settings & JWT
       .AddSwaggerConfiguration()               // Swagger Config
       .AddDependencyInjectionConfiguration();  // DotNet Native DI Abstraction

app.UseHttpsRedirection()
    .UseCors(c =>
    {
        c.AllowAnyHeader();
        c.AllowAnyMethod();
        c.AllowAnyOrigin();
    })
    .UseAuthentication()
    .UseAuthorization();

app.MapIdentityApi<IdentityUser>();
```
### Gerar a dotnet migration
- Gerar a migration do projeto {nome-projeto}.Infrastructure.CrossCutting.Identity com o nome initial_identity

### Criar os Endpoints
- Criar o grupo de endpoint Account no projeto {nome-projeto}.Api
- Neste grupo implementar o método PostRegisterAsync como estático que retorna Task<IResult>
- Ele recebe como parametro RegisterUser registerUser, UserManager<IdentityUser> userManager, AppJwtSettings appJwtSettings, CancellationToken cancellationToken
```csharp
public static async Task<IResult> PostRegisterAsync(
             RegisterUser registerUser,
             UserManager<IdentityUser> userManager,
            AppJwtSettings appJwtSettings,
            CancellationToken cancellationToken)
    {
        var user = new IdentityUser
        {
            UserName = registerUser.Email,
            Email = registerUser.Email,
            EmailConfirmed = true
        };

        var result = await userManager.CreateAsync(user, registerUser.Password);

        if (result.Succeeded)
        {
            return Results.Ok(GetFullJwt(user.Email, userManager, appJwtSettings));
        }

        return Results.NotFound();
    }
```

- Criar o método GetFullJwt recebe como paramentro string email, UserManager<IdentityUser> userManager, AppJwtSettings appJwtSettings
```csharp
        private string GetFullJwt(string email
            UserManager<IdentityUser> userManager, AppJwtSettings appJwtSettings)
        {
            return new JwtBuilder()
                .WithUserManager(userManager)
                .WithJwtSettings(appJwtSettings)
                .WithEmail(email)
                .WithJwtClaims()
                .WithUserClaims()
                .WithUserRoles()
                .BuildToken();
        }
```
- Implementa o accountGroup.MapPost("new", PostRegisterAsync).WithName(nameof(PostRegisterAsync));

- Cria o método PostLoginAsync
```csharp
public static async Task<IResult> PostLoginAsync(
             LoginUser loginUser,
             UserManager<IdentityUser> userManager,
            AppJwtSettings appJwtSettings,
            CancellationToken cancellationToken)
    {
        var result = await signInManager.PasswordSignInAsync(loginUser.Email, loginUser.Password, false, true);

        if (result.Succeeded)
        {
            var fullJwt = GetFullJwt(loginUser.Email, userManager, appJwtSettings);
            return CustomResponse(fullJwt);
        }

        if (result.IsLockedOut)
        {
            return Results.BadRequest("This user is temporarily blocked");
        }

        return Results.BadRequest("Incorrect user or password");
    }
```

- Implementa o accountGroup.MapPost("enter", PostLoginAsync).WithName(nameof(PostLoginAsync));

### Configurar o AppSettings
```
  "AllowedHosts": "*",
  "AppSettings": {
    "SecretKey": "fmFGn5agHZkuG2N0e1zaEJIQtGVoNN5P",
    "Expiration": 2,
    "Issuer": "{nome-projeto}Dev",
    "Audience": "https://localhost"
  }
```
## Critérios de aceite:
