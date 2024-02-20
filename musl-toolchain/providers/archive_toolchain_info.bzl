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

load("@musl-toolchain//musl-toolchain/types:archive.bzl", "Archive")

ArchiveToolchainInfo = provider(
    doc = "Toolchain related info from an archive",
    fields = {
        # System root.
        "sysroot": provider_field(Artifact | None),

        # C compiler.
        "cc": provider_field(RunInfo),

        # C++ compiler.
        "cxx": provider_field(RunInfo),

        # Pre-processor compiler.
        "pp": provider_field(RunInfo),

        # Linker.
        "ld": provider_field(RunInfo),

        # Archiver.
        "ar": provider_field(RunInfo),

        # Strip utility.
        "strip": provider_field(RunInfo),

        # Objcopy utility.
        "objcopy": provider_field(RunInfo),

        # System include directories.
        "include": provider_field(Artifact),

        # Library directories.
        "libs": provider_field(Artifact),

        # Static libc.
        "libc_static": provider_field(Artifact),

        # Shared libc.
        "libc_shared": provider_field(Artifact),

        # Static libstdc++.
        "libstdcxx_static": provider_field(Artifact),

        # Shared libstdc++.
        "libstdcxx_shared": provider_field(Artifact),
    },
)
