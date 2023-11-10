
# Circom Examples 

This is a repository with simple Circom examples.

## Preliminaries

### Install node
First off, make sure you have a recent version of `Node.js` installed. While any version after `v12` should work fine, we recommend you install `v16` or later.

If you’re not sure which version of Node you have installed, you can run:

```sh
node -v
```

To download the latest version of Node, see [here](https://nodejs.org/en/download/).

### Install snarkjs

To install `snarkjs` run:

```sh
npm install -g snarkjs@latest
```

If you're seeing an error, try prefixing both commands with `sudo` and running them again.


## Examples

There are three main different examples that you can find in this repository.

### Poseidon

In this repo one can find two different, although equivalent, templates that calculate a poseidon hash. The first one is the regular poseidon implementation found in `circomlib`, while the second one is an implementation using `custom gates`. One can learn more about custom gates here: ´https://docs.circom.io/circom-language/templates-and-components/#custom-templates´.

You can compile the circuit using

```sh
npm run compile-example-inspect
```

Then, witness can be generated either with JS:

```sh
npm run gen-witness-js
```

or C++:

```sh
npm run gen-witness-cpp
```

And finally either generate a Fflonk proof:

```sh
npm run fflonk
```

or a Groth16 proof:

```sh
npm run groth16
```


### Inspect usage

To motivate the usage of inspect when developing a circuit with Circom, we have gotten a fragment of the circuits used for verifying BLS signature on this repo: ´https://github.com/yi-sun/circom-pairing´. Early this year, the following post was published on Medium: ´https://medium.com/veridise/circom-pairing-a-million-dollar-zk-bug-caught-early-c5624b278f25´ uncovering a bug in one of the templates. 

One can easily check that, by simply running the circom compilation with `--inspect`, that bug would have been found.

This can be tested with the following command:

```sh
npm run compile-example-inspect
```

One can learn more about inspect usage in the following link: ´https://docs.circom.io/circom-language/code-quality/inspect/´

### Tags and Anonymous usage

To improve readibility of the code, it is highly recommended to introduce `anonymous components` when writing circuits using circom. https://docs.circom.io/circom-language/anonymous-components-and-tuples/

Also, adding tags is a good way to ensure that the code signals have different properties.

It is important to highlight that the compiler does never make any check about the validity of the tags. It is the programmer's responsability to include the constraints and executable code to guarantee that the inteded meaning of each signal is always true. https://docs.circom.io/circom-language/tags/

To learn more about usage of different tags, one can find in `circom/circuits/tags` some of the circomlib libraries with tags implemented