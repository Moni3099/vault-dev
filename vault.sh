sudo yum install wget unzip -y
wget https://releases.hashicorp.com/vault/1.2.2/vault_1.2.2_linux_amd64.zip
unzip vault_1.2.2_linux_amd64.zip
export PATH=$PATH:/root
vault -autocomplete-install
