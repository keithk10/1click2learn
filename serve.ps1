# Minimal static file server using built-in Windows PowerShell, so no install is needed.
# Started by Play.bat; close the window to stop it.
$root = $PSScriptRoot
$types = @{
  ".html" = "text/html; charset=utf-8"
  ".js"   = "text/javascript"
  ".wasm" = "application/wasm"
  ".swf"  = "application/x-shockwave-flash"
}

# Use the first free port from 8080 upwards
$listener = $null
foreach ($port in 8080..8099) {
  $try = New-Object System.Net.HttpListener
  $try.Prefixes.Add("http://localhost:$port/")
  try { $try.Start(); $listener = $try; break } catch { $try.Close() }
}
if (-not $listener) { Write-Host "No free port between 8080 and 8099."; Read-Host "Press Enter to close"; exit 1 }

$url = "http://localhost:$port/"
Write-Host "1Click2Learn is running at $url"
Write-Host "Keep this window open while you play. Close it to stop."
Start-Process $url

while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $res = $ctx.Response
  try {
    $rel = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath).TrimStart("/")
    if ($rel -eq "") { $rel = "index.html" }
    $file = [IO.Path]::GetFullPath((Join-Path $root $rel))
    if ($file.StartsWith($root) -and (Test-Path -LiteralPath $file -PathType Leaf)) {
      $ext = [IO.Path]::GetExtension($file).ToLower()
      $res.ContentType = if ($types.ContainsKey($ext)) { $types[$ext] } else { "application/octet-stream" }
      $stream = [IO.File]::OpenRead($file)
      $res.ContentLength64 = $stream.Length
      try { $stream.CopyTo($res.OutputStream) } finally { $stream.Close() }
    } else {
      $res.StatusCode = 404
    }
  } catch {
    # The browser closed the connection early; ignore it
  } finally {
    try { $res.Close() } catch {}
  }
}
