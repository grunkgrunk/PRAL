module Main exposing (..)

import Browser
import Css exposing (Pct, pct)
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
    Font.size (scaled 1)


mediumFontSize =
    Font.size (scaled 2)


largeFontSize =
    Font.size (scaled 3)



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
            [ header, front, quote, forening, footer ]



-- extremely ugly way to create a box - is there a better way?


blueLogo =
    img [ width <| px 350, zIndex 1000 ] "logo_blue.png"


box props =
    el props (text "")


boxBehind opts =
    behindContent <| box ([ width fill ] ++ opts)


front =
    el [ paddingEach { top = 55, bottom = 40, left = 0, right = 0 }, width fill, boxBehind [ Background.color orange, moveLeft 128, height <| px 550 ] ] <|
        column [ centerX, width fill ]
            [ row [ centerX ] [ column [ moveUp 45, spacing 16 ] [ blueLogo, img [ width <| px 400 ] "gertrud.png" ], el [ moveLeft 20 ] about ]
            ]


flamaFont =
    [ Font.family
        [ Font.external
            { name = "Roboto"
            , url = "https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&display=swap"
            }
        , Font.sansSerif
        ]
    , Font.bold
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


locationToLink loc =
    case loc of
        NextEvent ->
            "https://www.facebook.com/PRALkbh/events/?ref=page_internal"

        _ ->
            "#" ++ locationToStr loc



-- header : Element Msg


header : Element msg
header =
    row [ width fill, spacing xLarge, padding 16, Background.color white ]
        [ headerButton "FORSIDE" Front
        , headerButton "NÆSTE BEGIVENHED" NextEvent
        , headerButton "BAGOM" Behind

        -- , headerButton "EVENTS" Events
        , headerButton "KONTAKT" Contact
        , headerButton "STØT OS" SupportUs
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
                    , bottom = 2
                    , left = 0
                    , right = 0
                    }
               , Border.color white
               , Element.mouseOver [ Border.color blue ]

               -- underline text here
               ]
        )
        { url = locationToLink loc, label = text txt }


zIndex : Int -> Attribute msg
zIndex z =
    htmlAttribute <| style "z-index" (String.fromInt z)


setId : String -> Attribute msg
setId id =
    htmlAttribute <| Html.Attributes.id id


heading : Color -> Color -> String -> Element msg
heading fontColor =
    boldWithShadow [ Font.color fontColor, centerX, largeFontSize ] 2


shadow : Color -> Float -> Attr decorative msg
shadow color offset =
    Font.shadow { offset = ( offset, offset ), blur = 0, color = color }


boldWithShadow : List (Attribute msg) -> Float -> Color -> String -> Element msg
boldWithShadow props offset shadowColor txt =
    el
        (flamaFont ++ [ Font.bold, Font.italic, shadow shadowColor offset ] ++ props)
        (text txt)


regularText : List (Attribute msg) -> String -> Element msg
regularText opts txt =
    paragraph (flamaFont ++ [ normalFontSize, alignLeft ] ++ opts) [ text txt ]


wrapQuote : String -> String
wrapQuote t =
    "\"" ++ t ++ "\""


hand =
    img [ width <| px 500, centerX, moveDown 155 ] "hand.jpeg"


quote : Element msg
quote =
    column [ width fill, height <| px 450 ] <|
        [ el [ centerX ] <|
            column [ width <| px 650, spacing 16, behindContent hand ]
                [ "Jeg synes, det er fedt at få et indblik i andres passioner, og det synes jeg giver noget mod til mig selv."
                    |> wrapQuote
                    |> regularText [ Font.bold, Font.color blue, largeFontSize, Font.center ]
                , regularText [ Font.color blue, largeFontSize, Font.center, Font.bold ] "Katja, 28 år"
                ]
        ]


about : Element msg
about =
    el
        [ Background.color blue
        , width <| px 500
        , height <| px 540
        , padding 64
        ]
        (column [ width fill, spacing 32 ]
            [ heading white orange "HVAD PRALER DU AF?"
            , regularText [ Font.color white, Font.alignLeft ]
                "Måske ikke så meget, men du ved helt sikkert noget om aktier, warhammers, dragrace eller noget helt andet."
            , regularText [ Font.color white, Font.alignLeft ]
                "PRAL hylder unges vilde viden, til et gratis event hver måned. Her praler en ny ung løs om sin passion, som vi sammen skal nørde. Ingen er eksperter, men alle er nysgerrige!"
            , row [ spacing 16, centerX ] [ roundedButton "NÆSTE EVENT", roundedButton "STØT OS" ]
            ]
        )


bullet n =
    img [ alignTop, width <| px 50 ] <| "point" ++ String.fromInt n ++ ".png"


bulletPoint n txt =
    row [ spacing 16 ] [ bullet n, regularText [ Font.color white, alignTop ] txt ]


bulletPoints =
    column [ spacing 32, width fill, alignTop ]
        [ bulletPoint 1 "PRAL hylder nørderi og fordybelse."
        , bulletPoint 2 "Unge skal prale om deres vilde viden  - PRAL giver dem talerstolen."
        , bulletPoint 3 "Præmissen er blot, du har en passion, du vil dele med os andre."
        ]


forening =
    el [ width fill, padding 64, boxBehind [ Background.color orange, height (px 500) ] ] <|
        column [ width fill, centerX, spacing 64 ]
            [ boldWithShadow [ Font.size 32, Font.color white ] 2 blue "EN FORENING AF UNGE"
            , row [ width fill, spacing 16, centerX ]
                [ bulletPoints
                , img [ width <| px 380 ] "christian.png"
                ]
            ]


unwrappedText txt =
    el (flamaFont ++ [ Font.color white, normalFontSize ]) (text txt)


roundedButton : String -> Element msg
roundedButton =
    boldWithShadow [ Background.color orange, Border.rounded 50, padding 8, mediumFontSize, Font.color white ] 2 blue


footerEl txt other =
    column [ alignTop, spacing 8, width fill ]
        [ boldWithShadow [ Font.color white, Font.size 16 ] 2 orange txt, other ]


footerAbout =
    footerEl "OM OS" <| column [ width fill, spacing 8 ] [ unwrappedText "PRAL", unwrappedText "CVR: 41719028" ]


footerContact =
    footerEl "KONTAKT OS" <|
        column [ spacing 8 ]
            [ unwrappedText "pral@hotmail.com"
            , unwrappedText "xx xx xx xx"
            ]


footerFollow =
    footerEl "FØLG OS" <|
        row [ spacing 8 ]
            [ el [ Background.color orange ] none
            , el [ Background.color orange ] none
            , el [ Background.color orange ] none
            ]


footer =
    el [ width fill, Background.color blue, padding 64 ] <|
        row [ centerX, spacing 128 ] [ footerAbout, footerContact, footerFollow ]
