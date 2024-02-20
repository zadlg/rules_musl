# Copyright 2024 github.com/zadlg
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Manifest of an archive that points to relevant tools.
ArchiveManifestTools = record(
    # C compiler.
    c_compiler = str,

    # C++ compiler.
    cxx_compiler = str,

    # Preprocessor compiler.
    pp_compiler = str,

    # Linker.
    linker = str,

    # ar.
    ar = str,

    # strip.
    strip = str,

    # objcopy.
    objcopy = str,
)

# Manifest of an archive that points to relevant libraries.
ArchiveManifestLibraries = record(
    # libc.
    libc = str,

    # libstd++.
    libstdcxx = str,
)

# Manifest of an archive that points to relevent files.
ArchiveManifest = record(
    # Tools.
    tools = ArchiveManifestTools,

    # Include directory.
    include_dir = str,

    # Library directory.
    lib_dir = str,

    # Static libraries.
    static_libs = ArchiveManifestLibraries,

    # Shared libraries.
    shared_libs = ArchiveManifestLibraries,
)

def default() -> ArchiveManifest:
    """Builds a generic archive manifest.

      Returns:
        An `ArchiveManifest`.
    """

    return ArchiveManifest(
        tools = ArchiveManifestTools(
            c_compiler = "bin/gcc",
            cxx_compiler = "bin/g++",
            pp_compiler = "bin/cpp",
            linker = "bin/ld",
            ar = "bin/ar",
            strip = "bin/strip",
            objcopy = "bin/objcopy",
        ),
        include_dir = "include",
        lib_dir = "lib",
        static_libs = ArchiveManifestLibraries(
            libc = "lib/libc.a",
            libstdcxx = "lib/libstdc++.a",
        ),
        shared_libs = ArchiveManifestLibraries(
            libc = "lib/libc.so",
            libstdcxx = "lib/libstdc++.so",
        ),
    )

def to_flat_dict(manifest: ArchiveManifest) -> dict:
    """Converts the manifest into a flat dictionary.

      Args:
        manifest:
          Archive manifest.

      Returns:
        Dictionary.
    """

    return {
        "tools/c_compiler": manifest.tools.c_compiler,
        "tools/cxx_compiler": manifest.tools.cxx_compiler,
        "tools/pp_compiler": manifest.tools.pp_compiler,
        "tools/linker": manifest.tools.linker,
        "tools/ar": manifest.tools.ar,
        "tools/objcopy": manifest.tools.objcopy,
        "tools/strip": manifest.tools.strip,
        "include_dir": manifest.include_dir,
        "lib_dir": manifest.lib_dir,
        "static_libs/libc": manifest.static_libs.libc,
        "static_libs/libstdcxx": manifest.static_libs.libstdcxx,
        "shared_libs/libc": manifest.shared_libs.libc,
        "shared_libs/libstdcxx": manifest.shared_libs.libstdcxx,
    }

def from_flat_dict(d: dict) -> ArchiveManifest:
    """Converts a flat dictionary into an `ArchiveManifest`.

      Args:
        d:
          The dictionary.

      Returns:
        The archive manifest.
    """

    def get_or_fail(k: str, k2: str | None = None) -> str:
        if k2 != None:
            k = "{k}/{k2}".format(k = k, k2 = k2)
        v = d.get(k) or fail("key '{k} does not exist in the flat dictionary.".format(k = k))
        return v

    return ArchiveManifest(
        tools = ArchiveManifestTools(
            c_compiler = get_or_fail("tools", "c_compiler"),
            cxx_compiler = get_or_fail("tools", "cxx_compiler"),
            pp_compiler = get_or_fail("tools", "pp_compiler"),
            linker = get_or_fail("tools", "linker"),
            ar = get_or_fail("tools", "ar"),
            strip = get_or_fail("tools", "strip"),
            objcopy = get_or_fail("tools", "objcopy"),
        ),
        include_dir = get_or_fail("include_dir"),
        lib_dir = get_or_fail("lib_dir"),
        static_libs = ArchiveManifestLibraries(
            libc = get_or_fail("static_libs", "libc"),
            libstdcxx = get_or_fail("static_libs", "libstdcxx"),
        ),
        shared_libs = ArchiveManifestLibraries(
            libc = get_or_fail("shared_libs", "libc"),
            libstdcxx = get_or_fail("shared_libs", "libstdcxx"),
        ),
    )
