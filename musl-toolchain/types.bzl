load(":architecture.bzl", "Architecture")
load(":mode.bzl", "Mode")
load(":platform.bzl", "Platform")

load_symbols({
    "Architecture": Architecture,
    "Mode": Mode,
    "Platform": Platform,
})
