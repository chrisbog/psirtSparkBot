import requests
import sys
import json
from pprint import pprint

API_URL = "https://api.cisco.com/security/advisories"

def get_oauth_token(client_id, client_secret):
    """Get OAuth2 token from api based on client id and secret.
    Args:
        client_id: Client id stored in config file.
        client_secret: Client secret stored in config file.
    Returns:
        The valid access token to pass to api in header.
    Raises:
        If requests exhibits anything other than a 200 response.
    """
    payload = {'client_id': client_id, 'client_secret': client_secret}
    data = {'grant_type': 'client_credentials'}
    r = requests.post("https://cloudsso.cisco.com/as/token.oauth2", params=payload, data=data)
    r.raise_for_status()
    resp = r.json()
    return resp['access_token']

def get_ios_vulnerability(auth_token,iostype,iosversion):

    API_URL = "https://api.cisco.com/security/advisories"

    headers = {"Authorization": "Bearer %s" % auth_token,
               "Accept": "application/json",
               "User-Agent": "psirtQuery"}

    sys.stderr.write("auth_token= " + auth_token + "\n")

    path = iostype+"?version="+iosversion
    queryurl = "{base_url}/{path}".format(base_url=API_URL, path=path)

    sys.stderr.write("URL For Query= " + queryurl + "\n")

    #    path = "iosxe?version=3.16.1S"

    r = requests.get(
        url=queryurl,
        headers=headers)

    sys.stderr.write("Response of Query = " + str(r.status_code) + "\n")


    response = r.json()

    messages = "```"
    messages = messages+"Advisories for IOSXE version: "+iosversion+"\r\n"


    for advisories in response['advisories']:
        messages = messages + advisories['advisoryId']+"\r\n"
    messages = messages+"```"

    return messages