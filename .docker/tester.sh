#!/bin/sh

client=$(curl --location "${AUTHZ_ADMIN_URL}/admin/clients/" \
--connect-timeout 60 \
--header 'Content-Type: application/json' \
--data '{
    "public":true,
    "client_name": "My App",
    "client_secret": null,
    "token_endpoint_auth_method": "none",
    "grant_types": ["authorization_code","refresh_token"],
    "response_types":["code","id_token","access_token"],
    "redirect_uris":["http://localhost:3000/callback","http://127.0.0.1:3000/callback"],
    "scope": "offline_access offline openid profile email",
    "allowed_cors_origins": ["http://localhost:3000","http://127.0.0.1:3000"],
    "client_secret_expires_at": 1764690070000,
    "skip_consent": true
}')

clientId=$(echo $client | jq -r '.client_id')

echo "Copy paste this link to a browser to start the flow:"
echo "${AUTHZ_PUBLIC_URL}/oauth2/auth?client_id=$clientId&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fcallback&response_type=code&scope=profile+email&state=bf0cdf4dfdde44b9b462dda6c99799ee&code_challenge=P3oXKisSfh5qKbpZfhvt8kccIcoEL8sTptehav1Ht-I&code_challenge_method=S256&response_mode=query";