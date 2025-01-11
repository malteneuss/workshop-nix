---
author: Malte Neuss
title: Nix Workshop
---

## Nix Package Manager

> "... reproducible, declarative and reliable systems."

![](img/nix-logo.svg){ width=40% }

<small style="font-size: 9pt">
By Tim Cuthbertson CC BY 4.0, https://nixos.org
</small>

## Content

:::::::::::::: columns
::: {.column width="50%"}
![](img/nix-logo.svg){ width=60% }

:::
::: {.column width="50%"}
**Nix**

* Language
* Builders
* Package Bash
* Package Scala
* Package Python
* Package Developer Environments
* Package Docker Images

:::
::::::::::::::

::: notes
manager installable on windows, mac, linux
several copies of app in different versions
deployable like Ansible, Terraform
about as many packages as Arch Linux AUR

Nix lang = Json + functions
reproducible development environments =>faster onboarding
switching between projects is easy, effortless, fast
containerizsable into docker
:::

## Nix Language

**Goal: Build (any) artifact**

TODO image sourcecode, compiler, builder script, output

**"To package in Nix"** means to write a declarative build plan
called "derivation" containing

* Project name
* Source code
* Compiler (build & runtime dependencies)
* "Builder" shell script (that runs compiler on source code)
* ...

## Nix Language

**Package Derivation raw**

```shell
# Hello World app written in C
$ nix derivation show nixpkgs#hello
```

```nix
{
  "/nix/store/23m1fng1dpfyb3nnchiragwpikv35grv-hello-2.12.1.drv": {
    "args": [
      "-e",
      # Builder shell script
      "/nix/store/v6x3cs394jgqfbi0a42pam708flxaphh-default-builder.sh"
    ],
    "env": {
      "pname": "hello",
      # Source code
      "src": "/nix/store/pa10z4ngm0g83kx9mssrqzz30s84vq7k-hello-2.12.1.tar.gz",
      # C compiler
      "stdenv": "/nix/store/m1p78gqlc0pw3sdbz3rdhklzm0g26g96-stdenv-linux",
      "out": "/nix/store/1q8w6gl1ll0mwfkqc3c2yx005s6wwfrl-hello-2.12.1",
      ...
    },
    ...
  }
}
```

## Nix Language

**Nix Package (simplified)**

:::::::::::::: columns
::: {.column width="70%"}

```nix
mkDerivation {
  name = "hello-1.2.0";
  src = ./src; 
  buildInputs = [ make gcc ];
}
```
:::
::: {.column width="30%"}
**Benefits**

* Functional
* Pure (almost)
* Declarative

:::
::::::::::::::

## Nix Language

**≈Json + Functions**

* Numbers `42`{.nix}
* Strings `"hello"`{.nix}
* List    `[1 2 3]`{.nix}

* Attribute Sets `{ key = value; ... }`{.nix}
* Let Bindings `let x = 42 in x+x`{.nix}
* Functions `f x`{.nix}

::: notes
pure = no side effects, no variables = declarative
functional = first-class support 
lazy = expression is not evaluated until value is needed
* Let-Expressions
* Pattern-Matching
not-general purpose language
dynamically types = no type signatures/compile time
:::

## Attribute Set
```nix
{
  myNumber   = 3;
  myAttrSet  = { 
      name = "hello-1.2.0"; 
      src = ... 
    };
  myString   = myAttrSet.name;
  myFunction = x: 2*x;
}
```

::: notes
adhoc variable declaration
think like const myDerivation
:::


## Functions
:::::::::::::: columns
::: {.column width="50%"}

**Typescript**
```typescript
const f = x => 2x
f(3)
```

:::
::: {.column width="50%"}
**Nix**
```nix
f = x: 2*x        # definition
f 3               # usage
```

:::
::::::::::::::

::: notes
**Math**
```
f: ℝ ⟶ ℝ
f: x ↦ 2x
```
:::


## Functions
**Currying**
```
g: (ℝ,ℝ) ⟶ ℝ                      g: ℝ ⟶ (ℝ ⟶ ℝ)
g: (x,y) ↦ x+y                    g: x ↦ (y ↦ x+y)
```
**Usage**
```
g(3,4)                            g(3)(4)
```

## Functions
:::::::::::::: columns
::: {.column width="50%"}

**Typescript**
```typescript
const g = (x,y) => x+y
g(3,4)
```

:::
::: {.column width="50%"}
**Nix**
```nix
  g = x: y: x+y   # definition
  g 3 4           # usage
((g 3) 4)
```

:::
::::::::::::::

