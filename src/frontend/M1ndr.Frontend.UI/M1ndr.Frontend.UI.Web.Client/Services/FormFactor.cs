using M1ndr.Frontend.UI.Shared.Services;

namespace M1ndr.Frontend.UI.Web.Client.Services
{
    public class FormFactor : IFormFactor
    {
        public string GetFormFactor() => "WebAssembly";

        public string GetPlatform() => Environment.OSVersion.ToString();
    }
}
