module HomePage exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)


view model =
    div [ class "jumbotron" ]
        [ h1 [] [ text "Welcome to JOOJLAND!" ]
        , p []
            [ text "Pop Your Life Inc. (stock symbol "
            , strong [] [ text "PYL" ]
            , text <|
                """"
                ) is a micro financial company to help community
                reach funds by launching crowdfunding projects ! BIJOOJ!
                """
            ]
        ]


main =
    view "dummy model"