## Functions
```nix
# Definition somewhere in https://github.com/NixOS/nixpkgs
mkDerivation = overrideAttrs: ...

# Usage in your code
mkDerivation {
  name = "myProject-1.0.0";
  src = ./src; 
}
```

**Resulting Derivation**
```nix
{
  "/nix/store/23m1fng1dpfyb3nnchiragwpikv35grv-hello-2.12.1.drv": {
    "args": [
      "-e",
      "/nix/store/v6x3cs394jgqfbi0a42pam708flxaphh-default-builder.sh"
    ],
    ...
  }
}
```

::: notes
nix derivation show nixpkgs#hello
functions allow shorter code (code reuse) and strong customization
:::

## Nix package

```nix
let 
 pkgs = ...;
in
pkgs.stdenv.mkDerivation {
  name = "hello-1.2.0";
  src = ./src; 
  buildInputs = [ pkgs.make pkgs.gcc ];
  buildPhase = "make install";
}
```

<small style="font-size: 9pt">
https://github.com/NixOS/nixpkgs/pkgs/by-name/he/hello/package.nix
</small>

::: notes
:::

## Nixpkgs

<small style="font-size: 9pt">
https://github.com/NixOS/nixpkgs
</small>

is just a huge (JSON-like) attribute set:

```nix
# pkgs =
{
  stdenv = { mkDerivation = .. ; ... }
  ...
  poetry = stdenv.mkDerivation {... python311 ...}
  python311 = ..
  ...
  gcc = ....
  ...
  git = ....
  ...
  firefox = ...
  ...
}
```

<small style="font-size: 9pt">
https://github.com/NixOS/nixpkgs
</small>

::: notes
huge package set
ca 1.5GB
quite fast because lazy and mkDerivation functions aren't called if not used
:::

## Search Packages
![](img/nixos-search.png){ width=70% }
https://search.nixos.org


## Reproducible Builds

```shell
$ nix build <package>   # build artifact, put into store
```

**Nix store**

```shell
# "Evaluation"
## Step: Evaluate Nix code to raw derivation
/nix/store/fdffffkdfj23j45r2102jfd-hello-1.2.0.drv

# "Realisation" (=build)
# Step: Fetch/copy all inputs (sourcecode, configs, etc.)
/nix/store/9234jfkdfj23j45r2102jfd-hello-1.2.0.tar.gz
# Step: Build dependencies
/nix/store/34234sdfjskdfj32j4kjdsf-gcc-13.3.0
...
# Step: Build final artefact (app, folder) into $out variable
/nix/store/v6x3cs394jgqfbi0a42pam7-hello-1.2.0
..
```

Creates local symlink ./result to /nix/store/v6x3cs394jgqfbi0a42pam7-hello-1.2.0

## Task 0 Bash

Learn `mkDerivation`.

```shell
cd task-0-bash

# Try (won't work)
./my-script.sh
# Fix it:
nix-build my-script.package.nix
# Fix it until this works:
./result/bin/my-script

# Bonus: 
nix-shell my-script.package.nix
# Now try again (why does it work?): 
./my-script.sh
```

Hints:

* Find the necessary Nix packages for apps in the script.
* Make the script executable.
* Read the error messsage(s).

## Builder (functions)

Different ecosystems need different tools and build sequences.

Nix provide different variations for convenience.

* `pkgs.stdenv.mkDerivation`: Mainly for C/C++. Base function for many others.
* `pkgs.writeShellApplication`: For Bash scripts.
* `pkgs.buildPythonApplication`: For Python apps.
* `pkgs.mkShell`: For shell developer environments.
* `pkgs.dockerTools.streamLayeredImage`: For Docker images.
* ...
* `pkgs.buildRustApplication`: For Rust apps.
* `pkgs.pkgsCross.aarch64-darwin...`: Same builders but for cross-compilation.
* ...

<small style="font-size: 9pt">
Search on https://noogle.dev
</small>

## Task 1 Bash Better

Learn `writeShellApplication`.

```shell
cd task-1-bash-better

nix-build my-script.package.nix
# Fix it until this works:
./result/bin/my-script
```

Hints:

* Open and read the link in the file.
* You can use `builtins.readFile` to read file as String.
* Read the error messsage(s).

## Further Study

![](img/nix-logo.svg){ width=10% }

:::::::::::::: columns
::: {.column width="50%"}
* **Main Page** https://nixos.org/
* **Nix packages** https://github.com/NixOS/nixpkgs
* **Noogle** https://noogle.dev/
:::
::: {.column width="50%"}

* **My Blog** https://lambdablob.com/
* **Switch Dev Environments** https://direnv.net/

:::
::::::::::::::


::: notes
used by Mozilla for Firefox, Target, Atlassian for Marketplace, Klarna
EU commission
:::
