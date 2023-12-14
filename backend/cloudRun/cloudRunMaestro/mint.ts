import {
          Maestro,
          Lucid,
        } from "./deps.ts";

const m = Deno.env.get('MAESTRO');
// console.log('MAESTRO:', m);
const lucid = await Lucid.new(
  new Maestro({
    network: "Mainnet",
    apiKey: m as string,
    turboSubmit: true
  }),
  "Mainnet",// TODO
);

export async function mintNFT(
  witness: string,
  tx: string,
): Promise<object> {
  let daoWitness;
  let signedTx;
  let txObj;
  try {
    console.log('55555555555555555 mintNFT ',tx);
    const mnemonic = Deno.env.get('WALLET')
    lucid.selectWalletFromSeed(mnemonic);
    txObj = lucid.fromTx(tx);
    daoWitness = await txObj.partialSign();
    signedTx = await txObj.assemble([daoWitness, witness]).complete();
    const txHash = await lucid.provider.submitTx(signedTx.toString());
    console.log('55555555555555555 txHash ',txHash);
    return {"txhash": JSON.stringify(txHash)};
  } catch (error) {
    console.error('999999999999999 Error mintNFT error:', typeof(error), error);
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
