"Common behavior of the [[DateTime]] types"
shared interface DateTimeBehavior<Element, out DateType, out TimeType> of Element
       satisfies DateBehavior<Element>
               & TimeBehavior<Element>
       given Element satisfies ReadableDateTime 
       given DateType satisfies ReadableDate
       given TimeType satisfies ReadableTime {

    "Returns Time portion of this [[DateTime]] value."
    shared formal TimeType time;

    "Returns Date portion of this [[DateTime]] value."
    shared formal DateType date;

}
