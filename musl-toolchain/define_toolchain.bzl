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
load(":providers.bzl", "ArchiveInfo", "ArchiveToolchainInfo")

def _define_cxx_toolchain_impl(ctx: AnalysisContext):
    """Implements rule `define_cxx_toolchain`.

      Args:
        ctx:
          Analysis context.

      Returns:
        List of providers.
    """

    ar_info = ctx.attrs.archive[ArchiveInfo]
    ar_toolchain_info = ctx.attrs.archive[ArchiveToolchainInfo]
    manifest = ar_info.ar.manifest
    sysroot = cmd_args(ar_info.src[DefaultInfo].default_outputs[0], format = "--sysroot={}")

    return [
        DefaultInfo(),
    ] + cxx_toolchain_infos(
        platform_name = ctx.attrs.platform_name,
        c_compiler_info = CCompilerInfo(
            compiler = ar_toolchain_info.cc,
            compiler_type = ar_info.ar.platform.value,
            compiler_flags = sysroot,
            preprocessor = ar_toolchain_info.pp,
            preprocessor_flags = sysroot,
            dep_files_processor = ar_info.src[DefaultInfo].default_outputs,
        ),
        cxx_compiler_info = CCompilerInfo(
            compiler = ar_toolchain_info.cxx,
            compiler_type = ar_info.ar.platform.value,
            compiler_flags = sysroot,
            preprocessor = ar_toolchain_info.pp,
            preprocessor_flags = sysroot,
            dep_files_processor = ar_info.src[DefaultInfo].default_outputs,
        ),
        linker_info = LinkerInfo(
            archiver = ar_toolchain_info.ar,
            archiver_type = ar_info.ar.platform.value,
            use_archiver_flags = True,
            archiver_flags = cmd_args(["arD"]),
            archive_objects_locally = True,
            binary_extension = "",
            shared_library_name_format = "{}.so",
            shared_library_name_default_prefix = "lib",
            object_file_extension = "o",
            static_library_extension = "a",
            linker = ar_toolchain_info.ld,
            mk_shlib_intf = ctx.attrs.shared_library_interface_producer,
            type = "gnu",
            linker_flags = cmd_args(),
            link_style = LinkStyle("static_pic"),
            shlib_interfaces = ShlibInterfacesMode("disabled"),
        ),
        binary_utilities_info = BinaryUtilitiesInfo(
            strip = ar_toolchain_info.strip,
            objcopy = ar_toolchain_info.objcopy,
        ),
        header_mode = HeaderMode("symlink_tree_with_header_map"),
        mk_comp_db = ctx.attrs._mk_comp_db,
        mk_hmap = ctx.attrs._mk_hmap,
    )

define_cxx_toolchain = rule(
    impl = _define_cxx_toolchain_impl,
    doc = "musl-based CXX toolchain",
    attrs = {
        "archive": attrs.dep(
            doc = "Archive containing the toolchain",
            providers = [ArchiveToolchainInfo],
        ),
        "platform_name": attrs.string(
            doc = """
    Platform name.
    """,
            default = "x86_64",
        ),
        "_mk_comp_db": attrs.default_only(attrs.exec_dep(providers = [RunInfo], default = "@prelude//cxx/tools:make_comp_db")),
        # FIXME: prelude// should be standalone (not refer to fbsource//)
        "_mk_hmap": attrs.default_only(attrs.exec_dep(providers = [RunInfo], default = "@prelude//cxx/tools:hmap_wrapper")),
        "_msvc_hermetic_exec": attrs.default_only(attrs.exec_dep(providers = [RunInfo], default = "@prelude//windows/tools:msvc_hermetic_exec")),
        "shared_library_interface_producer": attrs.option(attrs.exec_dep(providers = [RunInfo]), default = None),
    },
    is_toolchain_rule = True,
)
