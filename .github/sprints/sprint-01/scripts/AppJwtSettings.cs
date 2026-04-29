    public class AppJwtSettings
    {
        public string SecretKey { get; set; }
        public int Expiration { get; set; } = 1;
        public string Issuer { get; set; }
        public string Audience { get; set; }
    }