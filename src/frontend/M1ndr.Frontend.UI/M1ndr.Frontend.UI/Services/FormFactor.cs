using M1ndr.Frontend.UI.Shared.Services;

namespace M1ndr.Frontend.UI.Services
{
    public class FormFactor : IFormFactor
    {
        public string GetFormFactor() => DeviceInfo.Idiom.ToString();

        public string GetPlatform() => $"{DeviceInfo.Platform} - {DeviceInfo.VersionString}";
    }
}
