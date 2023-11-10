pragma circom 2.0.3;

include "comparators.circom";

template AND() {
    signal input a;
    signal input b;
    signal output out;

    out <== a*b;
}

template OR() {
    signal input a;
    signal input b;
    signal output out;

    out <== a + b - a*b;
}

/*
Inputs:
    - BigInts a, b
Output:
    - out = (a < b) ? 1 : 0
*/
template BigLessThan(n, k){
    signal input a[k];
    signal input b[k];
    signal output out;

    component lt[k];
    component eq[k];
    for (var i = 0; i < k; i++) {
        lt[i] = LessThan(n);
        lt[i].in[0] <== a[i];
        lt[i].in[1] <== b[i];
        eq[i] = IsEqual();
        eq[i].in[0] <== a[i];
        eq[i].in[1] <== b[i];
    }

    // ors[i] holds (lt[k - 1] || (eq[k - 1] && lt[k - 2]) .. || (eq[k - 1] && .. && lt[i]))
    // ands[i] holds (eq[k - 1] && .. && lt[i])
    // eq_ands[i] holds (eq[k - 1] && .. && eq[i])
    component ors[k - 1];
    component ands[k - 1];
    component eq_ands[k - 1];
    for (var i = k - 2; i >= 0; i--) {
        ands[i] = AND();
        eq_ands[i] = AND();
        ors[i] = OR();

        if (i == k - 2) {
           ands[i].a <== eq[k - 1].out;
           ands[i].b <== lt[k - 2].out;
           eq_ands[i].a <== eq[k - 1].out;
           eq_ands[i].b <== eq[k - 2].out;
           ors[i].a <== lt[k - 1].out;
           ors[i].b <== ands[i].out;
        } else {
           ands[i].a <== eq_ands[i + 1].out;
           ands[i].b <== lt[i].out;
           eq_ands[i].a <== eq_ands[i + 1].out;
           eq_ands[i].b <== eq[i].out;
           ors[i].a <== ors[i + 1].out;
           ors[i].b <== ands[i].out;
        }
     }
     _ <== eq_ands[0].out;
     out <== ors[0].out;
}

function get_BLS12_381_prime(n, k){
    var p[50];
    assert( (n==96 && k==4) || (n==77 && k==5) || (n==55 && k==7));
    if( n==96 && k==4 ){
        p = [54880396502181392957329877675, 31935979117156477062286671870, 20826981314825584179608359615, 8047903782086192180586325942];
    }
    if( n==77 && k==5 ){
        p = [151110683138771015150251, 101672770061349971921567, 5845403419599137187901, 110079541992039310225047, 7675079137884323292337];
    }
    if( n==55 && k==7 ){
        p = [35747322042231467, 36025922209447795, 1084959616957103, 7925923977987733, 16551456537884751, 23443114579904617, 1829881462546425];
    }
    return p;
}

// Inputs:
//   - pubkey as element of E(Fq)
//   - hash represents two field elements in Fp2, in practice hash = hash_to_field(msg,2).
//   - signature, as element of E2(Fq2) 
// Assume signature is not point at infinity 
template CoreVerifyPubkeyG1(n, k){
    signal input pubkey[2][k];
    signal input signature[2][2][k];
    signal input hash[2][2][k];
     
    var q[50] = get_BLS12_381_prime(n, k);

    component lt[10];
    // check all len k input arrays are correctly formatted bigints < q (BigLessThan calls Num2Bits)
    for(var i=0; i<10; i++){
        lt[i] = BigLessThan(n, k);
        for(var idx=0; idx<k; idx++)
            lt[i].b[idx] <== q[idx];
    }
    for(var idx=0; idx<k; idx++){
        lt[0].a[idx] <== pubkey[0][idx];
        lt[1].a[idx] <== pubkey[1][idx];
        lt[2].a[idx] <== signature[0][0][idx];
        lt[3].a[idx] <== signature[0][1][idx];
        lt[4].a[idx] <== signature[1][0][idx];
        lt[5].a[idx] <== signature[1][1][idx];
        lt[6].a[idx] <== hash[0][0][idx];
        lt[7].a[idx] <== hash[0][1][idx];
        lt[8].a[idx] <== hash[1][0][idx];
        lt[9].a[idx] <== hash[1][1][idx];
    } 

    // ...
}


component main = CoreVerifyPubkeyG1(55, 7);