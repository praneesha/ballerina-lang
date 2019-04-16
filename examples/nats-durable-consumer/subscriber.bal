import ballerina/nats;
import ballerina/io;

// Initialize NATS listener.
listener nats:Listener subscription = new({ host: "localhost", port: 4222,
                                            clientId: "s0" });

// Bind consumer to listen to messages published to 'demo' subject.
@nats:ConsumerConfig { subject: "demo", durableName: "bal_consumer_1" }
service demo on subscription {

    resource function onMessage(nats:Message msg) {
        // Print the incoming message in the std out.
        io:println("Received message : " + msg.getData());
    }

}
