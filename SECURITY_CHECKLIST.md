# WebGIS Platform - Security Checklist (MVP)

## Upload Validation
- Enforce allowed extensions: .geojson, .kml
- Enforce allowed MIME types (server-side validation)
- Enforce size limits (UPLOAD_MAX_BYTES, DATA_UPLOAD_MAX_MEMORY_SIZE)
- Reject files without extension or unknown MIME
- Log upload metadata (user, size, type, success/fail)

## Authentication & Authorization
- JWT access/refresh with short access TTL
- Reject missing/invalid tokens
- Object-level permissions for update/delete endpoints
- Rate limit auth endpoints

## Rate Limiting
- Auth endpoints: limit requests per IP per minute
- Upload endpoints: limit requests per IP per minute
- Respond with 429 on limit exceeded

## CORS & CSRF
- Whitelist frontend origin only
- Disable wildcard origin
- Validate CSRF settings if cookie auth is used

## Security Headers & Cookies
- Enable HSTS in production
- Enforce secure cookies in production
- Enable X-Content-Type-Options (nosniff)
- Use X-Frame-Options = DENY

## Safe Media Serving
- Serve media via nginx or object storage in production
- Do not expose directory listings
- Validate download authorization before serving private files

## Logging & Monitoring
- Log auth failures and upload validation failures
- Track request counts for rate limiting
- Monitor 4xx/5xx spikes
