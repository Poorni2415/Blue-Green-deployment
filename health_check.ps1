$response = Invoke-WebRequest http://localhost:8083/health

if ($response.StatusCode -eq 200) {
    exit 0
}

exit 1