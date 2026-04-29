param(
    [string]$ProjectName = "AgoAdmin",
    [string]$BasePath = "C:\_prj\ago-admin\server",
    [string]$ConnectionString = "Host=localhost;port=5432;Database=AgoAdmin;Username=postgres;Password=password;Include Error Detail=true"
)

# Allow overriding parameters via environment variables (used by the skill invoker)
# Environment variables (preferred names): NOME_PROJETO, CAMINHO_COMPLETO, STRING_DE_CONEXAO
if (-not $PSBoundParameters.ContainsKey('ProjectName') -and $env:NOME_PROJETO) {
    $ProjectName = $env:NOME_PROJETO
}
if (-not $PSBoundParameters.ContainsKey('BasePath') -and $env:CAMINHO_COMPLETO) {
    $BasePath = $env:CAMINHO_COMPLETO
}
if (-not $PSBoundParameters.ContainsKey('ConnectionString') -and $env:STRING_DE_CONEXAO) {
    $ConnectionString = $env:STRING_DE_CONEXAO
}

# Sanitize project name to be a valid C# identifier / folder name
$safe = ($ProjectName -replace '[^A-Za-z0-9_]','')
if ([string]::IsNullOrWhiteSpace($safe)) {
    Write-Error "Invalid ProjectName after sanitization. Use only letters, digits or underscore."
    exit 1
}
if ($safe -match '^[0-9]') { $safe = "P$safe" }
if ($safe -ne $ProjectName) { Write-Host "Project name sanitized: '$ProjectName' -> '$safe'" }
$ProjectName = $safe

# Verify dotnet SDK presence and warn if .NET 10 SDK not found
try {
    $sdks = & dotnet --list-sdks 2>$null
} catch {
    Write-Error "dotnet SDK not found on PATH. Install .NET 10 SDK before running this script."
    exit 1
}
if (-not ($sdks -match '^10\.')) {
    Write-Warning "No .NET 10 SDK detected on this machine. Script may fail. Proceed? (Y/N)"
    $ans = Read-Host
    if ($ans.ToUpper() -ne 'Y') { Write-Error "Aborted by user (no .NET 10 SDK)."; exit 1 }
}

function Confirm-Or-HandleExistingProject {
    param($csprojPath, $projDir)
    if (Test-Path $csprojPath) {
        $choice = Read-Host "Project '$csprojPath' already exists. (S)kip/(O)verwrite/(A)bort?"
        switch ($choice.ToUpper()) {
            'S' { Write-Host "Skipping existing project: $csprojPath"; return 'skip' }
            'O' { Write-Host "Overwriting project: $csprojPath"; Remove-Item -Recurse -Force $projDir; return 'overwrite' }
            default { Write-Error 'Aborted by user.'; exit 1 }
        }
    }
    return 'create'
}

$src = Join-Path $BasePath "src"
$api = Join-Path $src "$ProjectName.Api"
$app = Join-Path $src "$ProjectName.Application"
$domain = Join-Path $src "$ProjectName.Domain"
$data = Join-Path $src "$ProjectName.Infrastructure.Data"
$ioc = Join-Path $src "$ProjectName.Infrastructure.CrossCutting.IoC"
$identity = Join-Path $src "$ProjectName.Infrastructure.CrossCutting.Identity"
$tests = Join-Path $src "$ProjectName.Tests"

Write-Host "Creating folder structure..."
try {
    New-Item -ItemType Directory -Path $api,$app,$domain,$data,$ioc,$identity,$tests -Force | Out-Null

    Write-Host "Creating projects (net10.0)..."
    $proj = "$api\$ProjectName.Api.csproj"
    $action = Confirm-Or-HandleExistingProject -csprojPath $proj -projDir $api
    if ($action -ne 'skip') { dotnet new webapi -n "$ProjectName.Api" -o "$api" -f net10.0 }

    $proj = "$app\$ProjectName.Application.csproj"
    $action = Confirm-Or-HandleExistingProject -csprojPath $proj -projDir $app
    if ($action -ne 'skip') { dotnet new classlib -n "$ProjectName.Application" -o "$app" -f net10.0 }

    $proj = "$domain\$ProjectName.Domain.csproj"
    $action = Confirm-Or-HandleExistingProject -csprojPath $proj -projDir $domain
    if ($action -ne 'skip') { dotnet new classlib -n "$ProjectName.Domain" -o "$domain" -f net10.0 }

    $proj = "$data\$ProjectName.Infrastructure.Data.csproj"
    $action = Confirm-Or-HandleExistingProject -csprojPath $proj -projDir $data
    if ($action -ne 'skip') { dotnet new classlib -n "$ProjectName.Infrastructure.Data" -o "$data" -f net10.0 }

    $proj = "$ioc\$ProjectName.Infrastructure.CrossCutting.IoC.csproj"
    $action = Confirm-Or-HandleExistingProject -csprojPath $proj -projDir $ioc
    if ($action -ne 'skip') { dotnet new classlib -n "$ProjectName.Infrastructure.CrossCutting.IoC" -o "$ioc" -f net10.0 }

    $proj = "$identity\$ProjectName.Infrastructure.CrossCutting.Identity.csproj"
    $action = Confirm-Or-HandleExistingProject -csprojPath $proj -projDir $identity
    if ($action -ne 'skip') { dotnet new classlib -n "$ProjectName.Infrastructure.CrossCutting.Identity" -o "$identity" -f net10.0 }

    $proj = "$tests\$ProjectName.Tests.csproj"
    $action = Confirm-Or-HandleExistingProject -csprojPath $proj -projDir $tests
    if ($action -ne 'skip') { dotnet new xunit -n "$ProjectName.Tests" -o "$tests" -f net10.0 }
}
catch {
    Write-Error "Error while creating projects: $_"
    exit 1
}

