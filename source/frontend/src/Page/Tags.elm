module Page.Tags exposing (Model, Msg, init, subscriptions, toSession, update, view)

{-| The image page. You can get here via either the / or /#/ routes.
-}

import Browser.Dom as Dom
import Html exposing (..)
import Html.Attributes exposing (class, href)

import Session exposing (Session)
import Task exposing (Task)
import Route exposing (Route)

-- MODEL

type alias Model =
    { 
        session : Session
        , tags: List Tag
    }

type alias Tag = 
    {
        name: String
        , id: Int
    }

init : Session -> ( Model, Cmd Msg )
init session =
    (
    { 
        session = session 
        , tags = [
            {name = "cat", id = 1}
            , {name = "football", id = 2}
            , {name = "sun", id = 3}
        ]
    }
    , Cmd.none
    )

-- VIEW

view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Tags"
    , content =
        div [ class "tags-page" ]
            [ div [ class "container page" ]
                [ div [ class "row" ]
                    [ viewTags model.tags]
                ]
            ]
    }

viewTags: List Tag -> Html Msg
viewTags tags = 
    div [ class "tags-list"] (List.map viewTag tags)

viewTag: Tag -> Html Msg
viewTag tag = 
    a [Route.href Route.Home, class "link-card"] [
        text tag.name
    ]

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