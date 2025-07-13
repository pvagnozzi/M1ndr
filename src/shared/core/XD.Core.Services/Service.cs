using Microsoft.Extensions.Logging;

namespace XD.Core.Services;

/// <summary>
/// Base class for all services that provides support for dispose pattern.
/// Inherits from Disposable to support both IDisposable and IAsyncDisposable.
/// </summary>
/// <param name="logger">Logger instance for the service.</param>
public abstract class Service(ILogger logger) : Disposable, IService
{
    /// <summary>
    /// Gets the logger instance for the service.
    /// </summary>
    public ILogger Logger { get; } = logger;
}
