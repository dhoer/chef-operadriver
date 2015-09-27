def operadriver_powershell_version
  out = shell_out!('powershell.exe $host.version.major')
  out.to_i
rescue # powershell not installed
  -1
end
