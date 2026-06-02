(Get-Content nginx\nginx.conf) `
-replace 'server green:3000;', 'server blue:3000;' |
Set-Content nginx\nginx.conf

docker cp nginx/nginx.conf nginx:/etc/nginx/nginx.conf

docker exec nginx nginx -s reload