import {
          Maestro,
          Lucid,
        } from "./deps.ts";

const m = Deno.env.get('MAESTRO_PRE');
const lucid = await Lucid.new(
  new Maestro({
    network: "Preprod",
    apiKey: m as string,
    turboSubmit: true
  }),
  "Preprod",// TODO
);

export async function mintNFT(
  witness: string,
  tx: string,
): Promise<object> {
  let daoWitness;
  let signedTx;
  let txObj;
  try {
    const mnemonic = Deno.env.get('WALLET')
    lucid.selectWalletFromSeed(mnemonic);
    txObj = lucid.fromTx(tx);
    daoWitness = await txObj.partialSign();
    signedTx = await txObj.assemble([daoWitness, witness]).complete();
    const txHash = await lucid.provider.submitTx(signedTx.toString());
    return {"txhash": JSON.stringify(txHash)};
  } catch (error) {
    return {"error": JSON.stringify(error)};
  }
}
 
// export async function burnNFT(
//   name: string,
// ): Promise<TxHash> {
//   const unit: Unit = policyId + fromText(name);

//   const tx = await lucid
//     .newTx()
//     .mintAssets({ [unit]: -1n })
//     .validTo(Date.now() + 100000)
//     .attachMintingPolicy(mintingPolicy)
//     .complete();

//   const signedTx = await tx.sign().complete();

//   const txHash = await signedTx.submit();

//   return txHash;
// }
