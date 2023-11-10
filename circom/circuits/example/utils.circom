pragma circom 2.1.5;

template checkIsBinary(n) {
    signal input in[n];
    signal output {binary} out[n];

    for(var i = 0; i < n; i++) {
        in[i] * (in[i] - 1) === 0;
        out[i] <== in[i];
    }
}

template AND() {
    signal input a;
    signal input b;
    signal output out;

    out <== a*b;
}

template AND_tags() {
    signal input {binary} a;
    signal input {binary} b;
    signal output {binary} out;

    out <== a*b;
}

/*
    Given an array [0..n) returns the slice [m..r)
*/
template Slice(n, m, r) {
    assert(0 <= m);
    assert(m <= r);
    assert(r <= n);
    signal input {binary} in[n];
    signal output {binary} out[r - m];

    _ <== in;
    for(var i = m; i < r; i++) {
        out[i - m] <== in[i];
    }    

}