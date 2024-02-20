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

load(":architecture.bzl", "Architecture")
load(":manifest.bzl", "ArchiveManifest")
load(":mode.bzl", "Mode")
load(":platform.bzl", "Platform")

# An archive that contains a musl toolchain.
Archive = record(
    # URL to the archive.
    url = str,

    # Architecture.
    arch = Architecture,

    # Platform.
    platform = Platform,

    # Mode
    mode = Mode,

    # Archive prefix.
    prefix = str,

    # SHA-256 of the archive.
    sha256 = str,

    # Manifest.
    manifest = ArchiveManifest,
)
