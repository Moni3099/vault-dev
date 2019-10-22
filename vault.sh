sudo yum install wget unzip -y
cd /opt/
sudo wget https://releases.hashicorp.com/vault/1.2.3/vault_1.2.3_linux_amd64.zip
sudo unzip vault_1.2.3_linux_amd64.zip
sudo cp vault /usr/bin/
sudo mkdir /etc/vault
sudo mkdir /vault-data
sudo mkdir -p /logs/vault/
sudo gsutil mb gs://vaultbuckii
sudo echo 'export IP=`curl -H "Metadata-Flavor: Google" http://metadata/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip`' >> ~/.bash_profile
source ~/.bash_profile
sudo vi configfile 
cat > /etc/vault/config.json  << EOF
{
"listener": [{
"tcp": {
"address" : "0.0.0.0:8200",
"tls_disable" : 1
}
}],
"api_addr": "http://'$IP':8200",
"storage": {
"gcs": {
"bucket" : "vaultbuckii",
"ha_enabled" : "true"
    }
 },
"max_lease_ttl": "10h",
"default_lease_ttl": "10h",
"ui":true
}
EOF

sudo vi vaultservice 

cat > /etc/systemd/system/vault.service  << EOF
[Unit]
Description=vault service
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault/config.json
 
[Service]
EnvironmentFile=-/etc/sysconfig/vault
Environment=GOMAXPROCS=2
Restart=on-failure
ExecStart=/usr/bin/vault server -config=/etc/vault/config.json
StandardOutput=/logs/vault/output.log
StandardError=/logs/vault/error.log
LimitMEMLOCK=infinity
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM
 
[Install]
WantedBy=multi-user.target

sudo systemctl start vault.service
sudo systemctl status vault.service
sudo systemctl enable vault.service
sudo su
cd ~
export VAULT_ADDR=http://'$IP':8200
echo "export VAULT_ADDR=http://'$IP':8200" >> ~/.bashrc
vault status
vault operator init > /etc/vault/init.file
cat /etc/vault/init.file
