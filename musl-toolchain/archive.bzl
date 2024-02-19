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

load(":types.bzl", "Architecture", "Mode", "Platform")

# Prefix in the archive.
_ARCHIVE_PREFIX_FORMAT = "{arch}-{platform}-musl-{mode}"

# Base URL to download musl toolchains.
_BASE_URL_FORMAT = "https://more.musl.cc/{gcc_version}/{arch}-{platform}-musl/{arch}-{platform}-musl-{mode}.tgz"

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
)

def _build_url(arch: Architecture, platform: Platform, mode: Mode, gcc_version: str) -> str:
    """Builds the URL to fetch the archive.

      Args:
        arch:
          Target architecture.
        platform:
          Target platform.
        mode:
          Target mode.
        gcc_version:
          GCC version.

      Returns:
        The URL string.
    """

    return _BASE_URL_FORMAT.format(
        gcc_version = gcc_version,
        arch = arch.value,
        platform = platform.value,
        mode = mode.value,
    )

def _build_prefix(arch: Architecture, platform: Platform, mode: Mode) -> str:
    """Builds the prefix of an archive.

      Args:
        arch:
          Target architecture.
        platform:
          Target platform.
        mode:
          Target mode.

      Returns:
        The prefix within the archive.
    """
    return _ARCHIVE_PREFIX_FORMAT.format(
        arch = arch.value,
        platform = platform.value,
        mode = mode.value,
    )

def new_archive(arch: Architecture, platform: Platform, mode: Mode, gcc_version: str, sha256: str) -> Archive:
    """Defines a new archive.

      Args:
        arch:
          Target architecture.
        platform:
          Target platform.
        mode:
          Target mode.
        gcc_version:
          GCC version.
        sha256:
          SHA-256 sum of the archive.

      Returns:
        An `Archive`.
    """

    return Archive(
        url = _build_url(
            arch = arch,
            platform = platform,
            mode = mode,
            gcc_version = gcc_version,
        ),
        arch = arch,
        platform = platform,
        mode = mode,
        prefix = _build_prefix(
            arch = arch,
            platform = platform,
            mode = mode,
        ),
        sha256 = sha256,
    )
