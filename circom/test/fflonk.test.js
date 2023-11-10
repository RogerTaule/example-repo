const path = require("path");
const bfj = require("bfj");
const assert = require("assert");

const { zKey, fflonk } = require("snarkjs");
const { utils, getCurveFromName } = require("ffjavascript");


describe("Fflonk test suite", function () {
    const r1csFilename = path.join("tmp", "test.r1cs");
    const ptauFilename = path.join("tmp", "powersOfTau28_hez_final_15.ptau");
    const zkeyFilename = path.join("tmp", "circuit_fflonk.zkey");
    const wtnsFilename = path.join("tmp", "witness.wtns");
    const vkeyFilename = path.join("tmp", "circuit_vk_fflonk.json");

    this.timeout(1000000000);

    let curve;

    before(async () => {
        curve = await getCurveFromName("bn128");
    });

    after(async () => {
        await curve.terminate();
    });

    it("fflonk full prove", async () => {
        // fflonk setup
        await fflonk.setup(r1csFilename, ptauFilename, zkeyFilename);

        // flonk prove
        const {proof, publicSignals} = await fflonk.prove(zkeyFilename, wtnsFilename);

        // export verification key
        const vKey = await zKey.exportVerificationKey(zkeyFilename);
        await bfj.write(vkeyFilename, utils.stringifyBigInts(vKey), { space: 1 });

        // Verify the proof
        const isValid = await fflonk.verify(vKey, publicSignals, proof);

        assert(isValid);
    });
});