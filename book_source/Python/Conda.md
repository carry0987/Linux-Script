## Conda

### Set default env to `test`
`activate.py` is [hardcoded](https://github.com/conda/conda/blob/f072c34da40e3534bdf04bef4c13f0180901605c/conda/activate.py#L162-L163) to emit `conda activate base\n` into your shell profile when you evaluate the shell hook produced by `conda shell.zsh hook`.


You can suppress this hardcoded "auto-activate base" via:
```bash
conda config --set auto_activate_base false
```

Create `test` env:
```bash
conda create -n test
```

Then, in `~/.zshrc`, `~/.bashrc` or wherever you source your shell profile from, you can append the following (after the conda shell hook) to **explicitly** activate the environment of your choosing:
```bash
conda activate test
```

Then close and reopen the terminal, you will see the `test` env is activated by default.
