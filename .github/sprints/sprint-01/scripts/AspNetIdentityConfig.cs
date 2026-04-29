public static class AspNetIdentityConfig
{
    public static WebApplicationBuilder AddApiIdentityConfiguration(this WebApplicationBuilder builder)
    {
        builder.AddIdentityDbContext()
               .AddIdentityApiSupport()
               .AddJwtSupport()
               .AddAspNetUserSupport();

        return builder;
    }

    public static WebApplicationBuilder AddWebIdentityConfiguration(this WebApplicationBuilder builder)
    {
        builder.AddIdentityDbContext()
               .AddIdentityWebUISupport()
               .AddAspNetUserSupport()
               .AddSocialAuthenticationSupport();

        return builder;
    }

    private static WebApplicationBuilder AddIdentityDbContext(this WebApplicationBuilder builder)
    {
        builder.Services.AddDbContext<EquinoxIdentityContext>(options =>
                    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

        return builder;
    }

    private static WebApplicationBuilder AddIdentityApiSupport(this WebApplicationBuilder builder)
    {
        builder.Services.AddIdentityApiEndpoints<IdentityUser>()
                        .AddRoles<IdentityRole>()
                        .AddEntityFrameworkStores<EquinoxIdentityContext>()
                        .AddSignInManager()
                        .AddRoleManager<RoleManager<IdentityRole>>()
                        .AddDefaultTokenProviders();

        return builder;
    }

    private static WebApplicationBuilder AddIdentityWebUISupport(this WebApplicationBuilder builder)
    {
        builder.Services.AddIdentity<IdentityUser, IdentityRole>()
                .AddEntityFrameworkStores<EquinoxIdentityContext>()
                .AddDefaultTokenProviders()
                .AddDefaultUI();

        return builder;
    }

    private static WebApplicationBuilder AddJwtSupport(this WebApplicationBuilder builder)
    {
        var appSettingsSection = builder.Configuration.GetSection("AppJwtSettings");
        builder.Services.Configure<AppJwtSettings>(appSettingsSection);

        var appSettings = appSettingsSection.Get<AppJwtSettings>();
        var key = Encoding.ASCII.GetBytes(appSettings.SecretKey);

        builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(options =>
            {
                options.RequireHttpsMetadata = true;
                options.SaveToken = true;
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(key),
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidAudience = appSettings.Audience,
                    ValidIssuer = appSettings.Issuer
                };
            });

        return builder;
    }

    public static WebApplicationBuilder AddAspNetUserSupport(this WebApplicationBuilder builder)
    {
        builder.Services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
        builder.Services.AddScoped<IAspNetUser, AspNetUser>();

        return builder;
    }

    public static WebApplicationBuilder AddSocialAuthenticationSupport(this WebApplicationBuilder builder)
    {
        if (builder == null) throw new ArgumentNullException(nameof(builder));

        builder.Services.AddAuthentication()
            .AddFacebook(o =>
            {
                o.AppId = builder.Configuration["Authentication:Facebook:AppId"];
                o.AppSecret = builder.Configuration["Authentication:Facebook:AppSecret"];
            })
            .AddGoogle(googleOptions =>
            {
                googleOptions.ClientId = builder.Configuration["Authentication:Google:ClientId"];
                googleOptions.ClientSecret = builder.Configuration["Authentication:Google:ClientSecret"];
            });

        return builder;
    }
}