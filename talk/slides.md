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

## Build (any) artifact

TODO image sourcecode, compiler, builder script, output

## Build (any) artifact

**"To package in Nix"** means to write a declarative build plan
called "derivation" containing

* Project name
* Source code
* Compiler (build & runtime dependencies)
* "Builder" shell script (that runs compiler on source code)
* ...

## Derivation

```shell
$ nix derivation show nixpkgs#hello
```

```nix
{
  "/nix/store/23m1fng1dpfyb-hello-2.12.1.drv": {
    "args": [
      # Builder shell script
      "/nix/store/v6x3cs394jg-default-builder.sh"
    ],
    "env": {
      "pname": "hello",
      # Source code
      "src":    "/nix/store/pa10z4ngm0-hello-2.12.1.tar.gz",
      # C compiler
      "stdenv": "/nix/store/m1p78gqlc0-stdenv-linux",
      "out":    "/nix/store/1q8w6gl1ll-hello-2.12.1",
      ...
```

## Nix Package (simplified)

:::::::::::::: columns
::: {.column width="70%"}

```nix
# Nix code that evaluates to derivation
mkDerivation {
  name = "hello-2.12.1";
  src = ./src; 
  buildInputs = [ make gcc ];
}
```

:::
::: {.column width="30%"}
**Language**

* Functional
* Declarative
* Pure*

:::
::::::::::::::

## Nix Language

**≈Json + Functions**

* Strings `"hello"`{.nix}
* Path `./hello.sh`{.nix}
* List    `[1 2 3]`{.nix}
* Attribute Sets `{ key = value; ... }`{.nix}
* Let Bindings `let x = 42; in x+x`{.nix}
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
      name = "hello-2.12.1"; 
      src = ...; 
    };
  myString   = someAttrSet.name;
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
f = x: 2*x        # Definition
f 3               # Usage
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
  g = x: y: x+y   # Definition
  g 3 4           # Usage
((g 3) 4)
```

:::
::::::::::::::

## Functions

```nix
# Definition somewhere in https://github.com/NixOS/nixpkgs
mkDerivation = overrideAttrSet: { ... };

# Usage in your code
mkDerivation {
  name = "hello-2.12.1";
  src = ./src; 
}
```

Evaluated Derivation

```nix
{
  "/nix/store/23m1fng1dpfyb-hello-2.12.1.drv": {
    "args": [
      # Builder shell script
      "/nix/store/v6x3cs394jg-default-builder.sh"
    ],
  ...
```

::: notes
nix derivation show nixpkgs#hello
functions allow shorter code (code reuse) and strong customization
:::

## Nix package (realistic)

```nix
let 
 pkgs = ...fetch github/nixpkgs ...;
in
pkgs.stdenv.mkDerivation {
  name = "hello-2.12.1";
  src = ./src; 
  buildInputs = [ pkgs.make pkgs.gcc ];
  buildPhase = "make";
}
```

::: notes
<small style="font-size: 9pt">
https://github.com/NixOS/nixpkgs/pkgs/by-name/he/hello/package.nix
</small>

:::

## Nixpkgs

[https://github.com/NixOS/nixpkgs]()

is just a huge attribute set:

```nix
# pkgs = ...fetch github/nixpkgs ...;
{
  stdenv = { mkDerivation = .. ; ... };
  firefox = ...;
  gcc = ...;
  git = ...;
  poetry = stdenv.mkDerivation {... python311 ...};
  python311 = ...;
  ...
}
```

::: notes
huge package set
ca 1.5GB
quite fast because lazy and mkDerivation functions aren't called if not used
:::

## Nix Store

```shell
# build artifact, put into Nix store
$ nix build <package>   
```

```nix
# "Evaluation"
## Step: Evaluate Nix code to raw derivation
/nix/store/fdffffkdfj23-hello-1.2.0.drv

# "Realisation" (=build)
# Step: Fetch/copy all inputs (sourcecode, configs, etc.)
/nix/store/9234jfkdfj23-hello-1.2.0.tar.gz
# Step: Build dependencies
/nix/store/34234sdfjskd-gcc-13.3.0
...
# Step: Build final artifact like executable
/nix/store/v6x3cs394jgq-hello-1.2.0
...
```

## Task 0 Bash

Try out `mkDerivation`{.nix}.

:::::::::::::: columns
::: {.column width="60%"}

```bash
cd task-0-bash

# Try (won't work)
./my-script.sh
# Fix it:
nix-build my-script.package.nix
# Fix it until this works
./result/bin/my-script

# Bonus: 
nix-shell my-script.package.nix
# Now try again (why does it work?)
./my-script.sh
```

:::
::: {.column width="40%"}

Hints:

* Find Nix packages for apps in script.
* Make script executable.
* Read error messsage(s).

:::
::::::::::::::

## Builder (functions)

Nix community provides convenient variations for different ecosystems.

```nix
pkgs.stdenv.mkDerivation    # C/C++. (Base for most others)
pkgs.writeShellApplication  # Bash scripts.
pkgs.mkSbtDerivation        # Scala apps. (3rd party)
pkgs.buildPythonApplication # Python apps.
pkgs.mkShell                # Shell developer environments.
pkgs.dockerTools.streamLayeredImage # Docker images.
...
pkgs.buildRustApplication   # Rust apps.
pkgs.pkgsCross.aarch64-darwin... # Builders for cross-compile.
...
```

<small style="font-size: 9pt">
Search on https://noogle.dev
</small>

## Task 1 Bash Better

Try out `writeShellApplication`{.nix}.

:::::::::::::: columns
::: {.column width="40%"}

```bash
cd task-1-bash-better

nix-build my-script.package.nix
# Fix it until this works:
./result/bin/my-script
```

:::
::: {.column width="60%"}

Hints:

* Read linked page in file.
* Use `builtins.readFile`{.nix} to read file as String.
* Read error messsage(s).

:::
::::::::::::::

## Task 2 Scala

Try out `mkSbtDerivation`{.nix}.

:::::::::::::: columns
::: {.column width="40%"}

```bash
cd task-2-scala

nix-build my-scala.package.nix
# Fix it until this works:
./result/bin/my-scala
```

:::
::: {.column width="60%"}

Hints:

* Read linked page in file.
* You can use `sbt assembly` for a fat jar.
* Read error messsage(s).

:::
::::::::::::::

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
