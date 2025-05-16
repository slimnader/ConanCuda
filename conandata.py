import os
import sys
from typing import Dict

import yaml


class Dependency:

    def __init__(
            self,
            find_package: str,
            upstream_recipe: str = None,
            upstream_recipe_var: str = None,

    ):
        self.find_package = find_package
        if upstream_recipe is None:
            self.upstream_recipe = f"{find_package}::{find_package if upstream_recipe_var is None else upstream_recipe_var}"
        else:
            self.upstream_recipe = upstream_recipe

"""
This is a driver for any packages/target_libs that dont have a single string orthodoxy
e.g:
if not:
    find_package(fmt)
    .....
    .....
    target_link_library(some_exc_or_package_name PRIVATE fmt::fmt)
    

"""
overrides: dict[str, Dependency] = {
    "redis-plus-plus": Dependency(
        find_package="redis++",
        upstream_recipe_var="redis++_static"
    ),
    "gtest": Dependency(
        find_package="GTest",
        upstream_recipe="gtest::gtest"
    )
}


class Dependencies:
    dependencies: list[Dependency] = []

    def __init__(self):
        script_path = os.path.realpath(__file__)
        script_dir = os.path.dirname(script_path)
        requirements: list[str] = []
        with open(f"{script_dir}/conandata.yml", 'r') as conandata:
            requirements = yaml.safe_load(conandata).get("requirements", [])

        self.dependencies = list(
            map(lambda reponame: Dependency(reponame) if reponame not in overrides.keys() else overrides[reponame],
                map(lambda req: req.split("/")[0],
                    requirements)))

    def find_packages(self):
        return ";".join(list(map(lambda dep: dep.find_package, self.dependencies)))

    def upstream_recipes(self):
        return ";".join(list(map(lambda dep: dep.upstream_recipe, self.dependencies)))


dependencies = Dependencies()


def find_packages():
    return dependencies.find_packages()


def upstream_recipes():
    return dependencies.upstream_recipes()


if __name__ == '__main__':
    print(eval(f"{sys.argv[1]}()"))
