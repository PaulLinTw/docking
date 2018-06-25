idpass="admin:admin"
host=localhost
ctpye="Content-Type: application/json"
orgname=$1
if [[ $orgname == "" ]];
then
	orgname="demo"
	echo "Organization name will be $orgname"
fi

cd /importer

token=$(curl -X POST -H "$ctpye" -d '{"name":"'$orgname'"}' http://$idpass@$host:3000/api/orgs)
if [[ $token == "{\"message\":\"Organization name taken\"}" ]];
then
	echo $token
	exit 0
fi

key1=$(echo $token | sed -e "s|{\"message\":\"Organization created\",\"orgId\":||g")
orgid=$(echo $key1 | sed -e "s|}||g")
echo $orgid

curl -X POST http://$idpass@$host:3000/api/user/using/$orgid

token=$(curl -X POST -H "$ctpye" -d '{"name":"'$orgname'", "role": "Admin"}' http://$idpass@$host:3000/api/auth/keys)
key1=$(echo $token | sed -e "s|{\"name\":\"$orgname\",\"key\":\"||g")
apikey=$(echo $key1 | sed -e "s|\"}||g")
echo "apikey=$apikey"

sed -e "s|APIKEY|$apikey|g" origional.sh> /tmp/temp1.sh
sed -e "s|SERVER|$host|g" /tmp/temp1.sh> /tmp/temp2.sh
sed -e "s|ORGNAME|$orgname|g" /tmp/temp2.sh> /tmp/config.sh

./importer.sh data/demo/datasources/*.json
./importer.sh data/demo/alert-notifications/*.json
./importer.sh data/demo/dashboards/*.json
