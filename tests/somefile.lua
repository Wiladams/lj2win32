local function SAY (phrase)
    print(phrase)
end

local function GET_INPUT()
end

local CALL_RESULT = {};
local function CALL(obj, func, ...)
    print("CALL: ", obj, func, ...)
    return CALL_RESULT
end

-- LANGUAGE_UNDERSTANDING
local configs = {
      name = "cab",
      type = "luis",
      params = {
        luis_app_id = "2e49a72f-95fb-4ee0-bb22-fe5c95b09bb3",
        subscription_key = "db20c5b6d87a4bb28ff5e61b96f28874" 
      },

    is_use_common_lu = false, 
} 

-- DATA
-- =================================================================
-- Define a simple list of strings in YAML
-- =================================================================
local LocationList = {
 "seattle",
 "bellevue",
 "renton",
}



-- Put your LU config in the LANGUAGE_UNDERSTANDING section
-- If you want common domain LU to also be run, set it to true
-- LU_CONTEXT will contain the top intent, entities/slots
 
::getbookingdetails::
::start::
SAY "I can handle bookings for Contoso Cafe. How can I help you?" 
 
::ask::
GET_INPUT()
--SAY LU_CONTEXT.to_json()
--SAY "Intent  is: ${LU_CONTEXT.responses.items[0].intent}"
 
if LU_CONTEXT.responses.items[0].intent.name ~= "RestaurantReservation.Reserve" then
    SAY "I'm sorry, I didn't get that. "
    goto ask
end

-- Gives you the slot text value, None if that slot doesn't exist
address = LU_CONTEXT.get_slot_text("RestaurantReservation.Address")
SAY "DEBUG: Address slot is: ${address}"
 
-- Validate
if  not LocationList.contains(address) then
    SAY "We have outlets in Seattle, Bellevue and Renton. Where would you like to go?"
    -- Create a set of choices, and present those to the user
    locations = {
        ["$msp.business"] = {
            {name = LocationList[0]},
            {name = LocationList[1]},
            {name = LocationList[2]}
        }
    }

    SAY "Pick one:"
    SAY "1. ${locations[0].name}"
    SAY "2. ${locations[1].name}"
    SAY "3. ${locations[2].name}"
    GET_INPUT()
    -- Call the Selection Service
    CALL ("system.selection", "select_simple", {candidates = locations, user_input = create("$mst.utterance", {text = USER_INPUT})})
 
    -- Handle the response
    selection_result = CALL_RESULT.result
    n = #selection_result.selected_entities
    if n > 0 then
        if selection_result.success then
            local i = 0
            SAY "Based on that input, the selection service matched on the following options"
            while i < n do
                SAY "${selection_result.selected_entities[i].name}"
                local address = selection_result.selected_entities[i].name
                i = i + 1
            end
        else
            SAY "Selection service failed."
        end
    else
        SAY "Based on that input, None of the options were selected."
        goto ask
    end

::ask_datetime::
SAY "OK. You want to make a booking at ${address.title()}. When do you want to go?"
GET_INPUT()
CALL ("system.timex_service", "resolve", {request=USER_INPUT})

if pcall(function() 
    local datetimex = CALL_RESULT.time
    --SAY datetimex.to_json()
    local reference_time = datetime.datetime.utcnow() + datetime.timedelta({minutes = -420})
    local iso = "{0:04}-{1:02}-{2:02}T{3:02}:{4:02}:{5:02}Z":format(datetimex.get("year", reference_time.year), datetimex.get("month", reference_time.month), datetimex.get("day", reference_time.day), datetimex.get("hour", 0), datetimex.get("minute", 0), datetimex.get("second", 0))
    --SAY "The ISO approximation is ${iso}"
    end) 
then
    -- no errorcatch err do
else
    SAY "No time expressions found."
    goto ask_datetime
end

::ask_time::
-- Check if they specified a time - timex type will be "time" if they did
if datetimex.type != "time"
    SAY "What time?"
    GET_INPUT
    CALL "system.timex_service", "resolve", request=USER_INPUT
    try
        SET timex = CALL_RESULT.time
        SAY timex.to_json()
        --SET reference_time = datetime.datetime.utcnow() + datetime.timedelta(minutes = -420)
        SET iso = "{0:04}-{1:02}-{2:02}T{3:02}:{4:02}:{5:02}Z".format(datetimex.get("year", reference_time.year), datetimex.get("month", reference_time.month), datetimex.get( "day", reference_time.day), timex.get( "hour", 0), timex.get("minute", 0), timex.get("second", 0))
        --SAY "The ISO approximation is ${iso}"
    catch err do
        SAY "I'm sorry, I didn't get that. At what time?"
        goto ask_time
    end

-- Populate the output object
CREATE "$mso.event" STORE event
SET event.name = "Contoso Cafe ${address}"
-- TODO get this from channel data??
SET event.attendee = create( "$mso.person", given_name="Andy", family_name="Wigley", email="andy.wigley@microsoft.com")
SET event.description = "Booking at Contoso Cafe ${address}"
SET event.start_date = iso
-- Add one hour for end time
SET format = "%Y-%m-%dT%H:%M:%SZ"
SET endTime = datetime.datetime.strptime(iso, format) + datetime.timedelta(hours=1)
SET event.end_date = datetime.datetime.strftime(endTime, format)
 
RETURN booked_event = event
 
--END
 
