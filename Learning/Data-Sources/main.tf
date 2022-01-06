// This url is owned and managed by Cloudflare.
data "http" "agent" {
  url = "http://ipv4.icanhazip.com"
}

output "ip" {   
  value = ["${chomp(data.http.agent.body)}/32"]
}