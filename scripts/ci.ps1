#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Write-Host "== t1 CI =="
Write-Host "PWD: $PWD"

function Has-Command([string]$name) {
  return [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

function Try-Run([string]$name, [string[]]$args) {
  if (-not (Has-Command $name)) {
    Write-Host "skip: '$name' not found"
    return
  }
  Write-Host "> $name $($args -join ' ')"
  & $name @args
}

$ranSomething = $false

# Node
if (Test-Path "package.json") {
  $ranSomething = $true
  Try-Run "npm" @("ci")
  Try-Run "npm" @("test")
}

# Python
if ((Test-Path "pyproject.toml") -or (Test-Path "requirements.txt")) {
  $ranSomething = $true
  if (Has-Command "python") {
    Try-Run "python" @("-m","pip","--version")
  } else {
    Write-Host "skip: python not found"
  }
}

# PHP
if (Test-Path "composer.json") {
  $ranSomething = $true
  Try-Run "composer" @("--version")
}

if (-not $ranSomething) {
  Write-Host "No stack configured yet (no package.json/pyproject.toml/requirements.txt/composer.json)."
  Write-Host "Edit scripts/ci.ps1 and add your project-specific steps."
}

Write-Host "CI done."
