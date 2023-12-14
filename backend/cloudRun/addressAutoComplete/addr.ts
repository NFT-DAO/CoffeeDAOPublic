
export async function getPrd(
  entry: string,
): Promise<object> {
  const key = "AIzaSyAEY8BXdoyXyRQHRn5iHLeuq69gjQhZ85I"
  const resp = await fetch("https://maps.googleapis.com/maps/api/place/queryautocomplete/json?input="+entry+"+in+the+usa&key="+key);
  const body = await resp.json();
  return body;
} 