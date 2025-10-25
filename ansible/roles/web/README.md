# Custom Web Role

Highly opinionated, custom role for managing websites.

As an example of an opinionated choice, this role only supports HTTPS traffic and uses Nginx only (no Apache).
Most browsers will (or should be configured to) use HTTPS by default now and a CDN/WAF layer in front of this is presumed to redirect HTTP traffic to HTTPS.
Additionally, it will only use Cloudflare DNS validation for creating certificates with certbot.

> [!WARNING]
> This role is under heavy development; things are not stable and may break.

## Supported Stacks

This role has a concept of profiles, which are in part used to determine which functions are enabled for a site and, where applicable, which configs should be used.

Some profiles that exist are:

* `static` - simple static site
* `redirect` - provides a more advanced redirect config than allowed in other profiles
* `proxy` - reverse proxy to another service
* `healthcheck` - simple "healthcheck" endpoint to see if the server is up
* `wordpress` - WordPress site (note: remember to configure the `mysql` and `php` stacks as well)

## Config

In your `host_vars/`, create a file for the host you want to use this role on.

### Certificates

Certbot uses DNS challenges via Cloudflare.
Credentials are required and must be an API **Token** (Global API Key is not allowed).

```yaml
certbot_cloudflare_api_token: !vault |
  $ANSIBLE_VAULT;1.2;AES256;myvault
  ...
```

### PHP Versions

Due to how PHP uses the version in the config path (`/etc/php/<version>/`), specific versions need to be specified.
In the future, hopefully this won't be necessary.

The first version in the list will be used as the default for sites one isn't explicitly defined.

```yaml
php_versions:
- "8.1"
```

### Server IPs

This will create automatic allow rules for the specified IPs where appropriate.
For example, some WordPress plugins will make calls to the website over the public internet (rather than internally).
This allows those tasks to run by allowing the calls from the server to itself (even though it gets routed outside the server).

See also: `sites[].admin_ips`

```yaml
server_ips:
- 1.2.3.4
- ffff::0000
```

### security.txt

A `security.txt` file can be configured for the whole server.
Per RFC, at least one `Contact` and the `Expires` properties must be set.
Per RFC, contacts must start with `mailto:` or `https://`

If an expires property is not set, there's an `auto_expire` property that can be set to `true`.
This will cause Ansible to auto-generate an expiration date that's one year from the beginning of the current month (in UTC+0)

```yaml
security_txt:
  contacts:
  - "..."
  auto_expire: true
  preferred_languages:
  - "..."
```

### Sites

> IMPORTANT: DO NOT change your site's `id` after it's been created - doing so may break things.

Basic structure:

```yaml
sites:
- name: My Site
  id: mysite
  ...
```

Required fields:

```yaml
- name: Description of the website # (used for providing hints, e.g. log messages, in a few places)
  id: mysite # must be unique and match `[a-z0-9]+`
  domain: example.com # Primary domain for the site
  enabled: true # Whether to create the symlink in `sites-enabled/`
  profile: static # Nginx config template; see above
```

Basic additional/optional fields:

> Note on domains: WordPress doesn't like it when multiple domains directly resolve to the same instance.
> To account for this, the additional domains will be redirected to the primary domain.
> This behavior is also used in other configs, for example, `static`, however, that is open to change, possibly via a config option.

```yaml
  additional_domains: # Used in creating certs and Nginx config. Note that this can't update existing certs (at least not yet).
  - www.example.com
  - example.net

  directory: mysite # Create a directory for the site. Will be in `/var/www/<directory>` unless an absolute path in `/home/` is given

  siteuser: true # Create a dedicated, restricted user for the site to run as. Required for PHP sites.
  user: www-mysite # Name of the site user account

  group: mygroup # Group permissions, e.g. if the site has shared access. The web server's www-data user will be added to allow read permissions. Permissions will be set to `2770` on the directory if this is set.

  certid: "mysite-cert" # override name of certbot cert (defaults to `id`)
  logfileid: "mysite-new" # override name for access and error logs (will have access/error suffix appended)

  robots: noindex # robots.txt template to use
  cors: "*" # Set the CORS "Access-Control-Allow-Origin" header
```

Database options:

```yaml
  db_type: mysql # note that this uses mariadb for mysql; this may be changed in the future
  db_name: dbname
  db_user: dbuser
  db_pass: !vault |
    $ANSIBLE_VAULT;1.2;AES256;myvault
    ...
```

Nginx rewrites:

```yaml
  # This example would create a redirect for:
  # rewrite ^/abc/(.*).png https://example.com/xyz/$1.png permanent;
  rewrites:
  - comment: "(Example) Redirect PNG images in abc/ to xyz/"
    enabled: true
    permanent: true # will use "permanent" flag if true and the "redirect" flag if false
    pattern: "^/abc/(.*).png"
    location: "https://example.com/xyz/$1.png"
    #location_block: "/tags/" # The location block directive is only allowed to be used in the redirect profile (to reduce complexity).
    # In the redirect profile, Nginx `location {}` blocks will be created in the order they appear, with the exception of "/",
    # which is both the default and will always appear last to serve as a fallback. This value can be any Nginx location pattern,
    # including exact or regex matching (e.g. "= /security.txt" or "~ \.php$")
```

Application/use case-specific options:

```yaml
  # Specify additional admin IPs, these will be used where appropriate in Nginx allow directives
  admin_ips:
  - "100.64.0.0/10"
  - "fd7a:115c:a1e0:ab12::/64"

  php_version: "8.1" # Set the PHP version; must be in the php_versions list. Will default to first in php_versions list if not specified

  wp_cache: w3tc # (WIP) WordPress cache plugin for Nginx advanced `try_files` options; options are `wpsc` (WP Super Cache) or `w3tc` (W3 Total Cache)
  wp_salts: !vault ... # WP salt variables; do something like: `curl https://api.wordpress.org/secret-key/1.1/salt/ | ansible-vault encrypt_string --stdin-name wp_salts`

  location: https://.../ # Upstream/backend location for simple proxying (not yet implemented)
```
