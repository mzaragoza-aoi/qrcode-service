# QR Code Generator

A small Rails service that turns incoming text into an SVG QR code.

The app supports both a browser form and a simple HTTP endpoint:

- Web form: `GET /`
- QR SVG endpoint: `GET /qrcode?text=hello`
- QR SVG form post: `POST /qrcodes` with a `text` parameter

## Requirements

- Ruby 3.3.11
- Rails 8.0.5
- PostgreSQL
- Bundler

## Setup

Install dependencies:

```sh
bundle install
```

Create and prepare the local databases:

```sh
bin/rails db:prepare
```

If your shell has a `DATABASE_URL` set for another project, unset it for this app so Rails uses `config/database.yml`:

```sh
env -u DATABASE_URL bin/rails db:prepare
```

## Running The App

Start the development server:

```sh
env -u DATABASE_URL bin/rails server -p 5555
```

Open the form:

```text
http://127.0.0.1:5555
```

Generate a QR code directly:

```text
http://127.0.0.1:5555/qrcode?text=https://example.com
```

The endpoint returns an inline SVG response with:

```text
Content-Type: image/svg+xml
```

## API Usage

Generate a QR code with `GET`:

```sh
curl "http://127.0.0.1:5555/qrcode?text=hello" > qrcode.svg
```

Generate a QR code with `POST`:

```sh
curl -X POST \
  -d "text=hello" \
  "http://127.0.0.1:5555/qrcodes" > qrcode.svg
```

Blank input returns `422 Unprocessable Entity`.

## Tests

Run the test suite:

```sh
env -u DATABASE_URL bin/rails test
```

Run the style checker:

```sh
bundle exec rubocop
```

## Implementation Notes

- QR code generation lives in `app/services/qr_code_generator.rb`.
- HTTP behavior lives in `app/controllers/qrcodes_controller.rb`.
- SVG generation is provided by the `rqrcode` gem.
- The app does not persist QR codes. It generates each SVG response on demand.
