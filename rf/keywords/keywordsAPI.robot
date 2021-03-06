*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary


*** Variables ***
${BASE_URL}     https://restful-booker.herokuapp.com
${BOOKING_ENDPOINT}     /booking
${AUTH_ENDPOINT}    /auth

*** Keywords ***

User authorization
    ${HEADERS}      load json from file    dataJson/headers.json
    ${BODY}    Create Dictionary   username=${log}    password=${pass}
    create session    auth    ${BASE_URL}
    ${RESPONSE}    post on session    auth    ${AUTH_ENDPOINT}    json=${BODY}      headers=${HEADERS}

    status should be       200

    ${TOKEN_ARRAY}    get value from json    ${RESPONSE.json()}    token
    ${TOKEN}    set variable   ${TOKEN_ARRAY[0]}
    return from keyword    ${TOKEN}

Create Booking
    ${HEADERS}      load json from file    dataJson/headers.json
    ${BODY}      load json from file    dataJson/booking.json
    create session    cr_booking    ${BASE_URL}
    ${RESPONSE}    post on session    cr_booking     ${BOOKING_ENDPOINT}    json=${BODY}  headers=${HEADERS}

    status should be       200
    ${NAME}    get value from json    ${RESPONSE.json()}    $.booking.firstname
    should be equal as strings    ${NAME[0]}    Maks

    ${ID_ARRAY}    get value from json    ${RESPONSE.json()}    bookingid
    ${ID}   set variable    ${ID_ARRAY[0]}
    return from keyword      ${ID}

Get booking info
    [Arguments]    ${id}
    ${HEADERS}      load json from file    dataJson/headers.json
    create session  get_booking    ${BASE_URL}
    ${RESPONSE}     get on session    get_booking    ${BOOKING_ENDPOINT}/${ID}    headers=${HEADERS}

    status should be       200
    ${LAST_NAME}    get value from json    ${RESPONSE.json()}    $.lastname
    should be equal as strings    ${LAST_NAME[0]}    Brown

Delete booking
    [Arguments]    ${id}    ${token}
    ${headers_for_delete}  Create Dictionary  Content-Type=application/json    Cookie=token=${TOKEN}
    create session    delete_booking    ${BASE_URL}
    ${RESPONSE}    delete on session    delete_booking     ${BOOKING_ENDPOINT}/${ID}   headers=${headers_for_delete}

    status should be       201

Check that the booking has been deleted
    [Arguments]    ${id}
    ${HEADERS}      load json from file    dataJson/headers.json
    create session  chek_delete    ${BASE_URL}
    ${RESPONSE}     get on session    chek_delete     ${BOOKING_ENDPOINT}/${ID}    headers=${Headers}    expected_status=any

    status should be       404
    should be equal as strings    ${RESPONSE.content}    Not Found