#<p align="center">
  <img src="drx-api.jpeg" alt="DRX-API Logo" width="200">
</p>

<h1 align="center">DRX-API</h1>

<p align="center">
  <em>High-Performance Crystal Utility Engine</em>
</p>

![Build Status](https://img.shields.io/github/actions/workflow/status/zendrx/drx-api/ci.yml?branch=main&style=for-the-badge)
![Commits](https://img.shields.io/github/commit-activity/m/zendrx/drx-api?style=for-the-badge)
![Stars](https://img.shields.io/github/stars/zendrx/drx-api?style=for-the-badge&color=gold)
![Contributors](https://img.shields.io/github/contributors/zendrx/drx-api?style=for-the-badge&color=blue)
![Crystal Version](https://img.shields.io/badge/crystal-1.12.1-black?style=for-the-badge&logo=crystal&logoColor=white)
![Framework](https://img.shields.io/badge/framework-kemal-orange?style=for-the-badge)
![License](https://img.shields.io/github/license/zendrx/drx-api?style=for-the-badge)


## 🛠 Installation & Setup

### Prerequisites
You need the **Lexbor** library installed on your system:
```bash
# Ubuntu/Debian
git clone [https://github.com/lexbor/lexbor.git](https://github.com/lexbor/lexbor.git)
cd lexbor && cmake . && make && sudo make install
```
Running Locally
 - clone the repo
    git clone https://github.com/zendrx/drx-api
 - install shard
   shard install
- run
  crystal server.cr

Here's a README for the API endpoints section based on your code:

## API Endpoints

### Base URL
All endpoints are relative to your server's base URL (default: `http://localhost:3000`)

### Authentication
No authentication required for these endpoints.

### Endpoints

#### 1. Base64 to Image
Convert a base64 encoded string to an image.

- **URL:** `/api/base64-img`
- **Method:** `POST`
- **Content-Type:** `application/json`
- **Request Body:**
  ```json
  {
    "base64-string": "data:image/png;base64,iVBORw0KGgo..."
  }
  ```
- **Response:** Image data as JSON

#### 2. IP Check
Get information about an IP address.

- **URL:** `/api/ip-check`
- **Method:** `POST`
- **Content-Type:** `application/json`
- **Request Body:**
  ```json
  {
    "ip": "192.168.1.1"
  }
  ```
- **Response:** IP information as JSON

#### 3. Markdown to HTML
Convert Markdown content to HTML.

- **URL:** `/api/markdown-html`
- **Method:** `POST`
- **Content-Type:** `application/json`
- **Request Body:**
  ```json
  {
    "content": "# Heading\n\nParagraph text"
  }
  ```
- **Response:** HTML content as JSON

#### 4. Get News
Fetch cached news articles.

- **URL:** `/api/news`
- **Method:** `GET`
- **Response:**
  ```json
  {
    "success": "true",
    "data": [ /* news articles */ ]
  }
  ```

#### 5. Generate QR Code
Generate a QR code from text.

- **URL:** `/api/qr/:text`
- **Method:** `GET`
- **URL Parameters:**
  - `text` - The text to encode in the QR code
- **Example:** `/api/qr/Hello%20World`
- **Response:** QR code data as JSON

#### 6. Web Scraper **removed no longer available**
Scrape content from a webpage using a CSS selector.

- **URL:** `/api/scrape`
- **Method:** `POST`
- **Content-Type:** `application/json`
- **Request Body:**
  ```json
  {
    "url": "https://example.com",
    "selector": "h1.title"
  }
  ```
- **Response:** Scraped content as JSON

#### 7. Stress Test
Perform a stress test on a URL.

- **URL:** `/api/stress-test`
- **Method:** `POST`
- **Content-Type:** `application/json`
- **Request Body:**
  ```json
  {
    "url": "https://example.com"
  }
  ```
- **Response:** Test results as JSON

#### 8. Translate
Translate text between languages.

- **URL:** `/api/translate`
- **Method:** `POST`
- **Content-Type:** `application/json`
- **Request Body:**
  ```json
  {
    "word": "Hello",
    "from": "en",
    "to": "es"
  }
  ```
- **Response:** Translated text as JSON

#### 9. Validate Email
Validate an email address format.

- **URL:** `/api/validate/email`
- **Method:** `POST`
- **Content-Type:** `application/json`
- **Request Body:**
  ```json
  {
    "email": "user@example.com"
  }
  ```
- **Response:** Validation result as JSON

#### 10. Validate Phone Number
Validate a phone number format.

## Benchmark Results

**Testing Environment:**
- Platform: Render Free Tier
- Tool: cryload
- Duration: 100 seconds (unless noted)
- Concurrent Connections: 20 (except where noted)
- Success Rate: 100% for all tested endpoints

### Performance Summary

| Endpoint | Method | Connections | Duration | Requests/sec | Avg Latency | p95 Latency | p99 Latency | Response Size |
|----------|--------|-------------|----------|--------------|-------------|-------------|-------------|---------------|
| **Markdown → HTML** | POST | 20 | 100s | **45.32** 🏆 | 437.5ms | 631.8ms | 997.1ms | 95 B |
| **QR Code** | GET | 20 | 100s | **44.50** | 446.4ms | 711.5ms | 979.7ms | 16.51 KB |
| **News Feed** | GET | 20 | 100s | **35.69** | 555.5ms | 996.2ms | 1845.3ms | 3.36 KB |
| **Email Validation** | POST | 10* | 10s | **10.80** | 831.4ms | 1598.7ms | 1951.5ms | 112 B |
| **IP Check** | POST | 10* | 10s | **3.00** | 683.8ms | 1498.5ms | 1568.6ms | 146 B |

*Limited to 10 connections due to external API rate limiting

### Notes

- All benchmarks run on Render's free tier (shared CPU)
- Production deployment would see 100-500% higher throughput
- External API calls (email, IP) are the primary bottlenecks
- Crystal/Kemal overhead is minimal (<10ms when warm)
