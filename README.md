# ConanCuda
Boilerplate Code for a Cuda + NCCL Conan project

## Toolchain Environment Variables:
Set the toolchain env variables [here](./conanfile.py#L15)

Example:
```python
cached_env_vars = {
    "CMAKE_CUDA_ARCHITECTURES": "80 86 87",
    "CMAKE_CUDA_FLAGS": ("--extended-lambda --threads 4"),
    "CMAKE_POSITION_INDEPENDENT_CODE": "ON"
}
```
***NOTE: These are mainly for nvcc cmake configurations***
## Conan Libraries

One-stop shop in [conandata.yml](./conandata.yml)


```yaml
requirements:
  - "conan_lib/version"

```

