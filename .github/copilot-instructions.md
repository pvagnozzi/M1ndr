# Copilot Instructions for M1ndr Project

## Project Architecture
- This is a .NET MAUI project with Blazor WebAssembly for building an AI assistant application.
- Uses .NET 9 and C# 13
- The project is structured into multiple layers:
  - Core: Contains shared libraries and core logic
  - Frontend: Contains the MAUI/Blazor UI projects
  - Backend: Contains backend services
  - Tests: Contains unit and integration tests
  - Hosting: Contains configuration for Aspire hosting

## Code Conventions
- Prefer async/await for I/O operations
- Use dependency injection for all services

## Comments and Documentation
- Use XML comments for public APIs
- Use inline comments for complex logic
- Use TODO comments for unfinished work
- Use FIXME comments for known issues
- Use HACK comments for temporary solutions
- Use NOTE comments for important information
- Use REVIEW comments for code that needs review
- Use DEPRECATED comments for deprecated code
- Use REVIEWED comments for code that has been reviewed
- Use REVIEWED_BY comments to indicate who reviewed the code
- Use REVIEWED_ON comments to indicate when the code was reviewed
- Use REVIEWED_VERSION comments to indicate the version of the code that was reviewed
- Use REVIEWED_BY_VERSION comments to indicate the version of the code that was reviewed by a specific person
- Use REVIEWED_BY_DATE comments to indicate the date when the code was reviewed by a specific person
- Use REVIEWED_BY_TIME comments to indicate the time when the code was reviewed by a specific person
- Use REVIEWED_BY_COMMENTS comments to indicate any comments made by the reviewer during the review process
- Use REVIEWED_BY_SUGGESTIONS comments to indicate any suggestions made by the reviewer during the review process
- Use REVIEWED_BY_CHANGES comments to indicate any changes made by the reviewer during the review process
- Use REVIEWED_BY_APPROVED comments to indicate if the code was approved by the reviewer
- Use REVIEWED_BY_REJECTED comments to indicate if the code was rejected by the reviewer
- Use REVIEWED_BY_PENDING comments to indicate if the code is pending review
- Use REVIEWED_BY_IN_PROGRESS comments to indicate if the code is still in progress
- Use REVIEWED_BY_COMPLETED comments to indicate if the code review is completed
- Use REVIEWED_BY_CANCELLED comments to indicate if the code review was cancelled
- Use REVIEWED_BY_SKIPPED comments to indicate if the code review was skipped
- Use REVIEWED_BY_NOT_APPLICABLE comments to indicate if the code review is not applicable
- Use REVIEWED_BY_NOT_NEEDED comments to indicate if the code review is not needed
- Use REVIEWED_BY_NOT_REQUIRED comments to indicate if the code review is not required
- Use REVIEWED_BY_NOT_ALLOWED comments to indicate if the code review is not allowed
- Use REVIEWED_BY_NOT_SUPPORTED comments to indicate if the code review is not supported
- Use REVIEWED_BY_NOT_IMPLEMENTED comments to indicate if the code review is not implemented
- Use REVIEWED_BY_NOT_AVAILABLE comments to indicate if the code review is not available
- Use REVIEWED_BY_NOT_FOUND comments to indicate if the code review is not found
- Use REVIEWED_BY_NOT_EXIST comments to indicate if the code review does not exist
- Use REVIEWED_BY_NOT_DEFINED comments to indicate if the code review is not defined
- Use REVIEWED_BY_NOT_SET comments to indicate if the code review is not set
- Use REVIEWED_BY_NOT_INITIALIZED comments to indicate if the code review is not initialized
- Use REVIEWED_BY_NOT_CONFIGURED comments to indicate if the code review is not configured
- Use REVIEWED_BY_NOT_SUPPORTED comments to indicate if the code review is not supported
- Use REVIEWED_BY_NOT_IMPLEMENTED comments to indicate if the code review is not implemented
- Use REVIEWED_BY_NOT_AVAILABLE comments to indicate if the code review is not available
- Use REVIEWED_BY_NOT_FOUND comments to indicate if the code review is not found
- Use REVIEWED_BY_NOT_EXIST comments to indicate if the code review does not exist
- Use REVIEWED_BY_NOT_DEFINED comments to indicate if the code review is not defined
- Use REVIEWED_BY_NOT_SET comments to indicate if the code review is not set
- Use REVIEWED_BY_NOT_INITIALIZED comments to indicate if the code review is not initialized
- Use REVIEWED_BY_NOT_CONFIGURED comments to indicate if the code review is not configured
- Use REVIEWED_BY_NOT_SUPPORTED comments to indicate if the code review is not supported
- Use REVIEWED_BY_NOT_IMPLEMENTED comments to indicate if the code review is not implemented
- GitHub Copilot should use these comments to provide context and clarity in the code.
- Generate comments in a way that they can be easily understood by other developers.
- Generate comments that are concise and to the point.
- Generate comments that are relevant to the code being written.
- Generate comments that are consistent with the existing codebase
- Generate comments for all methods, properties, fields, and classes.
- Creates an header comment for each file with the following format:
  ```
  // File: [filename]
  // Description: [brief description of the file's purpose]
  #region __FILE_HEADER__
  // <copyright file="[filename]" company="M1ndr">
  // Copyright (c) 2025 All Rights Reserved
  // </copyright>
  // <author>[author]</author>
  // <date>[current date]</date>
  // <summary>[brief description of the file's purpose]</summary>
  #endregion


## Folder Structure
- `src/shared/core/` - Core shared libraries
- `src/frontend/` - MAUI/Blazor UI projects
- `src/backend/` - Backend services
- `tests/` - Tests
- `hosting/aspire/` - Aspire configuration

## Naming Styles
- Interfaces: I prefix (e.g. IService)
- Services: Service suffix
- Use PascalCase for classes and methods
- Use camelCase for parameters and local variables
- Use file namespace as the folder structure
- Use plural names for collections (e.g. `Users`, `Products`)
- Use singular names for single items (e.g. `User`, `Product`)
- Use descriptive names for methods (e.g. `GetUserById`, `CreateProduct`)
- Use verb-noun naming for methods (e.g. `GetUser`, `CreateProduct`)
- Use noun-verb naming for properties (e.g. `UserId`, `ProductName`)
- Use noun-noun naming for fields (e.g. `UserRepository`, `ProductService`)
- Use verb-verb naming for events (e.g. `UserCreated`, `ProductUpdated`)
- Use noun-verb-verb naming for commands (e.g. `CreateUserCommand`, `UpdateProductCommand`)
- Use noun-noun-verb naming for queries (e.g. `GetUserByIdQuery`, `GetProductByNameQuery`)
- Use noun-noun-noun naming for DTOs (e.g. `UserDto`, `ProductDto`)
- Use noun-noun-noun-noun naming for view models (e.g. `UserViewModel`, `ProductViewModel`)
- Use noun-noun-noun-noun-noun naming for response models (e.g. `UserResponseModel`, `ProductResponseModel`)

## Testing
- Use xUnit for unit tests
- Use Moq for mocking dependencies
- Use FluentAssertions for assertions
- Use AutoFixture for test data generation
- Use [Theory] and [InlineData] for parameterized tests
- Use [Fact] for single tests
- Use [ClassData] for complex test data
- Use [MemberData] for member data tests
- Use [Collection] for test collections
- Use [CollectionDefinition] for collection definitions
- Use [ClassFixture] for class fixtures
- Use [CollectionFixture] for collection fixtures
- Use [AssemblyFixture] for assembly fixtures
- Use [TestCaseOrderer] for test case ordering
- Use [TestPriority] for test priorities
- Use [TestCategory] for test categories
- Use [TestMethod] for test methods
- Use [TestInitialize] for test initialization
- Use [TestCleanup] for test cleanup
- Generate tests for all public methods
- Genearte tests after the implementation of the method and classes and not before
- Generate tests that cover all edge cases
- Generate tests in a separeted session
- Generate a unit test project for each project in the solution
- Generate integration test project for all projects that require integration testing
- Generate an end-to-end test project for the entire solution
- Generate unit tests and integration tests for all public methods and classes
