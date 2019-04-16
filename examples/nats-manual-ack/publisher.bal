import ballerina/nats;
import ballerina/io;
import ballerina/log;

// Produce a message to a subject in NATS sever.
public function main() {
    // Initializes a producer.
    nats:Producer producer = new({ host: "localhost", port: 4222, clientId: "p0" });
    // Produce a message to specified subject.
    var result = producer->send("demo", "Hello Ballerina!");
    if (result is error) {
        io:println("Error occurred while producing the message.");
    } else {
        io:println("GUID "+result+" received for the produced message.");
    }
    // Close the publisher connection.
    var result = producer.close();
    if (result is error) {
        log:printError("Error occurred while closing the connection", err = result);
    }
}
