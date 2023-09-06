*** Settings ***
Documentation       Template robot browser.

Library    RPA.Browser.Selenium
Library    RPA.Tables
Library    RPA.FileSystem
Library    String
Library    DateTime
Library    RPA.Netsuite
Library    RPA.Robocorp.WorkItems

*** Variables ***
${TEXT_FILE}=     Data.csv
${HORARIO}=     ${EMPTY}
${CIA}=    ${EMPTY}
${TIME_VOO}=    ${EMPTY}
${DIRECAO}=    ${EMPTY}
${PARADAS}=    ${EMPTY}
${TIME_CONEXAO}=    ${EMPTY}
${EMISSAOCO2}=    ${EMPTY}
${ECONOMIAEMISSAOCO2}=    ${EMPTY}
${VALOR}=    ${EMPTY}
${COTACAO}=    ${EMPTY}
${LINHA}=    ${EMPTY}
${HEAD}=     ${EMPTY} 


*** Tasks ***
Open a Browser and Get COTACAO
    TRY
        ${L1}=    Create list     Dublin    Bristol    Atlanta    Munich    London

        ${maxDays}=     Set Variable    90

        ${datainicio} =    Get Current Date

        ${dataPesquisa} =    Get Current Date

        ${fimPesquisa} =    Add Time To Date    ${datainicio}    ${maxDays} days

        ${daysAdd}=    Set Variable      2

        ${HEAD}=    Catenate    SEPARATOR=       DataPesquisa; Destino; IDA; VOLTA; HORARIO; CIA; TIME_VOO; DIRECAO; PARADAS; TIME_CONEXAO; EMISSAOCO2; ECONOMIAEMISSAOCO2; VALOR; COTACAO     ${\n}

        Create File    ${TEXT_FILE}    ${HEAD}  overwrite=${True}

        WHILE    ${daysAdd} <= ${maxDays}

            ${datainicio}=    Add Time To Date    ${datainicio}    ${daysAdd} days
            
            ${daysAdd}=    Set Variable      ${${daysAdd}+7}

            ${datafim}=    Add Time To Date    ${datainicio}    ${daysAdd} days

            ${sdatainicio}=    Convert Date    ${datainicio}    result_format=%a, %b %d

            ${sdatafim}=    Convert Date    ${datafim}  result_format=%a, %b %d

            FOR    ${element}    IN    @{L1}

            Open Available Browser    https://www.google.com/travel/flights?sca_esv=561082501&output=search&q=google+viagens&source=lnms&sa=X&sqi=2&ved=2ahUKEwjDkOru4YKBAxW-ppUCHQQvBEYQ0pQJegQISRAB    maximized=true    

                #Inicio
                Press Keys  none    ${element} 

                Sleep	5s

                Press Keys  none    ARROW_DOWN    ARROW_DOWN

                Sleep	5s

                Press Keys  none    ENTER    TAB 

                Sleep	5s
                
                Press Keys  none    ${sdatainicio}    TAB

                Sleep	5s
            
                Press Keys  none    ${sdatafim}    TAB

                Sleep	5s

                Press Keys  none    ENTER

                Sleep	15s

                TRY
                    #Wait Until Page Does Not Contain Element    class:Rk10dc     timeout=30s    limit=10     error=Dados nao localizados

                    ${dados}=   Get Text  class:Rk10dc
                    
                    ${split}=    Split String     ${dados}      ${\n}

                    ${VAR}=  Set Variable  1

                    FOR    ${col}    IN    @{split}
                        IF    ${VAR} == 1
                            ${HORARIO}=  Set Variable   ${col}
                        ELSE IF    ${VAR} == 3
                            ${HORARIO}=     Catenate    SEPARATOR=-    ${HORARIO}    ${col}                
                        ELSE IF    ${VAR} == 4
                            ${CIA}=  Set Variable   ${col}
                        ELSE IF    ${VAR} == 5
                            ${TIME_VOO}=  Set Variable   ${col}           
                        ELSE IF    ${VAR} == 6
                            ${DIRECAO}=  Set Variable   ${col}
                        ELSE IF    ${VAR} == 7
                            ${PARADAS}=  Set Variable   ${col}
                        ELSE IF    ${VAR} == 8
                            ${TIME_CONEXAO}=  Set Variable   ${col} 
                        ELSE IF    ${VAR} == 9
                            ${EMISSAOCO2}=  Set Variable   ${col}
                        ELSE IF    ${VAR} == 10
                            ${ECONOMIAEMISSAOCO2}=  Set Variable   ${col}
                        ELSE IF    ${VAR} == 11
                            ${VALOR}=  Set Variable   ${col} 
                        ELSE IF    ${VAR} == 12
                            ${COTACAO}=  Set Variable   ${col} 
                            ${LINHA}=   Catenate    SEPARATOR=;    ${dataPesquisa}     ${element}    ${sdatainicio}    ${sdatafim}    ${HORARIO}    ${CIA}    ${TIME_VOO}    ${DIRECAO}    ${PARADAS}    ${TIME_CONEXAO}    ${EMISSAOCO2}    ${ECONOMIAEMISSAOCO2}    ${VALOR}    ${COTACAO}    ${\n}
                            Append To File    ${TEXT_FILE}    ${LINHA}
                            ${HORARIO}=  Set Variable       ${EMPTY}
                            ${CIA}=  Set Variable      ${EMPTY}
                            ${TIME_VOO}=  Set Variable      ${EMPTY}
                            ${DIRECAO}=  Set Variable      ${EMPTY}
                            ${PARADAS}=  Set Variable      ${EMPTY}
                            ${TIME_CONEXAO}=  Set Variable      ${EMPTY}
                            ${EMISSAOCO2}=  Set Variable      ${EMPTY}
                            ${ECONOMIAEMISSAOCO2}=  Set Variable      ${EMPTY}
                            ${VALOR}=  Set Variable      ${EMPTY}
                            ${COTACAO}=  Set Variable      ${EMPTY}
                            ${LINHA}=  Set Variable      ${EMPTY}
                            ${VAR}=  Set Variable  0                                                
                        END
                        ${VAR}=  Set Variable  ${${VAR}+1}
                     END
                EXCEPT
                      ${Exception} =    Catenate   SEPARATOR=|    ${element}    Dados nao localizados Step 1
                      ${LINHA}=   Catenate    SEPARATOR=;    ${dataPesquisa}     ${Exception}    ${sdatainicio}    ${sdatafim}    null    null    null   null    null    null    null    $null    null    null    ${\n}
                      Append To File    ${TEXT_FILE}    ${LINHA}
                END        
                Close All Browsers
            END
            Close All Browsers
        END
    EXCEPT
        ${Exception} =    Catenate   SEPARATOR=|    ${element}    Dados nao localizados Step 2
        ${LINHA}=   Catenate    SEPARATOR=;    ${dataPesquisa}     ${Exception}    ${sdatainicio}    ${sdatafim}    null    null    null   null    null    null    null    $null    null    null    ${\n}
        Append To File    ${TEXT_FILE}    ${LINHA}
    END
    

   


