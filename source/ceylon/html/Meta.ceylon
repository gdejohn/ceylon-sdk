import ceylon.io.charset {
    utf8,
    Charset
}

shared class Meta(name, content = "", String? id = null)
        extends Element(id) {

    shared String name;

    shared String content;

    tag => Tag(tagName, inlineTag);

}

shared class CharsetMeta(charset = utf8)
        extends Meta("Content-Type", "text/html; charset=``charset``;") {

    shared Charset charset;

}
