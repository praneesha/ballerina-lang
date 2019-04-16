import ballerina/nats;
import ballerina/io;
import ballerina/log;

// Initialize NATS listener.
listener nats:Listener subscription = new({ host: "localhost", port: 4222,
                                            clientId: "s0", ackTimeout:60 });

// Bind consumer to listen to messages published to 'demo' subject.
@nats:ConsumerConfig { subject: "demo", manualAck: true }
service demo on subscription {

    resource function onMessage(nats:Message msg) {
        // Print the incoming message in the std out.
        io:println("Received message : " + msg.getData());
        var result = msg.ack();
        if (result is error) {
            log:printError("Error occurred while acknowledging to message", err = result);
        }
    }
}
