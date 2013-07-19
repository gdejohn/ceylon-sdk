import ceylon.file.internal { sameFileInternal=sameFile }

"Represents a file in a hierarchical file system."
shared interface File 
        satisfies ExistingResource {
    
    "The directory containing this file."
    shared formal Directory directory;
    
    "Move this file to the given location."
    shared formal File move(Nil target);
    
    "Move this file to the given location,
     overwriting the target if it already exists."
    shared formal File moveOverwriting(File|Nil target);
    
    "Copy this file to the given location."
    shared formal File copy(Nil target);
    
    "Copy this file to the given location,
     overwriting the target if it already exists."
    shared formal File copyOverwriting(File|Nil target);
    
    "Create a hard link to this file."
    shared formal File createLink(Nil target);
    
    "Create a symbolic link to this file."
    shared formal Link createSymbolicLink(Nil target);
    
    "Determine if this file may be written to."
    shared formal Boolean writable;
    
    "Determine if this file may be read from."
    shared formal Boolean readable;
    
    "Determine if this file may be executed."
    shared formal Boolean executable;
    
    "The name of this file."
    shared formal String name;
    
    "The size of this file, in bytes."
    shared formal Integer size;
    
    "Determine if this file is considered hidden."
    shared formal Boolean hidden;
    
    "Determine the content type of this file, if
     possible."
    shared formal String? contentType;
    
    "The timestamp of the last modification of this 
     file."
    shared formal variable Integer lastModifiedMilliseconds;
    
    "The store to which this file belongs."
    shared formal Store store;
    
    "A `Reader` for reading lines of text from this
     file."
    shared formal Reader reader(
            "The character encoding to use, where
             `null` indicates that the platform 
             default character encoding should be
             used."
            String? encoding=null);
    
    "A `Writer` for writing text to this file, after
     truncating the file to length 0."
    shared formal Writer writer(
            "The character encoding to use, where
             `null` indicates that the platform 
             default character encoding should be
             used."
            String? encoding=null);
    
    "A `Writer` for appending text to this file"
    shared formal Writer appender(
            "The character encoding to use, where
             `null` indicates that the platform 
             default character encoding should be
             used."
            String? encoding=null);
}

shared Boolean sameFile(File x, File y) => sameFileInternal(x, y);