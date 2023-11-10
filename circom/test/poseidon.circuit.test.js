const chai = require("chai");
const path = require("path");
const wasm_tester = require("circom_tester").wasm;

const buildPoseidon = require("circomlibjs").buildPoseidon;

describe("Poseidon Circuit test", function () {
    let poseidon;
    let F;
    let circuit;

    this.timeout(1000000);

    before( async () => {
        poseidon = await buildPoseidon();
        F = poseidon.F;
        circuit = await wasm_tester(path.join(__dirname, "..", "circuits", "test.circom"), {verbose: true, O: 1});
    });

    it("Should check constrain of hash([1, 2, 3, 4]) t=4", async () => {
        const inputs = [1, 2, 3, 4];

        const inp = {
            inputs,
            initialState: 0,
        };

        const w = await circuit.calculateWitness(inp, true);

        const res = poseidon(inputs);

        await circuit.assertOut(w, {out : F.toObject(res)});
    });

});