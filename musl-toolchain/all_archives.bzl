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

load(":archive.bzl", "Archive", "new_archive")
load(":types.bzl", "Architecture", "Mode", "Platform")

X86_64_LINUX_NATIVE = new_archive(
    arch = Architecture("x86_64"),
    platform = Platform("linux"),
    mode = Mode("native"),
    gcc_version = "11",
    sha256 = "eb1db6f0f3c2bdbdbfb993d7ef7e2eeef82ac1259f6a6e1757c33a97dbcef3ad",
)

def get_default_archive_for(arch: Architecture, platform: Platform, mode: Mode) -> Archive | None:
    if arch == Architecture("x86_64"):
        if platform == Platform("linux"):
            if mode == Mode("native"):
                return X86_64_LINUX_NATIVE
    warning("No default archive for [arch={arch},platform={platform},mode={mode}]".format(
        arch = arch,
        platform = platform,
        mode = mode,
    ))
    return None
