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

load(
    "@musl-toolchain//musl-toolchain/types:manifest.bzl",
    manifest_from_flat_dict = "from_flat_dict",
    manifest_get_default = "default",
    manifest_to_flat_dict = "to_flat_dict",
)

load_symbols({
    "manifest_get_default": manifest_get_default,
    "manifest_from_flat_dict": manifest_from_flat_dict,
    "manifest_to_flat_dict": manifest_to_flat_dict,
})
