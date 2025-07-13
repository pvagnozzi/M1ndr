using Microsoft.Extensions.Logging;
using System;

namespace XD.Core.Services;

/// <summary>
/// Base interface for all services.
/// Supports both synchronous and asynchronous dispose patterns.
/// </summary>
public interface IService : IDisposable, IAsyncDisposable
{
    /// <summary>
    /// Gets the logger instance for the service.
    /// </summary>
    ILogger Logger { get; }
}
