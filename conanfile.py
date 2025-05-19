# SPDX‑License‑Identifier: MIT
import sys

import yaml
from conan import ConanFile
from conan.tools.cmake import (
    CMake,
    CMakeToolchain,
    CMakeDeps,
)

import os

"""
This is for the CmakeToolchain object for the conan_toolchains.cmake
"""
variables = {
    "CMAKE_CUDA_ARCHITECTURES": "80;86;87",
    "CMAKE_CUDA_FLAGS": ("--extended-lambda --threads 4"),
    "CMAKE_POSITION_INDEPENDENT_CODE": "ON"
}

"""
This is for the CmakeToolchain object for the conan_toolchains.cmake
"""
cached_env_vars = {
    # "CMAKE_PROJECT_TOP_LEVEL_INCLUDES": f"{os.getcwd()}/conan_provider.cmake",
    # "CONAN_COMMAND": f"{os.getcwd()}/venv_linux/bin/conan",
    # "CUSTOM_CUDA_ARCHITECTURES": "80;86;87",
    # "CMAKE_CUDA_FLAGS": ("--extended-lambda --threads 4"),
    # "CMAKE_POSITION_INDEPENDENT_CODE": "ON",
}


class Requirements:

    def __init__(self, conan_file: ConanFile):
        script_path = os.path.realpath(__file__)
        script_dir = os.path.dirname(script_path)
        self.conan_file = conan_file
        with open(f"{script_dir}/conandata.yml", 'r') as conandata:
            self.conan_requirements: list[str] = yaml.safe_load(conandata).get("requirements", [])

    def resolve_requirements(self):
        for conan_requirement in self.conan_requirements:
            self.conan_file.requires(conan_requirement)


class ConanCuda(ConanFile):
    name = "ConanCuda"
    version = "1.0.0"
    license = "MIT"
    # author          = "Your Name <you@example.com>"
    # url             = "https://github.com/your_org/my_cuda_app"
    description = "Minimal but complete CUDA/C++ application"
    topics = ("cuda", "cmake", "conan2", "gpgpu")
    package_type = "application"

    # ---------------------------------------------------------------------
    # ♦ Settings ♦
    # ---------------------------------------------------------------------
    settings = (
        "os",  # Windows, Linux, macOS…
        "compiler",  # gcc/clang/msvc (must support CUDA nvcc host compiling)
        "build_type",  # Release / Debug
        "arch"  # x86_64, armv8, etc.
    )

    # For CUDA we normally do NOT list "cuda" here; nvcc is detected via PATH.
    # If you need pinned toolkits, use a requirement such as nvidia-cuda/12.2.

    # ---------------------------------------------------------------------
    # ♦ Layout ♦  (Conan automatically sets the `layout` folder‑tree)
    # ---------------------------------------------------------------------
    def layout(self):
        from conan.tools.layout import basic_layout
        basic_layout(
            self,
            # src_folder="src"
        )  # keeps sources under ./src

    # ---------------------------------------------------------------------
    # ♦ Toolchain generation ♦
    # ---------------------------------------------------------------------
    def generate(self):
        toolchain_var = CMakeToolchain(self)

        for environment_variable in variables.keys():
            toolchain_var.variables[environment_variable] = variables[environment_variable]

        for cached_env_var in cached_env_vars.keys():
            toolchain_var.cache_variables[cached_env_var] = cached_env_vars[cached_env_var]

        toolchain_var.generate()

        deps = CMakeDeps(self)
        deps.generate()

    # ---------------------------------------------------------------------
    # ♦ No external requirements in this minimal template ♦
    #   (Add versions you already downloaded, e.g. thrust/2.0.0 or fmt/10.2.1)
    # ---------------------------------------------------------------------
    def requirements(self):
        Requirements(self).resolve_requirements()

    # ---------------------------------------------------------------------
    # ♦ Build — delegates to CMake ♦
    # ---------------------------------------------------------------------
    def build(self):
        cmake = CMake(self)
        cmake.configure()  # uses the toolchain files put in `generate()`
        cmake.build()

    # ---------------------------------------------------------------------
    # ♦ Package — place the final binary under `bin/` ♦
    # ---------------------------------------------------------------------
    def package(self):
        bin_folder = os.path.join(self.build_folder, "bin")
        self.copy(self.name, dst="bin", src=bin_folder, keep_path=False)

    # ---------------------------------------------------------------------
    # ♦ Package Info — export PATH helper ♦
    # ---------------------------------------------------------------------
    def package_info(self):
        self.env_info.PATH.append(os.path.join(self.package_folder, "bin"))


def cached_vars_force():
    return "\n".join(list(map(lambda variable: f"set({variable} \"{variables[variable]}\" CACHE STRING \"definition override {variable}\" FORCE)" ,variables.keys())))
if __name__ == "__main__":
    print(eval(f"{sys.argv[1]}()"))
