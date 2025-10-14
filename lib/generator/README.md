# Generator System

Entry point: `lib/generator.rb`

Pipeline: Clone specs → Generate APIs/Notifications/Reports/Feeds → Generate RBS → Format

## Directory Structure

### Main Generators (Entry Points)
- **`api.rb`** - Generate API classes from OpenAPI specs
- **`notification.rb`** - Generate notification types from JSON schemas
- **`report.rb`** - Generate report types from JSON schemas
- **`feed.rb`** - Generate feed types from JSON schemas
- **`type.rb`** - Generate type classes (used by all generators above)
- **`operation.rb`** - Generate API operation methods
- **`entrypoint.rb`** - Generate main `lib/peddler.rb` file

### Infrastructure
- **`config.rb`** - Configuration (paths, constants)
- **`logger.rb`** - Logging utilities
- **`specs.rb`** - Clone/sync Amazon SP-API specs from GitHub

### Builders (`builders/`)
Classes that construct/build data structures:
- **`parameter_builder.rb`** - Build parameter lists for API operations
- **`response_model.rb`** - Build response model metadata for operations

### Parsers (`parsers/`)
Classes that parse/extract information from specs:
- **`json_schema_extractor.rb`** - Extract nested types from JSON schemas
- **`rate_limit_parser.rb`** - Parse rate limit info from OpenAPI specs
- **`path.rb`** - Parse OpenAPI path definitions into operations

### Resolvers (`resolvers/`)
Classes that resolve/translate between representations:
- **`type_resolver.rb`** - Resolve OpenAPI types to Ruby types
- **`api_name_resolver.rb`** - Resolve API names from file paths
- **`version_selector.rb`** - Select latest version from multiple API versions

### Analyzers (`analyzers/`)
Classes that analyze code structure:
- **`circular_dependency_detector.rb`** - Detect circular type dependencies

### Support (`support/`)
Shared utilities and mixins:
- **`file_writer.rb`** - File I/O operations, formatting, RBS sorting
- **`formatter.rb`** - Code formatting utilities (YARD comments, markdown, etc.)
- **`schema_helpers.rb`** - Shared schema manipulation for Notification/Report/Feed/Type
- **`introspection_loader.rb`** - Zeitwerk loader for introspecting generated classes

### Templates & Types
- **`templates/`** - ERB templates for code generation
- **`rbs/`** - RBS signature generation modules
  - `unified.rb` - Combined API operations + types signatures
  - `types.rb` - Type-only signatures (notifications/reports/feeds)
  - `entrypoint.rb` - Entrypoint signature

## How It Works

1. **Sync Specs**: `Specs.sync` clones Amazon's selling-partner-api-models repo
2. **Generate Code**: Each generator (API, Notification, Report, Feed) reads JSON/OpenAPI specs and:
   - Extracts type definitions using `JsonSchemaExtractor`
   - Generates Ruby classes using `Type` generator
   - Generates main wrapper files from ERB templates
3. **Generate RBS**: Each generator introspects generated classes and creates RBS signatures
4. **Format**: All files are formatted with RuboCop and RBS files are sorted

## Key Patterns

- **Parallel Generation**: All generators use `Parallel.each` for concurrent processing
- **Type Resolution**: OpenAPI/JSON types → Ruby types handled by `TypeResolver`
- **Circular Dependencies**: Detected by `CircularDependencyDetector`, resolved with lazy string class names
- **Introspection**: Generated classes loaded via `IntrospectionLoader` for RBS generation with Structure gem
