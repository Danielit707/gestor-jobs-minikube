[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$raiz = Split-Path -Parent $PSScriptRoot

# Build directly into Minikube's container runtime. This works with both Docker
# and containerd and avoids docker-env, which is unsupported on some Windows
# setups and experimental with containerd.
Write-Host 'Construyendo imagenes dentro del runtime de Minikube...'

@('python', 'java', 'c') | ForEach-Object {
    $lenguaje = $_
    $tag = "kubernates-202630-$lenguaje`:1.0"
    Write-Host "Construyendo $tag..."
    & minikube -p minikube image build -t $tag (Join-Path $raiz "imagenes/$lenguaje")
    if ($LASTEXITCODE -ne 0) { throw "No se pudo construir $tag" }
}

Write-Host ''
Write-Host 'Imagenes disponibles dentro de Minikube:'
& minikube -p minikube image ls --format table
if ($LASTEXITCODE -ne 0) { throw 'No se pudieron listar las imagenes de Minikube.' }
