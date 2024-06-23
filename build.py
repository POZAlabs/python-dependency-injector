import shutil
from pathlib import Path
from typing import Any

from setuptools import Distribution, Extension
from setuptools.command.build_ext import build_ext

SOURCE_DIR = Path("src", "dependency_injector")


EXTENSIONS = [
    Extension(
        "dependency_injector.containers",
        [str(SOURCE_DIR.joinpath("containers.c"))],
        extra_compile_args=["-O3"],
    ),
    Extension(
        "dependency_injector.providers",
        [str(SOURCE_DIR.joinpath("providers.c"))],
        extra_compile_args=["-O3"],
    ),
    Extension(
        "dependency_injector._cwiring",
        [str(SOURCE_DIR.joinpath("_cwiring.c"))],
        extra_compile_args=["-O3"],
    ),
]


def build(setup_kwargs: dict[str, Any]):
    distribution = Distribution(
        {"ext_modules": EXTENSIONS},
    )
    cmd = build_ext(distribution)
    cmd.finalize_options()
    cmd.run()

    for output in cmd.get_outputs():
        relative_extension = Path("src", Path(output).relative_to(cmd.build_lib))
        shutil.copyfile(output, relative_extension)
