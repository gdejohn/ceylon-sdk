import ceylon.io { SocketAddress }
import ceylon.net.http { Method }

"Defines an object to provide client request information 
 to a web endpoint."
by("Matej Lazar")
shared interface Request {
    
    shared formal String? parameter(String name);
    
    shared formal String[] parameters(String name);
    
    "Returns a single header with given name."
    shared formal String? header(String name);
    
    "Returns all haaders with given name."
    shared formal String[] headers(String name);
    
    "Get the HTTP request method. {OPTIONS, GET, HEAD, POST, PUT, DELETE, TRACE, CONNECT}"
    shared formal Method method;
    
    "Get the request URI scheme. {http, https}"
    shared formal String scheme;
    
    "Gets the request URI, including hostname, protocol 
     etc if specified by the client."
    shared formal String uri;
    
    "Get the request URI path.  This is the whole original 
     request path."
    shared formal String path;
    

    "Return path relative to endpoint mapping path.
     Relative path is a substring of path without [[startsWith]] mappings.
     
     Note that endpoints mapped with [[And]] and [[endsWith]] will return complete path instead of relative.
     See [[Matcher.relativePath]] for details."
    shared formal String relativePath;
    
    shared formal String queryString;
    
    "Get the source address of the HTTP request."
    shared formal SocketAddress sourceAddress;
    
    "Get the destination address of the HTTP request."
    shared formal SocketAddress destinationAddress;
    
    "Returns request content type, read from header."
    shared formal String? contentType;
    
    "Returns users http session. If session doesn't exists, 
     a new is created."
    shared formal Session session;
    
}
