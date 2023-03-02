# mongo-source-connector-poc

This projects sets up the infrastructure for mongodb source connector for Kafka Connect

Step1. go to folder kafka-connect and create an image my-kafka-connect:1.0.0 using existing Dockerfile
Step2. from the main folder run docker compose up -d to spin up the infrastructure needed
Step3. crate a connector using any example from file kafka-connect/connectors.txt
Step4. insert data in Mongodb
Step5. visualize data in kafka topics using Control Center localhost:9021 as per docker-compose.yml file


To remove containers:

docker compose down
docker volume prune
