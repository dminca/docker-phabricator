# Phabricator by Phacility on Docker
Phabricator (pronounced like the word fabricator) is a suite of web applications which make it easier to build software, particularly when working with teams. Phabricator is largely based on Facebook's internal tools.

The major components of Phabricator are:
- **Differential**, a code review tool; and
- **Diffusion**, a repository browser; and
- **Maniphest**, a bug tracker; and
- **Phriction**, a wiki.

Phabricator also includes a number of smaller tools.

## Prerequisites
For the app to function properly, the following [**MUST**][1] be present:
- basic LNMP configuration
  - PHP v5.2+
  - PHP-FPM
- MySQL

The following [**SHOULD**][1] also be installed:
- APC ( `pecl install apc` ) via [`php-pear`][2]

[1]: https://tools.ietf.org/html/rfc2119
[2]: http://pkgs.alpinelinux.org/packages?name=php-pear

