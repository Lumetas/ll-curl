# curl — HTTP client for Lum Lisp

HTTP requests via `curl` CLI.

## Install

```sh
lpm require lumetas/curl
```

Or manually:

```sh
git clone https://github.com/lumetas/curl.git ll_modules/lumetas/curl
```

## Usage

```scheme
(import "curl")

; GET
(define body (curl/get "https://api.example.com/data"))
(println "status:" (curl/status))

; POST
(curl/post "https://httpbin.org/post" "key=value")

; PUT
(curl/put "https://httpbin.org/put" "{\"x\":1}")

; PATCH
(curl/patch "https://httpbin.org/patch" "x=2")

; DELETE
(curl/delete "https://httpbin.org/delete")

; HEAD (returns response headers)
(curl/head "https://httpbin.org/get")

; OPTIONS
(curl/options "https://httpbin.org/get")

; Custom headers
(curl/get-with-headers "https://api.example.com/secret"
  '("Authorization: Bearer token123"))

(curl/post-with-headers "https://httpbin.org/post" "{\"msg\":\"hi\"}"
  '("Content-Type: application/json"))

(curl/put-with-headers "https://httpbin.org/put" "x=1"
  '("X-Debug: true"))

(curl/delete-with-headers "https://httpbin.org/delete"
  '("X-Api-Key: secret"))

; Response info
(curl/status)            ; last HTTP status code (integer)
(curl/response-headers)  ; last response headers (JSON string)
```

## API

| Function | Description |
|----------|-------------|
| `curl/get url` | GET request |
| `curl/get-with-headers url headers` | GET with custom headers |
| `curl/post url data` | POST form-encoded |
| `curl/post-with-headers url data headers` | POST with headers |
| `curl/put url data` | PUT |
| `curl/put-with-headers url data headers` | PUT with headers |
| `curl/patch url data` | PATCH |
| `curl/patch-with-headers url data headers` | PATCH with headers |
| `curl/delete url` | DELETE |
| `curl/delete-with-data url data` | DELETE with body |
| `curl/delete-with-headers url headers` | DELETE with headers |
| `curl/head url` | HEAD (returns response headers) |
| `curl/options url` | OPTIONS |
| `curl/status` | Last HTTP status code |
| `curl/response-headers` | Last response headers as JSON |

## Requirements

- Lum Lisp interpreter (`ll`)
- `curl` CLI
