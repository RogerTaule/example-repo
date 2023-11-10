pragma circom 2.1.5;

include "utils.circom";

template MultiAND(n) {
    signal input {binary} in[n];
    signal output {binary} out;

    if (n==1) {
        out <== in[0];
    } else if (n==2) {
        out <== AND_tags()(in[0], in[1]);
    } else {
        signal {binary} left <== MultiAND(n\2)(Slice(n, 0, n\2)(in));
        signal {binary} right <== MultiAND(n-n\2)(Slice(n, n\2, n)(in));
        out <== AND_tags()(left, right);
    }
}

template Main(n) {
    signal input in[n];
    signal output out;

    signal {binary} inbin[n] <== checkIsBinary(n)(in);

    out <== MultiAND(n)(inbin);
}

component main = Main(5); 