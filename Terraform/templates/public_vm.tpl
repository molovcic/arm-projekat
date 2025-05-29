#!/bin/bash

# Update system and install dependencies
sudo apt update -y
sudo apt install -y docker.io apache2
sudo apt install -y mysql-server

sudo curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
sudo apt install -y gitlab-runner

# gitlab-runner register  --url https://gitlab.com  --token glrt-UR9qzeV76Poa03ZQxEy2qW86MQpwOjE1dWt2eAp0OjMKdTpncm5sbRg.01.1j0id439g
# sudo usermod -aG docker gitlab-runner
# sudo systemctl restart gitlab-runner

sleep 60

sudo docker pull molovcic1/arm-projekat:latest
sudo docker run -d -p 8080:3000 --name arm-projekat molovcic1/arm-projekat:latest

sudo a2enmod proxy 
sudo a2enmod proxy_http
sudo a2enmod ssl

sudo mkdir -p /etc/ssl/tim11.arm.com

sudo tee /etc/ssl/tim11.arm.com/server.crt > /dev/null <<'EOF'
-----BEGIN CERTIFICATE-----
MIIDYDCCAkigAwIBAgIUFP8prmD22wjU+AuKqGPLQjawLHgwDQYJKoZIhvcNAQEL
BQAwQzELMAkGA1UEBhMCQkExCzAJBgNVBAgTAlNBMQswCQYDVQQHEwJTQTEaMBgG
A1UEAxMRd3d3LnRpbTExLmFybS5jb20wHhcNMjUwNTI3MTMxOTUwWhcNMzUwNTI4
MTMxOTUwWjBDMQswCQYDVQQGEwJCQTELMAkGA1UECBMCU0ExCzAJBgNVBAcTAlNB
MRowGAYDVQQDExF3d3cudGltMTEuYXJtLmNvbTCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAKhwkuWGS6/+6h7GFfg/6neOLXv+8PxjbiRPob2u4A+mhfO6
JqaALwOM2D7cQSeGL9qsz83qfVzKXqffQjsfOtrwwCcRLxQfDTpoRXAia+OeSrs3
8gcdXhheFfCs3i+Trl9LpxA8yLiluP7yKBDL7Swbn7JYElgjdmlea6TozOkKlJo1
+zetQEA/L/Ow8rbYKClE+tRg+SSpM+KE/2OZ8P0NUWx6WOJk41w+dB9f6OUbAl5L
TzvuLMImC3l1dnv06JvDWFP6Ndr3sUppiS+5m3nJ1o0kaVaTS9yX5/ocesAcp2rA
uEEtoe09BDvkYhjFy0CQI81HsmBTlqIB9DJVLsMCAwEAAaNMMEowCQYDVR0TBAIw
ADARBglghkgBhvhCAQEEBAMCBPAwCwYDVR0PBAQDAgWgMB0GA1UdJQQWMBQGCCsG
AQUFBwMCBggrBgEFBQcDATANBgkqhkiG9w0BAQsFAAOCAQEAZUEHYHQ5HWUkKI2K
NrPosVLuo4gRz/dj5xwH63FkqSWGH0/16ji7JI7x0FAu0MrM+2LGu/cB5RqWKpGt
13D3Qq9fqHuO5vcy+L/Lgw4eaI4mcPKQbUN+T++Llxxd17ONFdf4WOz/DTNwfm0S
uslzJA9qGKUL7GOYxHRosO9Iv8Rjly+s3I+0lNUKDqtKmII4WUlvUPsDZUTegwy+
sPgeWZCNjdQlXo1lPAZAapj6z30WnfEylNvl3+w7tf0UVY03ICblzjhHwZfI6HgL
s5cRdey2OAdmxhwRGEXSsSZ7OUgfnPdzbYoEDSo7sslp8Iy8hNHWf07Znfiw9XV0
1zYZEA==
-----END CERTIFICATE-----
EOF

