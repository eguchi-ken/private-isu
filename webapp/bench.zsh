DIR=`git rev-parse --show-toplevel`
rm $DIR/webapp/log/*
# touch $DIR/webapp/log/{access,error,mysql-slow}.log

# 再起動する
docker compose build app
docker compose down
docker compose up -d

sleep 10

echo "START BENCHMARK"

docker run --rm --network host -i private-isu-benchmarker /opt/go/bin/benchmarker -t http://host.docker.internal -u /opt/go/userdata

./pt-query-digest log/mysql-slow.log > ./log/query-digest.sql
alp json --reverse --matching-groups "/image/.*(jpg|png),/posts/[0-9]+,/@[a-z]+" --sort sum --file ./log/access.log > ./log/access-digest.log
