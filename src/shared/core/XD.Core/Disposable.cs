using System.Runtime.CompilerServices;

namespace XD.Core;

/// <summary>
/// Base class that implements the Dispose pattern and IAsyncDisposable for .NET 9.
/// Provides a robust and thread-safe implementation of resource cleanup.
/// </summary>
public abstract class Disposable : IDisposable, IAsyncDisposable
{
    /// <summary>
    /// Disposal status flag.
    /// </summary>
    private volatile bool _disposed;

    /// <summary>
    /// Dispose lock to ensure thread-safe disposal.
    /// </summary>
    private readonly Lock _disposeLock = new();

    /// <summary>
    /// Indicates whether the object has been disposed.
    /// </summary>
    public bool IsDisposed => _disposed;

    /// <summary>
    /// Finalizer that ensures the cleanup of unmanaged resources.
    /// </summary>
    ~Disposable()
    {
        Dispose(disposing: false);
    }

    /// <summary>
    /// Releases all resources used by the object.
    /// </summary>
    public void Dispose()
    {
        Dispose(disposing: true);
        GC.SuppressFinalize(this);
    }

    /// <summary>
    /// Releases all resources used by the object asynchronously.
    /// </summary>
    /// <returns>A ValueTask that represents the asynchronous dispose operation.</returns>
    public async ValueTask DisposeAsync()
    {
        await DisposeAsyncCore().ConfigureAwait(false);

        // Call Dispose(false) to ensure unmanaged resources are released
        // if DisposeAsyncCore hasn't already handled them
        Dispose(disposing: false);
        GC.SuppressFinalize(this);
    }

    /// <summary>
    /// Implementation of the dispose pattern that handles both managed and unmanaged resources.
    /// </summary>
    /// <param name="disposing">
    /// true if called from Dispose(); false if called from the finalizer.
    /// </param>
    protected virtual void Dispose(bool disposing)
    {
        if (_disposed)
            return;

        lock (_disposeLock)
        {
            if (_disposed)
                return;

            try
            {
                if (disposing)
                {
                    // Release managed resources
                    DisposeManagedResources();
                }

                // Always release unmanaged resources
                DisposeUnmanagedResources();
            }
            finally
            {
                _disposed = true;
            }
        }
    }

    /// <summary>
    /// Core implementation of asynchronous dispose.
    /// Override this method to provide custom asynchronous cleanup.
    /// </summary>
    /// <returns>A ValueTask that represents the asynchronous dispose operation.</returns>
    protected virtual async ValueTask DisposeAsyncCore()
    {
        if (_disposed)
            return;

        // Release managed resources asynchronously
        await DisposeManagedResourcesAsync().ConfigureAwait(false);

        // Mark as disposed in a thread-safe manner
        lock (_disposeLock)
        {
            _disposed = true;
        }
    }

    /// <summary>
    /// Releases managed resources synchronously.
    /// Override this method in derived classes to implement specific cleanup.
    /// </summary>
    protected virtual void DisposeManagedResources()
    {
        // Empty default implementation - override in derived classes
    }

    /// <summary>
    /// Releases managed resources asynchronously.
    /// Override this method in derived classes to implement specific asynchronous cleanup.
    /// </summary>
    /// <returns>A ValueTask that represents the asynchronous cleanup operation.</returns>
    protected virtual ValueTask DisposeManagedResourcesAsync()
    {
        // Fallback to the synchronous version for compatibility
        DisposeManagedResources();
        return ValueTask.CompletedTask;
    }

    /// <summary>
    /// Releases unmanaged resources.
    /// Override this method in derived classes to implement cleanup of unmanaged resources.
    /// </summary>
    protected virtual void DisposeUnmanagedResources()
    {
        // Empty default implementation - override in derived classes
    }

    /// <summary>
    /// Verifies that the object has not been disposed and throws an exception if it has.
    /// Use this method at the beginning of public methods to ensure the object is usable.
    /// </summary>
    /// <param name="memberName">Name of the member calling this method (automatically compiled).</param>
    /// <exception cref="ObjectDisposedException">Thrown if the object has been disposed.</exception>
    protected void ThrowIfDisposed([CallerMemberName] string? memberName = null)
    {
        if (_disposed)
        {
            throw new ObjectDisposedException(GetType().FullName, memberName);
        }
    }

    /// <summary>
    /// Checks if the object has been disposed.
    /// </summary>
    /// <returns>true if the object is usable, false if it has been disposed.</returns>
    protected bool CheckIfDisposed() => _disposed;
}