sudo tee /etc/ssl/tim11.arm.com/server.key > /dev/null <<'EOF'
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAqHCS5YZLr/7qHsYV+D/qd44te/7w/GNuJE+hva7gD6aF87om
poAvA4zYPtxBJ4Yv2qzPzep9XMpep99COx862vDAJxEvFB8NOmhFcCJr455Kuzfy
Bx1eGF4V8KzeL5OuX0unEDzIuKW4/vIoEMvtLBufslgSWCN2aV5rpOjM6QqUmjX7
N61AQD8v87DyttgoKUT61GD5JKkz4oT/Y5nw/Q1RbHpY4mTjXD50H1/o5RsCXktP
O+4swiYLeXV2e/Tom8NYU/o12vexSmmJL7mbecnWjSRpVpNL3Jfn+hx6wBynasC4
QS2h7T0EO+RiGMXLQJAjzUeyYFOWogH0MlUuwwIDAQABAoIBAH1E27rfmcKWLsAc
SZKK1nF7x9AD1m2d9PgEUSGkwPZivhR5SO1jP5PAV8LIQ5yFa2mSRCm8TueHicYH
gFY/76GMkxt66Cxqu4fIrHus3dg2jRWXkeRArw4oSuDnb4aqqnAs715gFldcyKyy
o6F6SDUZhjc40MvD8/iBREUs7dgR1Sa2MSMTsUarcXP0nVWWGLQUgL93b/VNaRXj
YR2QhzZtIyoqOUbDhF9UUr1N1Ewtg324ipDZ0hEq73SBuKZmNlf1B1EdPMQPwz0N
qMQrfLHmfHQO2sHS2Dymm+Q9R9F+22w79QFgcAqru2dj5iV46HSMw5DIBj5VYSsT
yTMr22ECgYEA2YAT+6BDy2Sgo83tPNcg626htktNucxHIsXpe6GSQ03K74QD7VnJ
PjwmQRIKEzUfZFcbYoEkKyy7atv4YUlMLpiXRkwQYHpuiLSDHG1u7KyMR3Dguvjn
blitYEr7cDQVxxj7e/m2DtCEw47z40b/gOtXlIU5nbKf0Ni/51JCJCcCgYEAxkFX
AYnmBQMiYYslKpydV3EObrj5yXp5ZVI9/GOgPrJ+MB6N+X082t+iSJlm+FJK0xoY
dKdE8CaxBtmchyGlvUdJvVSjEFgAz5s19P7cUNG4Q0Yjy4YARTh0z7CCcM5sc7n1
onuq/5FNY0L+FJaosu5k87gvPSFcdcJBwTRr9gUCgYAHygFtMnkbEJh8JUTIt/+S
ztx1tc6rx7gIc8P/zHJ7fI628yhc2KlPVEIedHHt7Coaos/1QCC2dxyjIAuOGFzl
EkvglZrEib3poWVMoFKnoSpI6K7zozROjFhxKV5Fz2e0QJ3I+9FcSHVot3befc1q
pYL2a6r7jckRZqHAu/5oYwKBgGLE5p3Dn67bkuNZuRhzkgegMXqD+R2hQJ1zzaHR
2GGj9y3t6vlipVC9nVHh6uTHyrNFCu4C71tdS1CIVW0VHEciHuCOK/bWgQDs6IK3
/fbdpJkPdoHMrpHNwJQ/8ZxVmr5E5NUgG17betx64a5MKJuMHQs2tYIU/sVEFBI3
FZopAoGABQFZFmEK6NWmuPTma7TXHRk3BIj9BLGqX+Whz5g1zrKZh7sfpQh43IIH
2Yw2GySWz7Vtx+MK/aHVeRChDN7hhWdd8ao9yCKjWSTwKBPNvVjX7/bSohiFx2Ig
an9M6WCC9AIJPHJYH0g5tvVHZFDtk0+QqwxFXQxWv4izPCibqoo=
-----END RSA PRIVATE KEY-----
EOF

sudo tee /etc/apache2/sites-available/docker-site.conf > /dev/null <<'EOF'
<VirtualHost *:80>
    ServerName www.tim11.arm.com
    ServerAlias tim11.arm.com

    Redirect / https://www.tim11.arm.com/
</VirtualHost>

<VirtualHost *:443>
    ServerName www.tim11.arm.com
    ServerAlias tim11.arm.com

    SSLEngine on
    SSLCertificateFile /etc/ssl/tim11.arm.com/server.crt
    SSLCertificateKeyFile /etc/ssl/tim11.arm.com/server.key

    ProxyPass / http://localhost:8080/
    ProxyPassReverse / http://localhost:8080/
</VirtualHost>
EOF

sudo a2dissite 000-default.conf
sudo a2ensite docker-site.conf
sudo systemctl restart apache2
sudo systemctl enable apache2
