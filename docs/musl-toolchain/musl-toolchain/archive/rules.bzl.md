## Architecture

```python
Architecture: function
```

---
## Archive

```python
Archive: function
```

---
## ArchiveInfo

```python
ArchiveInfo: provider_callable
```

---
## ArchiveManifest

```python
ArchiveManifest: function
```

---
## ArchiveToolchainInfo

```python
ArchiveToolchainInfo: provider_callable
```

---
## Mode

```python
Mode: function
```

---
## Platform

```python
Platform: function
```

---
## archive

```python
def archive(
    *,
    name: str,
    default_target_platform: None | str = _,
    target_compatible_with: list[str] = _,
    compatible_with: list[str] = _,
    exec_compatible_with: list[str] = _,
    visibility: list[str] = _,
    within_view: list[str] = _,
    metadata: opaque_metadata = _,
    tests: list[str] = _,
    arch: str,
    gcc_version: str = _,
    manifest: dict[str, str],
    mode: str,
    platform: str,
    sha256: str,
    src: str,
    strip_prefix: None | str,
    url: str
) -> None
```

#### Parameters

* `name`: name of the target
* `default_target_platform`: specifies the default target platform, used when no platforms are specified on the command line
* `target_compatible_with`: a list of constraints that are required to be satisfied for this target to be compatible with a configuration
* `compatible_with`: a list of constraints that are required to be satisfied for this target to be compatible with a configuration
* `exec_compatible_with`: a list of constraints that are required to be satisfied for this target to be compatible with an execution platform
* `visibility`: a list of visibility patterns restricting what targets can depend on this one
* `within_view`: a list of visibility patterns restricting what this target can depend on
* `metadata`: a key-value map of metadata associated with this target
* `tests`: a list of targets that provide tests for this one
* `arch`: Target architecture.
* `gcc_version`: GCC version.
* `manifest`: The manifest of the archive.
* `mode`: Mode.
* `platform`: Target platform.
* `sha256`: SHA-256 sum of the archive.
* `src`: Source of the archive.
* `strip_prefix`: Prefix to strip from the content of the archive.
* `url`: URL to the archive.


---
## manifest\_from\_flat\_dict

```python
def manifest_from_flat_dict(d: dict[typing.Any, typing.Any]) -> ArchiveManifest
```

Converts a flat dictionary into an `ArchiveManifest`.

#### Returns

The archive manifest.

#### Details

d:
    The dictionary.

---
## manifest\_get\_default

```python
def manifest_get_default() -> ArchiveManifest
```

Builds a generic archive manifest.

#### Returns

An `ArchiveManifest`.

---
## manifest\_to\_flat\_dict

```python
def manifest_to_flat_dict(
    manifest: ArchiveManifest
) -> dict[typing.Any, typing.Any]
```

Converts the manifest into a flat dictionary.

#### Returns

Dictionary.

#### Details

manifest:
    Archive manifest.

---
## native

```python
native: struct(..)
```

---
## new\_archive

```python
def new_archive(
    name: str,
    arch: Architecture,
    platform: Platform,
    mode: Mode,
    gcc_version: str,
    sha256: str,
    manifest: ArchiveManifest = record[ArchiveManifest](tools=record[ArchiveManifestTools](c_compiler="bin/gcc", cxx_compiler="bin/g++", pp_compiler="bin/cpp", linker="bin/ld", ar="bin/ar", strip="bin/strip", objcopy="bin/objcopy"), include_dir="include", lib_dir="lib", static_libs=record[ArchiveManifestLibraries](libc="lib/libc.a", libstdcxx="lib/libstdc++.a"), shared_libs=record[ArchiveManifestLibraries](libc="lib/libc.so", libstdcxx="lib/libstdc++.so")),
    visibility: list[typing.Any] = ["PRIVATE"]
)
```
