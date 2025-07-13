using M1ndr.Frontend.UI.Shared.Services;

namespace M1ndr.Frontend.UI.Web.Services
{
    public class FormFactor : IFormFactor
    {
        public string GetFormFactor() => "Web";

        public string GetPlatform() => Environment.OSVersion.ToString();
    }
}
