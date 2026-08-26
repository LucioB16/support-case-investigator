param([switch]$Login)
$env:AZURE_CONFIG_DIR = "$HOME\.azure-client-slug"
if ($Login) {
    az login --allow-no-subscriptions
}
