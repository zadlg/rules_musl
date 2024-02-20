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
    "@prelude//cxx:cxx_toolchain_types.bzl",
    "BinaryUtilitiesInfo",
    "CCompilerInfo",
    "CxxCompilerInfo",
    "CxxPlatformInfo",
    "CxxToolchainInfo",
    "LinkerInfo",
    "PicBehavior",
    "ShlibInterfacesMode",
    "cxx_toolchain_infos",
)
load("@prelude//cxx:headers.bzl", "HeaderMode")
load("@prelude//cxx:linker.bzl", "is_pdb_generated")
load("@prelude//linking:link_info.bzl", "LinkOrdering", "LinkStyle")
load("@prelude//linking:lto.bzl", "LtoMode")
load("@prelude//toolchains/msvc:tools.bzl", "VisualStudio")
load("@prelude//utils:cmd_script.bzl", "ScriptOs", "cmd_script")
load(":providers.bzl", "ArchiveInfo")

def _define_cxx_toolchain_impl(ctx: AnalysisContext):
    """Implements rule `define_cxx_toolchain`.

      Args:
        ctx:
          Analysis context.

      Returns:
        List of providers.
    """

    ar_info = ctx.attrs.archive[ArchiveInfo]
    manifest = ar_info.ar.manifest
    sysroot = ar_info.src

    def get_subtarget(target: str) -> Dependency:
        return ar_info.src.sub_target(target)

    return [
        DefaultInfo(),
    ] + cxx_toolchain_infos(
        platform_name = ctx.attrs.platform_name,
        c_compiler_info = CCompilerInfo(
            compiler = cmd_args(get_subtarget(manifest.tools.c_compiler)[DefaultInfo].default_outputs[0]),
            compiler_type = "linux",
            compiler_flags = cmd_args(sysroot[DefaultInfo].default_outputs, format = "--sysroot={}"),
            preprocessor = get_subtarget(manifest.tools.pp_compiler),
            preprocessor_flags = cmd_args(sysroot[DefaultInfo].default_outputs, format = "--sysroot={}"),
            dep_files_processor = sysroot[DefaultInfo].default_outputs,
        ),
        cxx_compiler_info = CCompilerInfo(
            compiler = cmd_args(get_subtarget(manifest.tools.cxx_compiler)[DefaultInfo].default_outputs[0]),
            compiler_type = "linux",
            compiler_flags = cmd_args(sysroot[DefaultInfo].default_outputs, format = "--sysroot={}"),
            preprocessor = get_subtarget(manifest.tools.pp_compiler),
            preprocessor_flags = cmd_args(sysroot[DefaultInfo].default_outputs, format = "--sysroot={}"),
            dep_files_processor = sysroot[DefaultInfo].default_outputs,
        ),
        linker_info = LinkerInfo(
            archiver = cmd_args(get_subtarget(manifest.tools.ar)[DefaultInfo].default_outputs[0]),
            archiver_flags = [],
            binary_extension = "",
            object_file_extension = "o",
            static_library_extension = "a",
            linker = cmd_args(get_subtarget(manifest.tools.linker)[DefaultInfo].default_outputs[0]),
            linker_flags = cmd_args(),
            shlib_interfaces = ShlibInterfacesMode("enabled"),
        ),
        binary_utilities_info = BinaryUtilitiesInfo(
            strip = get_subtarget(manifest.tools.strip),
            objcopy = cmd_args(get_subtarget(manifest.tools.objcopy)[DefaultInfo].default_outputs[0]),
        ),
        header_mode = HeaderMode("symlink_tree_with_header_map"),
    )

define_cxx_toolchain = rule(
    impl = _define_cxx_toolchain_impl,
    doc = "musl-based CXX toolchain",
    attrs = {
        "archive": attrs.dep(
            doc = "Archive containing the toolchain",
            providers = [ArchiveInfo],
        ),
        "platform_name": attrs.string(
            doc = """
    Platform name.
    """,
            default = "x86_64",
        ),
    },
    is_toolchain_rule = True,
)
