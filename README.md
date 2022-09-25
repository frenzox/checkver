# checkver

POSIX shell script that checks whether the provided version fulfills the provided version requirement(s).

## Installation

```
# Download the script and save it to /usr/local/bin
wget -O /usr/local/bin/checkver https://raw.githubusercontent.com/frenzox/checkver/main/checkver

# Make script executable
chmod +x /usr/local/bin/checkver

# Prove it works
checkver -V
```

You probably want to make sure the directory where you install `checkver` to is included in your `PATH`.

## Usage

See examples from `checkver -h`:

```
Usage: checkver [OPTION] <version> <requirements,...>
Checks if the provided version fulfills the provided requirement(s)

Options:
  -h                 Display this help and exit
  -V                 Output version information and exit

Positional arguments:
  version            Version string to test, semver compliant
  requirement        Comma separated requirements string

Examples:
  checkver "1.0.1" "1.0.0"
  checkver "1.0.1" "^1.0.0"
  checkver "2.2.1" "~2"
  checkver "1.0.0" "=1.0.0"
  checkver "1.0.0" ">=1.0.0"
  checkver "1.5.0" ">1.0.0, <=2.0.0"

Supported operators for the requirement string:
 >, >=, <, <=, =, ~, ^

The semantics for the check follow the one from Cargo:
https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html#specifying-dependencies-from-cratesio
```

## TODO

- [ ] Add support for `pre-release` versions
- [ ] Add support for `build` metadata
