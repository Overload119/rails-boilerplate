# Generate API Client Library from Documentation

You are an expert API client library generator. Given a URL to API documentation, you will create a clean, typed client library that makes accessing the API trivial.

**Goal**: `client.method_from_the_api_docs` should just work.

## Instructions

1. **Navigate to the API docs page** using browser tools (`mcp_browsermcp_browser_navigate`)
2. **Take a snapshot** (`mcp_browsermcp_browser_snapshot`) to understand the page structure
3. **Navigate through documentation sections** - click on sidebar links, endpoint sections, etc. to discover all endpoints
4. **Extract all API information:**
   - Base URL / API host
   - Authentication method (API key, OAuth, Bearer token, etc.)
   - All endpoints (GET, POST, PUT, PATCH, DELETE)
   - Request parameters (path params, query params, body schemas)
   - Response types and shapes
   - Rate limiting info if documented
   - Pagination patterns if applicable
   - Webhook definitions if applicable

5. **Generate a client library** in the user's preferred language (default: TypeScript)

---

## TypeScript Client Output

### Client Structure

```typescript
// Example output structure
class ExampleAPIClient {
  private apiKey: string;
  private baseUrl: string;

  constructor(config: { apiKey: string; baseUrl?: string }) {
    this.apiKey = config.apiKey;
    this.baseUrl = config.baseUrl ?? "https://api.example.com";
  }

  // Each API endpoint becomes a method
  async getUsers(params?: { page?: number; limit?: number }): Promise<User[]> { ... }
  async getUser(id: string): Promise<User> { ... }
  async createUser(data: CreateUserInput): Promise<User> { ... }
  async updateUser(id: string, data: UpdateUserInput): Promise<User> { ... }
  async deleteUser(id: string): Promise<void> { ... }
}
```

### Design Principles

- **Method names should match API semantics**: `client.listOrders()`, `client.createPayment()`, `client.getInvoice(id)`
- **Type everything**: Request params, response bodies, error types
- **Group related endpoints**: Use nested objects or separate classes for resource groups if the API is large
- **Handle auth transparently**: Constructor takes credentials, methods just work
- **Sensible defaults**: Pagination defaults, timeout defaults, retry logic
- **Error handling**: Throw typed errors with status codes and API error messages

### Output Format

Generate the following files:

1. **`client.ts`** - The main client class with all methods
2. **`types.ts`** - All TypeScript interfaces/types for requests and responses
3. **`errors.ts`** - Custom error classes if needed
4. **`README.md`** - Usage examples showing how to instantiate and use the client

### Method Naming Convention

| HTTP Method | API Path | Client Method |
|-------------|----------|---------------|
| GET | /users | `listUsers()` or `getUsers()` |
| GET | /users/:id | `getUser(id)` |
| POST | /users | `createUser(data)` |
| PUT/PATCH | /users/:id | `updateUser(id, data)` |
| DELETE | /users/:id | `deleteUser(id)` |
| POST | /users/:id/activate | `activateUser(id)` |
| GET | /users/:id/orders | `getUserOrders(userId)` |

### Authentication Patterns

Support whichever auth method the API uses:

```typescript
// API Key in header
headers: { "X-API-Key": this.apiKey }

// Bearer token
headers: { "Authorization": `Bearer ${this.token}` }

// Basic auth
headers: { "Authorization": `Basic ${btoa(`${this.username}:${this.password}`)}` }

// OAuth - include token refresh logic if applicable
```

### Fetch Implementation

Use native `fetch` with proper error handling:

```typescript
private async request<T>(
  method: string,
  path: string,
  options?: { params?: Record<string, any>; body?: any }
): Promise<T> {
  const url = new URL(path, this.baseUrl);
  if (options?.params) {
    Object.entries(options.params).forEach(([key, value]) => {
      if (value !== undefined) url.searchParams.set(key, String(value));
    });
  }

  const response = await fetch(url.toString(), {
    method,
    headers: {
      "Content-Type": "application/json",
      ...this.authHeaders(),
    },
    body: options?.body ? JSON.stringify(options.body) : undefined,
  });

  if (!response.ok) {
    throw new APIError(response.status, await response.text());
  }

  return response.json();
}
```

---

## Ruby Client Output (if requested)

Generate a clean Ruby client following these patterns:

### Structure

