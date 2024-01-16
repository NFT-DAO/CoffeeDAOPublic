
async function connectWallet (wallet) {
    try{
        const cd =  await import( './lucid-cardano/esm/src/mod.js');
        const lucid = await cd.Lucid.new(
          new cd.Maestro({
            network: "Mainnet",
            apiKey: getKey(),
            turboSubmit: true
          }),
          "Mainnet"
          );
          let api;
          if(wallet == "nami"){
            api = await window.cardano.nami.enable();
          } else if(wallet == "lucid"){
            api = await window.cardano.lucid.enable();
          } else if(wallet == "lace"){
            api = await window.cardano.lace.enable();
          } else if(wallet == "yoroi"){
            api = await window.cardano.yoroi.enable();
          } else if(wallet == "eternl"){
            api = await window.cardano.eternl.enable();
          } else if(wallet == "flint"){
            api = await window.cardano.flint.enable();
          } else {
            api = await window.cardano.typhon.enable();
          }
         lucid.selectWallet(api);
         return {"l": lucid};
      }
    catch(e){
      const er = `"Wallet Error. Please try again. ${e.info}"`;
      return `{"error": ${er}}`;
    }
  }
  
  async function readValidator() {
    try{
      const response = await fetch("./plutus.json");
      const jResp = await response.json();
      const validator = jResp
        .validators[0];
        return {
            type: "PlutusV2",
            script: validator.compiledCode
        }
      } catch (e) {
       return `{"error": "Unable to readValidator. Please try again. ${e}"}`;
     }
    }
  
  async function purchaseFrontStart(premium, arweaveId, wallet) {
    let tx;
    let userWitness;
    try{
      const cWallet = await connectWallet(wallet);
      if(cWallet.error){
        return cWallet;
      }else{
        const cd =  await import( './lucid-cardano/esm/src/mod.js');
        let cost;
        let MintAction;
        const lucid = cWallet.l;
          const mintingPolicy = await readValidator();
          if(mintingPolicy.error){
            return mintingPolicy;
          }else{
            const policyId = lucid.utils.mintingPolicyToId(
              mintingPolicy,
            );
            const assetID = "CDAO OC: " + arweaveId.substr(15,21);
            const arSub = cd.fromText(assetID);
            const asset = policyId + arSub;
            if(premium == "true"){
              MintAction = () => cd.Data.to(new cd.Constr(1, []));
              cost = 130_000_000;
            } else {
              MintAction = () => cd.Data.to(new cd.Constr(0, []));
              cost = 120_000_000;
            }
            const filename= "https://arweave.net/" + arweaveId;
            const metadata = {
              [policyId]: {
                [assetID]: {
                  "description":[],
                  "image": filename,
                  "mediaType": "image/png",
                  "name": assetID
                }
            },
            "version": "1.0"
            };
            try{
              tx = await lucid
                .newTx().addSigner("")
                .payToAddress("", {lovelace: BigInt(cost)})
                .mintAssets( {[asset]: 1n}, MintAction())
                .validTo(Date.now() + 100000)
                .attachMintingPolicy(mintingPolicy)
                .attachMetadata(721, metadata)
                .complete();
            } catch (e) {
              console.log("Tx Constructor Error:",e);
              return `{"error": "Tx Constructor Error: ${e}"}`;
            }
            try{
              userWitness = await tx.partialSign();
            } catch (e) {
              console.log("Purchase UserWitness Error: ",e);
              return `{"error": "Purchase UserWitness Error ${e}"}`;
            }
            return `{"tx": "${tx}", "witness": "${userWitness}"}`;
        }
      } 
    }catch (e) {
      console.log("Purchase Error: ", e);
      return `{"error": "Unable to complete your purchase. Please try again. ${e}"}`;
    }
  }