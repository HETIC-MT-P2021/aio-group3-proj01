module Page.Home exposing (Model, Msg, init, subscriptions, toSession, update, view)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Browser.Dom as Dom
import Html exposing (..)
import Html.Attributes exposing (class)

import Session exposing (Session)
import Task exposing (Task)

-- MODEL

type alias Model =
    { session : Session
    }

init : Session -> ( Model, Cmd Msg )
init session =
    (
    { session = session }
    , Cmd.none
    )

-- VIEW

view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Home"
    , content =
        div [ class "home-page" ]
            [ div [ class "container page" ]
                [ div [ class "row" ]
                    [ text "Home pageeee"]
                ]
            ]
    }

-- UPDATE


type Msg = GotSession Session

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )


-- HTTP

scrollToTop : Task x ()
scrollToTop =
    Dom.setViewport 0 0
        -- It's not worth showing the user anything special if scrolling fails.
        -- If anything, we'd log this to an error recording service.
        |> Task.onError (\_ -> Task.succeed ())


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- EXPORT

toSession : Model -> Session
toSession model =
    model.session