Write-Host "Creating solution and adding projects..."
try {
    dotnet new sln -n "$ProjectName" -o "$BasePath"
    $solution = Join-Path $BasePath "$ProjectName.sln"
    dotnet sln "$solution" add "$api\$ProjectName.Api.csproj"
    dotnet sln "$solution" add "$app\$ProjectName.Application.csproj"
    dotnet sln "$solution" add "$domain\$ProjectName.Domain.csproj"
    dotnet sln "$solution" add "$data\$ProjectName.Infrastructure.Data.csproj"
    dotnet sln "$solution" add "$ioc\$ProjectName.Infrastructure.CrossCutting.IoC.csproj"
    dotnet sln "$solution" add "$identity\$ProjectName.Infrastructure.CrossCutting.Identity.csproj"
    dotnet sln "$solution" add "$tests\$ProjectName.Tests.csproj"
}
catch {
    Write-Error "Error while creating/adding solution projects: $_"
    exit 1
}

Write-Host "Adding project references..."
try {
    dotnet add "$api\$ProjectName.Api.csproj" reference "$app\$ProjectName.Application.csproj"
    dotnet add "$api\$ProjectName.Api.csproj" reference "$data\$ProjectName.Infrastructure.Data.csproj"
    dotnet add "$api\$ProjectName.Api.csproj" reference "$ioc\$ProjectName.Infrastructure.CrossCutting.IoC.csproj"
    dotnet add "$api\$ProjectName.Api.csproj" reference "$identity\$ProjectName.Infrastructure.CrossCutting.Identity.csproj"

    dotnet add "$app\$ProjectName.Application.csproj" reference "$domain\$ProjectName.Domain.csproj"
    dotnet add "$app\$ProjectName.Application.csproj" reference "$data\$ProjectName.Infrastructure.Data.csproj"

    dotnet add "$data\$ProjectName.Infrastructure.Data.csproj" reference "$domain\$ProjectName.Domain.csproj"

    dotnet add "$ioc\$ProjectName.Infrastructure.CrossCutting.IoC.csproj" reference "$app\$ProjectName.Application.csproj"
    dotnet add "$ioc\$ProjectName.Infrastructure.CrossCutting.IoC.csproj" reference "$data\$ProjectName.Infrastructure.Data.csproj"
}
catch {
    Write-Error "Error while adding project references: $_"
    exit 1
}

# Add NuGet packages (aligned 10.x where applicable)
Write-Host "Adding NuGet packages (aligned 10.x where applicable)..."
# API packages
dotnet add "$api\$ProjectName.Api.csproj" package Microsoft.AspNetCore.OpenApi --version 10.0.5
dotnet add "$api\$ProjectName.Api.csproj" package Scalar.AspNetCore --version 2.14.3

# Identity project packages
dotnet add "$identity\$ProjectName.Infrastructure.CrossCutting.Identity.csproj" package Microsoft.EntityFrameworkCore.Design --version 10.0.7
dotnet add "$identity\$ProjectName.Infrastructure.CrossCutting.Identity.csproj" package Npgsql.EntityFrameworkCore.PostgreSQL --version 10.0.1
dotnet add "$identity\$ProjectName.Infrastructure.CrossCutting.Identity.csproj" package Microsoft.Extensions.Configuration --version 10.0.7
dotnet add "$identity\$ProjectName.Infrastructure.CrossCutting.Identity.csproj" package Microsoft.AspNetCore.Identity.EntityFrameworkCore --version 10.0.7
dotnet add "$identity\$ProjectName.Infrastructure.CrossCutting.Identity.csproj" package Microsoft.AspNetCore.Authentication.JwtBearer --version 10.0.7
dotnet add "$identity\$ProjectName.Infrastructure.CrossCutting.Identity.csproj" package Microsoft.AspNetCore.Identity.UI --version 10.0.7

