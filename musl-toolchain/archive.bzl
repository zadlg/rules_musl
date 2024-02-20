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

load(":providers.bzl", "ArchiveInfo")
load(":archive_manifest.bzl", "get_generic_manifest", "manifest_from_flat_dict", "manifest_to_flat_dict")
load(":types.bzl", "Architecture", "ArchiveManifest", "Mode", "Platform")

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

    # Manifest.
    manifest = ArchiveManifest,
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

def _archive_impl(ctx: AnalysisContext) -> list[Provider]:
    """Implementation of rule `archive`.

      Args:
        ctx:
          Analysis context.

      Returns:
        List of providers.
    """

    arch = Architecture(ctx.attrs.arch)
    platform = Platform(ctx.attrs.platform)
    mode = Mode(ctx.attrs.mode)
    manifest = manifest_from_flat_dict(ctx.attrs.manifest)

    return [
        DefaultInfo(),
        ArchiveInfo(
            ar = Archive(
                url = ctx.attrs.url,
                arch = arch,
                platform = platform,
                mode = mode,
                prefix = ctx.attrs.strip_prefix,
                sha256 = ctx.attrs.sha256,
                manifest = manifest,
            ),
            src = ctx.attrs.src,
        ),
    ]

archive = rule(
    impl = _archive_impl,
    attrs = {
        "arch": attrs.enum(
            Architecture.values(),
            doc = """
  Target architecture.
  """,
        ),
        "platform": attrs.enum(
            Platform.values(),
            doc = """
  Target platform.
  """,
        ),
        "mode": attrs.enum(
            Mode.values(),
            doc = """
  Mode.
  """,
        ),
        "url": attrs.string(
            doc = """
  URL to the archive.
  """,
        ),
        "strip_prefix": attrs.option(
            attrs.string(),
            doc = """
  Prefix to strip from the content of the archive.
  """,
        ),
        "gcc_version": attrs.string(
            default = "11",
            doc = """
  GCC version.
  """,
        ),
        "sha256": attrs.string(
            doc = """
  SHA-256 sum of the archive.
  """,
        ),
        "src": attrs.dep(
            doc = """
  Source of the archive.
  """,
        ),
        "manifest": attrs.dict(
            key = attrs.string(),
            value = attrs.string(),
            doc = """
  The manifest of the archive.
  """,
        ),
    },
)

def new_archive(
        name: str,
        arch: Architecture,
        platform: Platform,
        mode: Mode,
        gcc_version: str,
        sha256: str,
        manifest: ArchiveManifest = get_generic_manifest(),
        visibility: list = ["PRIVATE"]):
    url = _build_url(
        arch = arch,
        platform = platform,
        mode = mode,
        gcc_version = gcc_version,
    )

    strip_prefix = _build_prefix(
        arch = arch,
        platform = platform,
        mode = mode,
    )

    manifest_dict = manifest_to_flat_dict(manifest)

    ar_target_name = "{name}.ar".format(name = name)
    native.http_archive(
        name = ar_target_name,
        urls = [url],
        sha256 = sha256,
        strip_prefix = strip_prefix,
        sub_targets = manifest_dict.values(),
        visibility = visibility,
    )

    archive(
        name = name,
        arch = arch.value,
        platform = platform.value,
        mode = mode.value,
        url = url,
        strip_prefix = strip_prefix,
        gcc_version = gcc_version,
        sha256 = sha256,
        src = ":{ar}".format(ar = ar_target_name),
        manifest = manifest_dict,
        visibility = visibility,
    )
