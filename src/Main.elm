module Main exposing (..)

import Browser
import Css exposing (Pct, paddingTop, pct)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (center, underline)
import Element.Input as Input
import Html.Attributes exposing (align, style)


type Location
    = Front
    | Behind
    | Events
    | Contact
    | SupportUs
    | NextEvent



-- paddings


xxSmall =
    2


xSmall =
    4


small =
    8


large =
    16


xLarge =
    32


xxLarge =
    64



-- Font sizes


scaled =
    Element.modular 16 1.5 >> round


normalFontSize =
    Font.size 20


mediumFontSize =
    Font.size 40


largeFontSize =
    Font.size 64



-- colors


orange =
    rgb255 247 92 3


blue =
    rgb255 13 33 161


white =
    rgb255 255 255 255



-- for builds there should not be the /, but running with elm reactor we have to have this.


img : List (Attribute msg) -> String -> Element msg
img opts fl =
    image opts { src = "assets/" ++ fl, description = "" }


main =
    Browser.sandbox { view = view, update = update, init = {} }


update msg model =
    model


locationId =
    setId << locationToStr


view model =
    layout [ inFront header, width fill, height fill ] <|
        column [ locationId Front, width fill ]
            -- set the location id to front here rather than in the "front" function to ensure that we jump all the way to the top of the page
            [ header, front, quote, forening, events, supportUs, contact, footer ]


blueLogo =
    img [ width <| px 350, paddingEach { top = 25, bottom = 25, left = 0, right = 0 } ] "logo_blue.png"



-- extremely ugly way to create a box - is there a better way?


box props =
    el props (text "")


boxBehind opts =
    behindContent <| box ([ width fill ] ++ opts)


front =
    el
        [ paddingEach { top = 50, bottom = 40, left = 0, right = 0 }
        , width fill
        , centerX
        , boxBehind [ Background.color orange, moveLeft 128, height <| px 550 ]
        ]
    <|
        row [ width fill, centerX ]
            [ column [ moveUp 45, spacing 16, centerX ] [ blueLogo, img [ width <| px 400 ] "gertrud.png" ]
            , about
            ]


supportUs =
    el [ locationId SupportUs, width fill, height <| px 700, padding 64, boxBehind [ Background.color blue, height (px 550), moveLeft 100 ] ] <|
        column [ width fill, centerX ]
            [ heading white orange "STØT OS"
            , row [ width fill, spacing 64 ]
                [ multilineText
                    [ spacing 16, width <| px 400, Font.color white ]
                    [ "Vil du være medlem af PRALs forening?"
                    , "Som medlem er du med til at støtte PRALs arbejde, så vi kan holde nogle anderledes, nørdede og fede events og blive ved med at være en forening, som bakker op om unges viden og giver dem rummet til at prale."
                    , "Et støttemedlemskab koster 100 kr/året."
                    , "Udfyld formularen nedenfor, så modtager du en mail fra os om, hvordan du indbetaler."
                    ]
                , img [ width <| px 500 ] "livfreja.jpg"
                ]
            ]


events =
    el [ locationId Events, width fill, height <| px 700, padding 64, boxBehind [ Background.color blue, height (px 550), moveLeft 100 ] ] <|
        column [ width fill, centerX, spacing 64 ]
            [ heading white orange "EVENTS"
            , row [ width fill, spacing 64 ]
                [ paragraph [ Font.color white, alignTop ] [ text "Klik ", pageLink "her" (locationToLink NextEvent) ]
                , img [ width <| px 600 ] "greta.jpg"
                ]
            ]


contact =
    el [ locationId Contact, width fill, height <| px 700, padding 64, boxBehind [ Background.color orange, height (px 550) ] ] <|
        column [ width fill, centerX ]
            [ heading white blue "KONTAKT OS"
            , row [ width fill, spacing 64 ]
                [ img [] "fish.png"
                , multilineText
                    [ spacing 16, width <| px 400, Font.color white ]
                    []

                --, img [ width <| px 500 ] "livfreja.jpg"
                ]
            ]


flamaFont =
    [ Font.family
        [ Font.external
            { name = "Roboto"
            , url = "https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&display=swap"
            }
        , Font.sansSerif
        ]
    ]


locationToStr loc =
    case loc of
        Front ->
            "front"

        Behind ->
            "behind"

        Events ->
            "events"

        Contact ->
            "contact"

        SupportUs ->
            "supportus"

        NextEvent ->
            "nextevent"


locationToLink : Location -> String
locationToLink loc =
    case loc of
        NextEvent ->
            "https://www.facebook.com/PRALkbh/events/?ref=page_internal"

        _ ->
            "#" ++ locationToStr loc


header : Element msg
header =
    row
        [ width fill
        , spacing xLarge
        , paddingEach { right = 128, left = 0, top = 16, bottom = 16 }
        , Background.color white

        --, moveLeft (128 - 16) -- move left to align with orange box in the background
        ]
        [ headerButton "FORSIDE" Front
        , headerButton "BAGOM" Behind
        , headerButton "EVENTS" Events
        , headerButton "STØT OS" SupportUs
        , headerButton "KONTAKT" Contact
        ]



--headerButton : String -> Location ->


