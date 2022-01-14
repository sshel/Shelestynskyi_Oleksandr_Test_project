# to run test on Robot Framework use the command in terminal
#    robot -v log:value -v pass:value testingAPI.robot

*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Resource    keywords/keywordsAPI.robot


*** Test Cases ***
Create and delete boocking
    ${TOKEN}  User authorization
    ${BOOKING_ID}    Create Booking
    Get booking info    ${BOOKING_ID}
    Delete booking  ${BOOKING_ID}    ${TOKEN}
    Check that the booking has been deleted    ${BOOKING_ID}