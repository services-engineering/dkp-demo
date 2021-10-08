kubectl delete deploy/kafka-client-api

#docker build . -t jlnhnng/kafka-client-api
#docker push jlnhnng/kafka-client-api

sleep 2

kubectl apply -f kafka-client-api.yaml

sleep 5
kubectl logs -f -l app=kafka-client-api 