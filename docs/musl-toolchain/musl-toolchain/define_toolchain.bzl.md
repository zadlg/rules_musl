## ArchiveInfo

```python
ArchiveInfo: provider_callable
```

---
## ArchiveToolchainInfo

```python
ArchiveToolchainInfo: provider_callable
```

---
## BinaryUtilitiesInfo

```python
BinaryUtilitiesInfo: provider_callable
```

---
## CCompilerInfo

```python
CCompilerInfo: provider_callable
```

---
## CxxCompilerInfo

```python
CxxCompilerInfo: provider_callable
```

---
## CxxPlatformInfo

```python
CxxPlatformInfo: provider_callable
```

---
## CxxToolchainInfo

```python
CxxToolchainInfo: provider_callable
```

---
## HeaderMode

```python
HeaderMode: function
```

---
## LinkOrdering

```python
LinkOrdering: function
```

---
## LinkStyle

```python
LinkStyle: function
```

---
## LinkerInfo

```python
LinkerInfo: provider_callable
```

---
## LtoMode

```python
LtoMode: function
```

---
## PicBehavior

```python
PicBehavior: function
```

---
## ScriptOs

```python
ScriptOs: function
```

---
## ShlibInterfacesMode

```python
ShlibInterfacesMode: function
```

---
## VisualStudio

```python
VisualStudio: provider_callable
```

---
## cmd\_script

```python
def cmd_script(
    ctx: context,
    name: str,
    cmd: cmd_args,
    os: ScriptOs
) -> cmd_args
```

---
## cxx\_toolchain\_infos

```python
def cxx_toolchain_infos(
    platform_name,
    c_compiler_info,
    cxx_compiler_info,
    linker_info,
    binary_utilities_info,
    header_mode,
    headers_as_raw_headers_mode = None,
    conflicting_header_basename_allowlist = [],
    asm_compiler_info = None,
    as_compiler_info = None,
    hip_compiler_info = None,
    cuda_compiler_info = None,
    object_format = CxxObjectFormat("native"),
    mk_comp_db = None,
    mk_hmap = None,
    use_distributed_thinlto = False,
    use_dep_files = False,
    clang_remarks = None,
    clang_trace = False,
    cpp_dep_tracking_mode = DepTrackingMode("none"),
    cuda_dep_tracking_mode = DepTrackingMode("none"),
    strip_flags_info = None,
    dist_lto_tools_info: None | DistLtoToolsInfo = None,
    split_debug_mode = SplitDebugMode("none"),
    bolt_enabled = False,
    llvm_link = None,
    platform_deps_aliases = [],
    pic_behavior = PicBehavior("supported"),
    dumpbin_toolchain_path = None
)
```

Creates the collection of cxx-toolchain Infos for a cxx toolchain.

c and c++ compiler infos are required, as is a linker info. The rest are
optional, and it will be an error if any cxx_library or other rules have srcs
of those other types.

---
## define\_cxx\_toolchain

```python
def define_cxx_toolchain(
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
    _mk_comp_db: str = _,
    _mk_hmap: str = _,
    _msvc_hermetic_exec: str = _,
    archive: str,
    platform_name: str = _,
    shared_library_interface_producer: None | str = _
) -> None
```

musl-based CXX toolchain

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
* `archive`: Archive containing the toolchain
* `platform_name`: Platform name.


---
## is\_pdb\_generated

```python
def is_pdb_generated(
    linker_type: str,
    linker_flags: list[resolved_macro | str]
) -> bool
```

---
## native

```python
native: struct(..)
```
