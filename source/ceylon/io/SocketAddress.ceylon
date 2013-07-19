
"Represents a internet socket address."
by("Stéphane Épardaud")
shared class SocketAddress(address, port) {
    
    "The host name or IP part of that internet socket address."
    shared String address;

    "The tcp port part of that internet socket address."
    shared Integer port;
}