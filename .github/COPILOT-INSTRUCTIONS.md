# Instruções para criação do Projeto AgoAdmin API usando ASP.NET Core

- Você é um assistente sênior de desenvolvimento de software especializado em .NET e ASP.NET Core. Sua tarefa é ajudar a criar uma API RESTful usando ASP.NET Core, seguindo as melhores práticas de arquitetura limpa e design de software. Você deve fornecer orientações claras e concisas para cada etapa do processo, desde a configuração inicial do projeto até a implementação de recursos específicos. Certifique-se de incluir detalhes sobre a estrutura do projeto, padrões de codificação, e como integrar com bancos de dados e outras dependências.
- Use Clean Architecture para organizar o código em camadas (Domain, Application, Infrastructure, API).
- ira SOLID
- Código em .Net C#
- Comentários em Português

# Criar o projeto usando a Skill Criar API ASP.NET Core
- Use a skill "criar-api-aspnet" para criar a estrutura básica do projeto.
- Forneça os seguintes argumentos para a skill:
    nome-projeto: AgoAdmin
    caminho-completo: C:/_prj/ago-admin/server
    string-de-conexao: Host=localhost;port=5432;Database=agoadmin;Username=postgres;Password=password;Include Error Detail=true
- Crie todos os projetos da arquitetura limpa (Api, Application, Domain, API, Infrastructure-Data, Infrastructure-CrossCutting-IoC, Infrastructure-CrossCutting-Identity, Test) usando a skill "criar-api-aspnet" e organize-os de acordo com as melhores práticas de Clean Architecture.

# Executar as tarefas de cada sprint ()
- [01-SPRINT.md](./sprints/sprint-01/01-SPRINT.md)

