module View exposing (loading, error, chapter)

import Html exposing (Html)
import Html.Attributes as Html
import Html.Events as Html


palette =
    { gray = "#333333"
    , red = "#B71C1C"
    , green = "#009688"
    }


loading : Html a
loading =
    header "loading..." "" palette.gray


error : Html a
error =
    header
        "I couldn't access your location"
        """
        Gray Area uses your location to track progress.
        Please let me access your location to continue.
        """
        palette.red


chapter :
    { name : String
    , chapterTitle : String
    , panelUrls : List String
    , decisions :
        List
            { place : String
            , description : String
            , action : Maybe a
            }
    }
    -> Html a
chapter { name, chapterTitle, panelUrls, decisions } =
    List.map panel panelUrls
        |> (::) (header name chapterTitle "#333333")
        |> flip (++) (footer decisions)
        |> List.intersperse (Html.br [] [])
        |> Html.div
            [ Html.style
                [ ( "text-align", "center" )
                , ( "line-height", "1" )
                , ( "margin", "1em 0" )
                ]
            ]


panel : String -> Html a
panel url =
    Html.img
        [ centerStrip
        , Html.src url
        ]
        []


header : String -> String -> String -> Html a
header name chapterTitle color =
    Html.div
        [ centerStrip
        , Html.style
            [ ( "text-align", "left" )
            , ( "background-color", color )
            ]
        , Html.id "header"
        ]
        [ Html.div
            [ Html.style
                [ ( "padding", "4em" )
                ]
            ]
            [ Html.h1 [ monospace ] [ Html.text name ]
            , Html.h2 [ monospace ] [ Html.text chapterTitle ]
            ]
        ]


footer :
    List { place : String, description : String, action : Maybe a }
    -> List (Html a)
footer =
    let
        wrap action =
            case action of
                Just msg ->
                    Html.a
                        [ monospace
                        , centerStrip
                        , Html.style
                            [ ( "background-color", "#009688" )
                            , ( "text-decoration", "underline" )
                            , ( "cursor", "pointer" )
                            , ( "padding", "1em 0" )
                            ]
                        , Html.onClick msg
                        ]

                Nothing ->
                    Html.div
                        [ monospace
                        , centerStrip
                        , Html.style
                            [ ( "background-color", "#B71C1C" )
                            , ( "padding", "1em 0" )
                            ]
                        ]
                        << flip (++)
                            [ Html.p
                                [ Html.style [ ( "font-style", "italic" ) ]
                                ]
                                [ Html.text "You are too far away!"
                                ]
                            ]

        option { place, description, action } =
            wrap action
                [ Html.h3 [] [ Html.text place ]
                , Html.h4 [] [ Html.text description ]
                ]
    in
        List.map option


centerStrip : Html.Attribute a
centerStrip =
    Html.style
        [ ( "margin", "0 auto" )
        , ( "display", "block" )
        , ( "width", "100%" )
        , ( "max-width", "720px" )
        ]


monospace : Html.Attribute a
monospace =
    Html.style
        [ ( "font-family", "monospace" )
        , ( "color", "#FFFFFF" )
        ]
