#!/usr/bin/env pwsh
param(
  [string]$HostAlias = 'vps-test',
  [string]$RemoteDir = '/opt/t1/first-deploy',
  [string]$RemoteUser = 'nacty',
  [string]$LocalAppDir = (Join-Path $PSScriptRoot '..\\ops\\vps\\first-deploy')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Assert-Command([string]$name) {
  if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
    throw "Required command not found: $name"
  }
}

Assert-Command ssh
Assert-Command scp

$LocalAppDir = (Resolve-Path $LocalAppDir).Path

Write-Host "Deploying '$LocalAppDir' -> '${HostAlias}:$RemoteDir'"

# Prepare remote directory
& ssh $HostAlias "sudo -n mkdir -p '$RemoteDir' && sudo -n chown -R '${RemoteUser}:${RemoteUser}' '$RemoteDir'" | Out-Host

# Copy compose app (copy directory contents)
& scp -r "$LocalAppDir/." "${HostAlias}:$RemoteDir/" | Out-Host

# Ensure nginx can read mounted files (Windows->scp can create too-restrictive perms)
& ssh $HostAlias "sudo -n chmod -R a+rX '$RemoteDir'" | Out-Host

# Start/refresh
& ssh $HostAlias "cd '$RemoteDir' && docker compose pull && docker compose up -d" | Out-Host
& ssh $HostAlias "cd '$RemoteDir' && docker compose ps" | Out-Host

# Local health check on server
& ssh $HostAlias "(curl -fsS http://127.0.0.1/ || wget -qO- http://127.0.0.1/) | head -n 8" | Out-Host

Write-Host "Done. If port 80 is reachable externally: http://89.40.204.19/"
