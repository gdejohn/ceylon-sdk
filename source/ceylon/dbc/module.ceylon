"This module offers some components for JDBC-based
 database connectivity. The main component is simply
 called Sql and is meant to be used with a `DataSource`
 that has been already been configured. "
by("Enrique Zamudio")
license("Apache Software License 2.0")
module ceylon.dbc '0.6' {
    import ceylon.language '0.6';
    import ceylon.collection '0.6';
    shared import ceylon.math '0.6';
    import java.base '7';
    shared import java.jdbc '7';
}
