#!/bin/bash
#####sed -i 's/\r$//' replica-set.sh
echo "........................................"
  
until mongo --host mongo1:27018 --eval 'quit(db.runCommand({ping : 1}).ok ? 0 : 2)' &>/dev/null; do
   printf '.'
   sleep 1
done
echo "mongo1:27018 started..."   

until mongo --host mongo2:27019 --eval 'quit(db.runCommand({ping : 1}).ok ? 0 : 2)' &>/dev/null; do
   printf '.'
   sleep 1
done
echo "mongo2:27019 started..." 

until mongo --host mongo3:27020 --eval 'quit(db.runCommand({ping : 1}).ok ? 0 : 2)' &>/dev/null; do
   printf '.'
   sleep 1
done
echo "mongo3:27020 started..."   
   
mongo --host mongo1:27018 <<EOF
var config = {
    "_id": "cdc-rs",
    "members": [
        {
            "_id": 1,
            "host": "mongo1:27018",
        },
        {
            "_id": 2,
            "host": "mongo2:27019",
        },
        {
            "_id": 3,
            "host": "mongo3:27020",
        }
    ]
};
rs.initiate(config, { force: true });
rs.reconfig(config, { force: true });
EOF

if [ ! -f /data/db/.mongodb_password_set ]; then

  DEFAULT_DB=${MONGODB_DEFAULT_DATABASE:-"admin"} 
  USER=${MONGODB_USER:-"admin"} 
  PASS=${MONGODB_PASS:-"admin"}
  
  echo "...USER: '$USER'"
  mongo --host cdc-rs/mongo1:27018,mongo2:27019,mongo3:27020 admin --eval "db.createUser({user: '$USER', pwd: '$PASS', roles: [ { role: 'root', db: 'admin' } ]});"
  if [ "$DEFAULT_DB" != "admin" ]; then
     mongo --host cdc-rs/mongo1:27018,mongo2:27019,mongo3:27020 admin -u $USER -p $PASS <<EOF
use $DEFAULT_DB
db.createUser({user: '$USER', pwd: '$PASS', roles: [ { role: 'dbOwner', db: '$DEFAULT_DB' } ]})
EOF
  fi
fi

echo "DONE!!"
touch /data/db/.mongodb_password_set