# Publish Anaconda Package

A Github Action to build and *optionally* publish your software package to an Anaconda repository.

### Default behaviour

All of the input variables and defaults can be found in [action.yml](https://github.com/paskino/conda-package-publish-action/blob/update-readme/action.yml)

The default settings result in the default behaviour being that the package is built and tested for linux with `numpy=1.18` and `python=3.7`, but not published.

If `publish` is set to `True`, then this single variant is published.

For all variants to be built, tested, and (if `publish` is True) published, `test_all` must be set to `True`.

### Example workflow
This workflow has the following behaviour:

When pushing to master *all* variants are built and tested.

- If pushing to master, all variants are built and tested.
- If an [annotated](https://git-scm.com/book/en/v2/Git-Basics-Tagging) tag is created, all variants are built, tested and published.
- If opening or modifying a pull request to master, a single variant is built and tested, but not published.
- Builds using channels: conda-forge, ccpi, and paskino.
- Builds for linux and conda converts to windows and macOS as well, in the case that all variants are being built.

```yaml
name: conda_build

on:
  release:
    types: [published]
  push:
    branches: [ master ]
    tags:
      - '**'
  pull_request:
    branches: [ master ]
    
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - name: publish-to-conda
      uses: paskino/conda-package-publish-action@master
      with:
        subDir: 'conda'
        channels: 'conda-forge -c ccpi -c paskino'
        AnacondaToken: ${{ secrets.ANACONDA_TOKEN }}
        publish: ${{ github.event_name == 'push' && startsWith(github.event.ref, 'refs/tags') }}
        test_all: ${{(github.event_name == 'push' && startsWith(github.event.ref, 'refs/tags')) || (github.ref == 'refs/heads/master')}}
```

### Example project structure

```
.
├── LICENSE
├── README.md
├── myproject
│   ├── __init__.py
│   └── myproject.py
├── conda
│   ├── build.sh
│   └── meta.yaml
├── .github
│   └── workflows
│       └── publish_conda.yml
├── .gitignore
```

### ANACONDA_TOKEN

1. Get an Anaconda token (with read and write API access) at `anaconda.org/USERNAME/settings/access` 
2. Add it to the Secrets of the Github repository as `ANACONDA_TOKEN`

### Build Channels
By Default, this Github Action will search for conda build dependancies (on top of the standard channels) in `conda-forge` and `bioconda`
