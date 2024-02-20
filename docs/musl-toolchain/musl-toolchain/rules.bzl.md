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
