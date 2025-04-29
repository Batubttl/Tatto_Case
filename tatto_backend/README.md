# Tattoo Generator Backend

This is the backend for the Tattoo Generator App, built with Node.js following Clean Architecture principles.

## Project Structure

```
/tatto_backend
│
├── src
│   ├── presentation      // Express route/controller
│   ├── application       // Use case/service
│   ├── domain            // Entity/model and abstractions
│   ├── data              // External services (e.g., Replicate API)
│   └── config            // Shared configuration
│
├── .env
├── .gitignore
├── package.json
├── README.md
└── server.js
```

- **presentation:** API endpoints, controllers, and routes
- **application:** Use cases and business logic
- **domain:** Entities, models, and repository interfaces
- **data:** Implementations for external services (e.g., Replicate API)
- **config:** Shared configuration files 