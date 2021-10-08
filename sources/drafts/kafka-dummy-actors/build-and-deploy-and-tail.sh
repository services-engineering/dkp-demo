kubectl delete deploy/kafka-dummy-actor

#docker build . -t jlnhnng/kafka-dummy-actor
#docker push jlnhnng/kafka-dummy-actor

sleep 2

kubectl apply -f kafka-dummy-actor.yaml

sleep 5
kubectl logs -f -l app=kafka-dummy-actor 