var builder = DistributedApplication.CreateBuilder(args);

// Ollama server
var ollama = builder.AddOllama("ollama")
    .WithDataVolume();
var phi35 = ollama.AddModel("phi3.5");


builder.Build().Run();
