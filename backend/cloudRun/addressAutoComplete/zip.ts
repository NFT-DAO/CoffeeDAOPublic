import { xml2js } from './deps.ts';

export async function getZip(
  street: string,
  city: string,
  state: string
): Promise<string> {
  const url = `https://secure.shippingapis.com/shippingapi.dll?API=ZipCodeLookup&XML=<ZipCodeLookupRequest USERID="19RESE5049E77"><Address ID="0"><Address1></Address1><Address2>${street}</Address2><City>${city}</City><State>${state}</State><Zip5></Zip5><Zip4></Zip4></Address></ZipCodeLookupRequest>`;
  const headers = {
    'Content-Type': 'text/xml',
  };

  const requestOptions = {
    method: 'POST',
    headers: headers,
  };
  const resp = await fetch(url, requestOptions);
  const body = await resp.text();
  console.log('body',typeof(body),body);
  const obj = xml2js(body, {
    compact: true,
  });
  console.log('obj',typeof(obj),obj);
  if(obj["ZipCodeLookupResponse"]["Address"]["Error"]){
    console.log('Error');
    return'error';
  } else {
    const zip = obj["ZipCodeLookupResponse"]["Address"]["Zip5"]["_text"];
    return zip;
  }
} 