import ceylon.io.buffer { newByteBuffer, ByteBuffer, CharacterBuffer }

"Represents a UTF-8 character set as defined by
 (the specification)[http://tools.ietf.org/html/rfc3629]."
by("Stéphane Épardaud")
shared object utf8 satisfies Charset {
    
    "Returns `UTF-8`."
    shared actual String name = "UTF-8";
    
    "Returns a list of common aliases such as `utf8` and `utf_8` even
     though these are not defined officially as aliases by
     [the internet registry](http://www.iana.org/assignments/character-sets)."
    shared actual String[] aliases = ["utf8", "utf_8"];
    
    "Returns 1."
    shared actual Integer minimumBytesPerCharacter = 1;

    "Returns 4."
    shared actual Integer maximumBytesPerCharacter = 4;

    "Returns 2."
    shared actual Integer averageBytesPerCharacter = 2;

    "Returns a new UTF-8 decoder."
    shared actual Decoder newDecoder(){
        return UTF8Decoder(this);
    }

    "Returns a new UTF-8 encoder."
    shared actual Encoder newEncoder() {
        return UTF8Encoder(this);
    }
}

class UTF8Encoder(charset) satisfies Encoder {
    
    shared actual Charset charset;
    ByteBuffer bytes = newByteBuffer(3);
    // set its limit to 0 for reading
    bytes.flip();

    shared actual Boolean done {
        return !bytes.hasAvailable;
    }

    shared actual void encode(CharacterBuffer input, ByteBuffer output) {
        // give up if there's no input or no room for output
        while((input.hasAvailable || bytes.hasAvailable) && output.hasAvailable){
            // first flush our buffer
            if(bytes.hasAvailable){
                output.put(bytes.get());
            }else{
                // now read from input
                value codePoint = input.get().integer;
                // how many bytes?
                if(codePoint < #80){
                    // single byte
                    output.put(codePoint);
                }else if(codePoint < #800){
                    // two bytes
                    value b1 = codePoint.and($11111000000).rightLogicalShift(6).or($11000000);
                    value b2 = codePoint.and($111111).or($10000000);
                    output.put(b1);
                    // save it for later
                    bytes.clear();
                    bytes.put(b2);
                    bytes.flip();
                }else if(codePoint < #10000){
                    // three bytes
                    value b1 = codePoint.and($1111000000000000).rightLogicalShift(12).or($11100000);
                    value b2 = codePoint.and($111111000000).rightLogicalShift(6).or($10000000);
                    value b3 = codePoint.and($111111).or($10000000);
                    output.put(b1);
                    // save it for later
                    bytes.clear();
                    bytes.put(b2);
                    bytes.put(b3);
                    bytes.flip();
                }else if(codePoint < #10FFFF){
                    // four bytes
                    value b1 = codePoint.and($111000000000000000000).rightLogicalShift(18).or($11110000);
                    value b2 = codePoint.and($111111000000000000).rightLogicalShift(12).or($10000000);
                    value b3 = codePoint.and($111111000000).rightLogicalShift(6).or($10000000);
                    value b4 = codePoint.and($111111).or($10000000);
                    output.put(b1);
                    // save it for later
                    bytes.clear();
                    bytes.put(b2);
                    bytes.put(b3);
                    bytes.put(b4);
                    bytes.flip();
                }else{
                    // FIXME: type
                    throw Exception("Invalid unicode code point");
                }
            }
        }
    }
}

class UTF8Decoder(charset) extends AbstractDecoder()  {
    shared actual Charset charset;
    
    variable Integer needsMoreBytes = 0;
    ByteBuffer bytes = newByteBuffer(3);
    variable Boolean byteOrderMarkSeen = false;
    
    shared actual String done() {
        if(needsMoreBytes > 0){
            // type
            throw Exception("Invalid UTF-8 sequence: missing `` needsMoreBytes `` bytes");
        }
        return super.done();
    }
    
    shared actual void decode(ByteBuffer buffer) {
        for(Integer byte in buffer){
            if(byte < 0 || byte > 255){
                // FIXME: type
                throw Exception("Invalid UTF-8 byte value: `` byte ``");
            }
            // are we looking at the first byte?
            if(needsMoreBytes == 0){
                // 0b0000 0000 <= byte < 0b1000 0000
                if(byte < #80){
                    // one byte
                    builder.appendCharacter(byte.character);
                    continue;
                }
                // invalid range
                if(byte < $11000000){
                    // FIXME: type
                    throw Exception("Invalid UTF-8 byte value: `` byte ``");
                }
                // invalid range
                if(byte >= $11111000){
                    throw Exception("Invalid UTF-8 first byte value: `` byte ``");
                }
                // keep this byte in any case
                bytes.put(byte);
                if(byte < $11100000){
                    needsMoreBytes = 1;
                    continue;
                }
                if(byte < $11110000){
                    needsMoreBytes = 2;
                    continue;
                }
                // 0b1111 0000 <= byte < 0b1111 1000
                if(byte < $11111000){
                    needsMoreBytes = 3;
                    continue;
                }
            }
            // if we got this far, we must have a second byte at least
            if(byte < $10000000 || byte >= $11000000){
                // FIXME: type
                throw Exception("Invalid UTF-8 second byte value: `` byte ``");
            }
            if(--needsMoreBytes > 0){
                // not enough bytes
                bytes.put(byte);
                continue;
            }
            // we have enough bytes! they are all in the bytes buffer except the last one
            // they have all been checked already
            bytes.flip();
            Integer char;
            if(bytes.available == 1){
                Integer part1 = bytes.get().and($00011111);
                Integer part2 = byte.and($00111111);
                char = part1.leftLogicalShift(6)
                    .or(part2);
            }else if(bytes.available == 2){
                Integer part1 = bytes.get().and($00001111);
                Integer part2 = bytes.get().and($00111111);
                Integer part3 = byte.and($00111111);
                char = part1.leftLogicalShift(12)
                    .or(part2.leftLogicalShift(6))
                    .or(part3);
            }else{
                Integer part1 = bytes.get().and($00000111);
                Integer part2 = bytes.get().and($00111111);
                Integer part3 = bytes.get().and($00111111);
                Integer part4 = byte.and($00111111);
                char = part1.leftLogicalShift(18)
                    .or(part2.leftLogicalShift(12))
                    .or(part3.leftLogicalShift(6))
                    .or(part4);
            }
            // 0xFEFF is the Byte Order Mark in UTF8
            if(char == #FEFF && builder.size == 0 && !byteOrderMarkSeen){
                byteOrderMarkSeen = true;
            }else{
                builder.appendCharacter(char.character);
            }
            // needsMoreBytes is already 0
            // bytes needs to be reset
            bytes.clear();
        }
    }
}
