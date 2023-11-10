pragma circom 2.1.5;

include "bitify.circom";

template Main(n) {

    signal input a;

    signal output bits[n];

    bits <== Num2Bits(n)(a);
}

component main = Main(8);