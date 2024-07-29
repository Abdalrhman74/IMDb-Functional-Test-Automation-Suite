*** Settings ***
Library           SeleniumLibrary
Library           Collections

*** Variables ***
${movie_name}     The Shawshank Redemption

*** Test Cases ***
TestCase1
    Open Browser    https://www.imdb.com\    chrome
    Input Text    id=suggestion-search    ${movie_name}
    Click Button    id=suggestion-search-button
    sleep    5
    ${film_names} =    Get WebElements    class=ipc-metadata-list-summary-item__t
    ${original_films}    Create List
    FOR    ${film_name}    IN    @{film_names}
        ${film_attr}=    get text    ${film_name}
        Append To List    ${original_films}    ${film_attr}
    END
    Should Contain    ${original_films}    ${movie_name}
    ${first_film}=    Get Text    xpath=//*[@id="__next"]/main/div[2]/div[3]/section/div/div[1]/section[2]/div[2]/ul/li[1]/div[2]/div/a
    Should Be Equal As Strings    ${first_film}    ${movie_name}
    sleep    5
    Close Browser

TestCase2
    Open Browser    https://www.imdb.com\    chrome
    Click Element    id=imdbHeader-navDrawerOpen
    Maximize Browser Window
    sleep    5
    Click Link    xpath=//a[contains(@href, '/chart/top/?ref_=nv_mv_250')]
    sleep    5
    ${film_names} =    Get WebElements    class=titleColumn
    ${original_films}    Create List
    FOR    ${film_name}    IN    @{film_names}
        ${film_attr}=    get text    ${film_name}
        Append To List    ${original_films}    ${film_attr}
    END
    Length Should Be    ${original_films}    250
    ${first_film}=    Get Text    xpath=//*[@id="main"]/div/span/div/div/div[3]/table/tbody/tr[1]/td[2]/a
    Should Be Equal As Strings    ${first_film}    ${movie_name}
    sleep    5
    Close Browser

TestCase3
    Open Browser    https://www.imdb.com\    chrome
    Click Element    class=ipc-btn__text
    sleep    5
    Click Link    link=Advanced Search
    wait until page contains element    class:imdb-search-gateway__options
    Click Link    link=Advanced Title Search
    Select Check Box    id=title_type-1
    Select Check Box    id=genres-1
    Input Text    name=release_date-min    2010
    Input Text    name=release_date-max    2020
    Click Button    class=primary
    sleep    5
    Click Element    xpath=//*[@id="main"]/div/div[2]/a[3]
    sleep    5
    ${film_names_year} =    Get WebElements    class:lister-item-year
    ${original_films_year}    Create List
    FOR    ${film_name_year}    IN    @{film_names_year}
        ${film_attr_year}=    Get Text    ${film_name_year}
        ${film_attr_year}=    convert to integer    ${film_attr_year.replace('(', '').replace(')', '').replace('I','')}
        Append To List    ${original_films_year}    ${film_attr_year}
    END
    sleep    5
    FOR    ${year}    IN    @{original_films_year}
        Should Be True    ${year} >= 2010 and ${year} <= 2020
    END
    ${film_names} =    Get WebElements    name=ir
    ${original_films}    Create List
    FOR    ${film_name}    IN    @{film_names}
        ${film_attr}=    Get Text    ${film_name}
        Append To List    ${original_films}    ${film_attr}
    END
    ${copied_films} =    Copy List    ${original_films}
    Sort List    ${copied_films}
    reverse list    ${copied_films}
    Lists Should Be Equal    ${copied_films}    ${original_films}
    sleep    5
    Close Browser
