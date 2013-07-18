import ceylon.test { assertEquals }
import ceylon.time { Instant, fixedTime, Clock, date, Period, time }
import ceylon.time.base { february, march, january, milliseconds }
import ceylon.time.timezone { utcZone }

//Wed Feb 13 14:00:42.0057 BOT 2013
Clock clock_feb_13_2013_18_00_42_0057 = fixedTime(1360778442057);
Instant feb_13_2013_18_00_42_0057 = Instant( clock_feb_13_2013_18_00_42_0057.milliseconds() );

shared void testDate() => assertEquals( date(2013, february, 13), feb_13_2013_18_00_42_0057.date(utcZone) );
shared void testTime() => assertEquals( time(18, 0, 42, 57), feb_13_2013_18_00_42_0057.time(utcZone));

shared void testPlusPeriod_UTC() {
    value period = Period { years = 2; months = 1;};
	value actual = feb_13_2013_18_00_42_0057.plus(period);
	assertEquals(date(2015,march, 13), actual.date(utcZone) );
    assertEquals(time(18, 0, 42, 57), actual.time(utcZone) );
}

shared void testMinusPeriod_UTC() {
	value period = Period { years = 2; months = 1; days = 3;};
	value actual = feb_13_2013_18_00_42_0057.minus(period);
	assertEquals(date(2011,january, 10), actual.date(utcZone));
    assertEquals(time(18, 0, 42, 57), actual.time(utcZone));
}

shared void testDurationTo() {
    value twoDaysduration = ( 2 * milliseconds.perDay );
    value twoDaysAfter = Instant(feb_13_2013_18_00_42_0057.millisecondsOfEra + twoDaysduration );
    value duration = feb_13_2013_18_00_42_0057.durationTo( twoDaysAfter );
    
   assertEquals( twoDaysduration, duration.milliseconds );
}

shared void testDurationFrom() {
    value twoDaysduration = ( 2 * milliseconds.perDay );
    value twoDaysBefore = Instant(feb_13_2013_18_00_42_0057.millisecondsOfEra - twoDaysduration );
    value duration =  feb_13_2013_18_00_42_0057.durationFrom(twoDaysBefore);
    
   assertEquals( twoDaysduration, duration.milliseconds );
}