load(":archive.bzl", "Archive")

def download_archive(name, archive: Archive):
    native.http_archive(
        name = name,
        urls = [archive.url],
        sha256 = archive.sha256,
        strip_prefix = archive.prefix,
        type = "tar.gz",
    )
