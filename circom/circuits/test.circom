pragma circom 2.1.0;
pragma custom_templates;

include "poseidon/poseidon.circom";
include "poseidon/poseidon_custom.circom";

template Test(nInputs) {

    assert(nInputs == 2 || nInputs == 4 || nInputs == 6 || nInputs == 8 || nInputs == 16);

    signal input inputs[nInputs];
    signal input initialState;

    signal output out;

    signal custPoseidon[nInputs + 1] <== CustomPoseidon(nInputs)(inputs, initialState);

    signal poseidon[nInputs + 1] <== Poseidon(nInputs)(inputs, initialState);

    // component poseidon = Poseidon(nInputs);
    // poseidon.inputs <== inputs;
    // poseidon.initialState <== initialState;

    for(var i = 0; i < nInputs + 1; i++) {
        poseidon[i] === custPoseidon[i];
    }

    out <== poseidon[0];
    // out <== custPoseidon[0];
}

component main = Test(4);