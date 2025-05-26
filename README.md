# platform-developer-docs-redirect

This project is a redirect service using Caddy to redirect legacy URLs to the new [platform-developer-docs](https://github.com/bcgov/platform-developer-docs) location.

## About

The project uses:
- Dockerfile with Caddy web server
- Caddyfile configuration for redirects 
- CI workflow for automated testing

## Local Testing

You can test the redirects locally using Docker or Podman:

```bash
# Build the image
podman build -t redirect-test .

# Run the container
podman run --rm -p 2015:2015 redirect-test

# Run the automated tests
./scripts/test-redirects.sh localhost 2015

# Or test individual redirects manually
curl -I http://localhost:2015/sysdig-monitor-onboarding/
```