headerButton : String -> Location -> Element msg
headerButton txt loc =
    link
        (flamaFont
            ++ [ Font.color blue
               , Font.italic
               , Font.bold
               , alignRight
               , normalFontSize
               , Border.widthEach
                    { top = 0
                    , bottom = 2 -- for the blue underline
                    , left = 0
                    , right = 0
                    }
               , Border.color white
               , Element.mouseOver [ Border.color blue ]
               ]
        )
        { url = locationToLink loc, label = text txt }


pageLink : String -> String -> Element msg
pageLink txt page =
    link
        (flamaFont
            ++ [ Font.italic
               , Font.bold
               , normalFontSize
               , Border.widthEach
                    { top = 0
                    , bottom = 2 -- for the blue underline
                    , left = 0
                    , right = 0
                    }
               , Border.color white

               --, Element.mouseOver [ Border.color blue ]
               ]
        )
        { url = page, label = text txt }


zIndex : Int -> Attribute msg
zIndex z =
    htmlAttribute <| style "z-index" (String.fromInt z)


setId : String -> Attribute msg
setId id =
    htmlAttribute <| Html.Attributes.id id


heading : Color -> Color -> String -> Element msg
heading fontColor =
    boldWithShadow [ Font.color fontColor, alignLeft, largeFontSize ] 4


shadow : Color -> Float -> Attr decorative msg
shadow color offset =
    Font.shadow { offset = ( offset, offset ), blur = 0, color = color }


boldWithShadow : List (Attribute msg) -> Float -> Color -> String -> Element msg
boldWithShadow props offset shadowColor txt =
    unwrappedText ([ Font.bold, Font.italic, shadow shadowColor offset ] ++ props) txt


wrapQuote : String -> String
wrapQuote t =
    "\"" ++ t ++ "\""


hand =
    img [ width <| px 500, centerX, moveDown 155 ] "hand.jpeg"


quote : Element msg
quote =
    column [ width fill, height <| px 450 ] <|
        [ el [ centerX ] <|
            multilineText
                [ width <| px 650
                , spacing 32
                , Font.bold
                , Font.italic
                , Font.color blue
                , mediumFontSize
                , Font.center
                , behindContent hand
                ]
                [ wrapQuote <| "jeg synes, det er fedt at få et indblik i andres passioner, og det synes jeg giver noget mod til mig selv"
                , "Katja, 28 år"
                ]
        ]


inlineText opts str =
    paragraph (flamaFont ++ [ alignLeft ] ++ opts) [ text str ]


multilineText opts strs =
    column opts <|
        List.map
            (inlineText [ spacing 8 ])
            strs


about : Element msg
about =
    el
        [ Background.color blue
        , width <| px 500
        , centerX
        , moveLeft 20
        , padding 50
        ]
        (column [ width fill, spacing 32 ]
            [ heading white orange "HVAD PRALER\nDU AF?"
            , multilineText [ Font.color white, Font.alignLeft, spacing 32 ]
                [ "Måske ikke så meget, men du ved helt sikkert noget om aktier, warhammers, dragrace eller noget helt andet."
                , "PRAL hylder unges vilde viden, til et gratis event hver måned. Her praler en ny ung løs om sin passion, som vi sammen skal nørde."
                , "Ingen er eksperter, men alle er nysgerrige!"
                ]
            ]
        )


bullet n =
    img [ alignTop, width <| px 50 ] <| "point" ++ String.fromInt n ++ ".png"


bulletPoint n txt =
    row [ spacing 16 ] [ bullet n, inlineText [ Font.color white, alignTop ] txt ]


bulletPoints =
    column [ spacing 32, width fill, alignTop ]
        [ bulletPoint 1 "PRAL hylder nørderi og fordybelse."
        , bulletPoint 2 "Unge skal prale om deres vilde viden - PRAL giver dem talerstolen."
        , bulletPoint 3 "Præmissen er blot, du har en passion, du vil dele med os andre."
        ]


forening =
    el [ locationId Behind, width fill, padding 64, boxBehind [ Background.color orange, height (px 500) ] ] <|
        column [ width fill, centerX, spacing 64 ]
            [ heading white blue "EN FORENING AF UNGE"
            , row [ width fill, spacing 64, centerX ]
                [ bulletPoints
                , img [ width <| px 400 ] "christian.png"
                ]
            ]


unwrappedText props txt =
    el (flamaFont ++ props) (text txt)


footerEl txt other =
    column [ alignTop, spacing 8, width fill ]
        [ boldWithShadow [ Font.color white, Font.size 16 ] 2 orange txt, other ]


footerAbout =
    footerEl "OM OS" <| multilineText [ width fill, Font.color white, spacing 8 ] [ "PRAL", "CVR: 41719028" ]


footerContact =
    footerEl "KONTAKT OS" <|
        multilineText [ Font.color white, spacing 8 ]
            [ "pral@hotmail.com"
            , "xx xx xx xx"
            ]


footerFollow =
    footerEl "FØLG OS" <|
        row [ spacing 10 ]
            [ link [] { url = "https://www.facebook.com/PRALkbh", label = img [ width <| px 40 ] "facebookicon.png" }
            , link [] { url = "https://www.instagram.com/pral_kbh/", label = img [ width <| px 40 ] "instaicon.png" }
            ]


footer =
    el [ width fill, Background.color blue, padding 64 ] <|
        row [ centerX, spacing 128 ] [ footerAbout, footerContact, footerFollow ]