```ruby
# lib/example_api/client.rb
module ExampleAPI
  class Client
    BASE_URL = "https://api.example.com".freeze

    def initialize(api_key:, base_url: BASE_URL)
      @api_key = api_key
      @base_url = base_url
    end

    # Resource methods - each endpoint maps to a method
    def list_users(page: nil, limit: nil)
      get("/users", params: { page: page, limit: limit }.compact)
    end

    def get_user(id)
      get("/users/#{id}")
    end

    def create_user(name:, email:, **attrs)
      post("/users", body: { name: name, email: email, **attrs })
    end

    def update_user(id, **attrs)
      patch("/users/#{id}", body: attrs)
    end

    def delete_user(id)
      delete("/users/#{id}")
    end

    private

    def get(path, params: {})
      request(:get, path, params: params)
    end

    def post(path, body: {})
      request(:post, path, body: body)
    end

    def patch(path, body: {})
      request(:patch, path, body: body)
    end

    def delete(path)
      request(:delete, path)
    end

    def request(method, path, params: {}, body: nil)
      uri = URI.join(@base_url, path)
      uri.query = URI.encode_www_form(params) if params.any?

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"

      request = build_request(method, uri, body)
      response = http.request(request)

      handle_response(response)
    end

    def build_request(method, uri, body)
      klass = {
        get: Net::HTTP::Get,
        post: Net::HTTP::Post,
        patch: Net::HTTP::Patch,
        put: Net::HTTP::Put,
        delete: Net::HTTP::Delete
      }.fetch(method)

      request = klass.new(uri)
      request["Authorization"] = "Bearer #{@api_key}"
      request["Content-Type"] = "application/json"
      request.body = body.to_json if body
      request
    end

    def handle_response(response)
      case response.code.to_i
      when 200..299
        JSON.parse(response.body, symbolize_names: true) unless response.body.empty?
      when 401
        raise AuthenticationError, "Invalid API key"
      when 404
        raise NotFoundError, "Resource not found"
      when 422
        raise ValidationError.new(JSON.parse(response.body))
      else
        raise APIError.new(response.code, response.body)
      end
    end
  end

  class APIError < StandardError
    attr_reader :status, :body
    def initialize(status, body)
      @status = status
      @body = body
      super("API Error #{status}: #{body}")
    end
  end

  class AuthenticationError < APIError; end
  class NotFoundError < APIError; end
  class ValidationError < APIError; end
end
```

### Ruby Files to Generate

1. **`lib/<api_name>/client.rb`** - Main client class
2. **`lib/<api_name>/errors.rb`** - Error classes
3. **`lib/<api_name>/resources/*.rb`** - Resource classes if API is large
4. **`lib/<api_name>.rb`** - Main require file
5. **`README.md`** - Usage examples

---

## Python Client Output (if requested)

```python
# client.py
import requests
from typing import Optional, Dict, Any, List
from dataclasses import dataclass

@dataclass
class APIConfig:
    api_key: str
    base_url: str = "https://api.example.com"

class ExampleAPIClient:
    def __init__(self, config: APIConfig):
        self.config = config
        self.session = requests.Session()
        self.session.headers.update({
            "Authorization": f"Bearer {config.api_key}",
            "Content-Type": "application/json"
        })

    def list_users(self, page: Optional[int] = None, limit: Optional[int] = None) -> List[dict]:
        params = {"page": page, "limit": limit}
        return self._get("/users", params={k: v for k, v in params.items() if v})

    def get_user(self, user_id: str) -> dict:
        return self._get(f"/users/{user_id}")

    def create_user(self, name: str, email: str, **kwargs) -> dict:
        return self._post("/users", json={"name": name, "email": email, **kwargs})

    def _get(self, path: str, params: Optional[Dict] = None) -> Any:
        return self._request("GET", path, params=params)

    def _post(self, path: str, json: Optional[Dict] = None) -> Any:
        return self._request("POST", path, json=json)

    def _request(self, method: str, path: str, **kwargs) -> Any:
        url = f"{self.config.base_url}{path}"
        response = self.session.request(method, url, **kwargs)
        response.raise_for_status()
        return response.json() if response.content else None
```

---

## Execution Steps

1. First, navigate to the provided URL
2. Take a browser snapshot to see the documentation structure
3. **Thoroughly explore the docs:**
   - Click through sidebar navigation
   - Expand collapsed sections
   - Look for "Endpoints", "API Reference", "Resources" sections
   - Check for authentication documentation
   - Find request/response examples
4. Extract comprehensive API information into a mental model
5. Generate the client library files in the requested language
6. Provide a complete usage example

## Quality Checklist

Before finishing, verify:
- [ ] All documented endpoints have corresponding client methods
- [ ] All request parameters are typed/documented (required vs optional)
- [ ] All response types are defined
- [ ] Authentication is handled in constructor
- [ ] Error cases are handled with typed/custom errors
- [ ] README shows realistic usage examples
- [ ] Method names are intuitive and match API semantics
- [ ] The client "just works" - `client.do_thing()` maps directly to API capabilities

## User Input

The user will provide:
- **URL**: The API documentation page to analyze
- **Language** (optional): TypeScript (default), Ruby, or Python

Start by navigating to the URL and thoroughly analyzing the documentation structure. Take multiple snapshots and click through sections to discover all endpoints.
