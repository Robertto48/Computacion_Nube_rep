
#!/bin/bash
#Consul configuration for server (frontend Haproxy)
#consul agent with user interface, devolper mode, server(leader)
echo "configurando dependencias haproxy"
#consul agent -ui -dev -server -bootstrap-expect=1 -node=agent-haproxy -bind=192.168.100.6 -http-addr=0.0.0.0:8500 -client=0.0.0.0 -data-dir=/tmp/consul -config-dir=/etc/consul.d -enable-script-checks=true -retry-join "192.168.100.7" -retry-join "192.168.100.8" &
echo "configurando service discovery con consul"

sudo cp --force /vagrant/provision/haproxy/config.json /etc/consul.d/
sudo cp --force /vagrant/provision/haproxy/consul.service /etc/systemd/system/
sudo chmod 777 /etc/systemd/system/consul.service

echo "web-service provision" 
sudo cp --force /vagrant/provision/haproxy/web-service.json /etc/consul.d/
consul reload

sudo systemctl daemon-reload
sudo systemctl enable consul.service
sudo systemctl start consul.service
sudo systemctl restart consul.service

echo "configurando haproxy" 
sudo apt update -y && apt upgrade -y
apt-get install net-tools -y
sudo apt install haproxy -y

echo "configurando error modificado" 
sudo cp --force /vagrant/provision/haproxy/503.http /etc/haproxy/errors/

sudo systemctl enable haproxy
sudo cp --force /vagrant/provision/haproxy/haproxy.cfg /etc/haproxy/
sudo systemctl restart haproxy
sudo systemctl start haproxy

echo "finalizacion provision" 

echo "Artillery"
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install nodejs -y
sudo apt install npm -y
npm install -g artillery@latest