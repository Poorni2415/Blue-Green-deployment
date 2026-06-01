docker build -t bluegreen-app:v2 .

docker run -d --name green -p 8083:3000 bluegreen-app:v2

powershell .\health_check.ps1

# Update nginx.conf
# Reload nginx

docker stop blue
docker rm blue