# IoC packages
dotnet add "$ioc\$ProjectName.Infrastructure.CrossCutting.IoC.csproj" package Microsoft.Extensions.DependencyInjection --version 10.0.7
dotnet add "$ioc\$ProjectName.Infrastructure.CrossCutting.IoC.csproj" package Microsoft.Extensions.Configuration --version 10.0.7
dotnet add "$ioc\$ProjectName.Infrastructure.CrossCutting.IoC.csproj" package Microsoft.EntityFrameworkCore --version 10.0.7
dotnet add "$ioc\$ProjectName.Infrastructure.CrossCutting.IoC.csproj" package Npgsql.EntityFrameworkCore.PostgreSQL --version 10.0.1
dotnet add "$ioc\$ProjectName.Infrastructure.CrossCutting.IoC.csproj" package Microsoft.Extensions.Diagnostics.HealthChecks --version 10.0.7
dotnet add "$ioc\$ProjectName.Infrastructure.CrossCutting.IoC.csproj" package AspNetCore.HealthChecks.NpgSql --version 9.0.0

# Data project packages
dotnet add "$data\$ProjectName.Infrastructure.Data.csproj" package Microsoft.EntityFrameworkCore --version 10.0.7
dotnet add "$data\$ProjectName.Infrastructure.Data.csproj" package Npgsql.EntityFrameworkCore.PostgreSQL --version 10.0.1
dotnet add "$data\$ProjectName.Infrastructure.Data.csproj" package AspNetCore.HealthChecks.NpgSql --version 9.0.0

# Tests packages
dotnet add "$tests\$ProjectName.Tests.csproj" package Microsoft.EntityFrameworkCore.InMemory --version 10.0.7
dotnet add "$tests\$ProjectName.Tests.csproj" package Microsoft.Extensions.Configuration --version 10.0.7
dotnet add "$tests\$ProjectName.Tests.csproj" package Microsoft.Extensions.Configuration.Json --version 10.0.7
dotnet add "$tests\$ProjectName.Tests.csproj" package Microsoft.Extensions.DependencyInjection --version 10.0.7
dotnet add "$tests\$ProjectName.Tests.csproj" package Moq --version 4.18.4

Write-Host "Removing template sample files if present (limited to created project folders)..."
Get-ChildItem -Path $api,$app,$domain,$data,$ioc,$identity,$tests -Include "Class1.cs","UnitTest1.cs","WeatherForecast.cs" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue

Write-Host "Creating ApplicationDbContext..."
$ctxPath = Join-Path $data "Data"
New-Item -ItemType Directory -Path $ctxPath -Force | Out-Null
$ctxFile = Join-Path $ctxPath "ApplicationDbContext.cs"
$ctxContent = @"
using Microsoft.EntityFrameworkCore;

namespace $($ProjectName).Infrastructure.Data;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }

    // public DbSet<YourEntity> YourEntities { get; set; }
}
"@
Set-Content -Path $ctxFile -Value $ctxContent -Encoding UTF8

Write-Host "Creating PostgreSqlExtensions..."
$extPath = Join-Path $ioc "Extensions"
New-Item -ItemType Directory -Path $extPath -Force | Out-Null
$extFile = Join-Path $extPath "PostgreSqlExtensions.cs"
$extContent = @"
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.EntityFrameworkCore;
using $($ProjectName).Infrastructure.Data;

namespace $($ProjectName).Infrastructure.CrossCutting.IoC;

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
"@
Set-Content -Path $extFile -Value $extContent -Encoding UTF8

Write-Host "Creating ApiEndpoints...
"
$endpointsPath = Join-Path $api "Endpoints\ApiEndpoints"
New-Item -ItemType Directory -Path $endpointsPath -Force | Out-Null
$endpointsFile = Join-Path $endpointsPath "ApiEndpoints.cs"
$endpointsContent = @"
using Microsoft.AspNetCore.Routing;
namespace $($ProjectName).Api.Endpoints;

public static class ApiEndpoints
{
    public static void MapBookEndpoints(this IEndpointRouteBuilder app)
    {
        var grupo = app.MapGroup("/$ProjectName");
        // Map endpoints here
    }
}
"@
Set-Content -Path $endpointsFile -Value $endpointsContent -Encoding UTF8

Write-Host "Creating appsettings files..."
$appsettings = @"
{
  "Logging": { "LogLevel": { "Default": "Information", "Microsoft.AspNetCore": "Warning" } },
  "AllowedHosts": "*",
  "ConnectionStrings": { "DefaultConnection": "$ConnectionString" }
}
"@
Set-Content -Path (Join-Path $api "appsettings.json") -Value $appsettings -Encoding UTF8
Set-Content -Path (Join-Path $api "appsettings.Development.json") -Value $appsettings -Encoding UTF8
Set-Content -Path (Join-Path $api "appsettings.Production.json") -Value $appsettings -Encoding UTF8

Write-Host "Restoring solution..."
Push-Location $BasePath
dotnet restore
Pop-Location

Write-Host "Scaffolding completed. Verify files and run the solution in your IDE or with 'dotnet build'."
