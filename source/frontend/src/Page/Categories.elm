module Page.Categories exposing (Model, Msg, init, subscriptions, toSession, update, view)

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
        , categories: List Category
    }

type alias Category = 
    {
        name: String
        , id: Int
    }

init : Session -> ( Model, Cmd Msg )
init session =
    (
    { 
        session = session 
        , categories = [
            {name = "Animals", id = 1}
            , {name = "Sport", id = 2}
            , {name = "Lifestyle", id = 3}
        ]
    }
    , Cmd.none
    )

-- VIEW

view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Categories"
    , content =
        div [ class "categories-page" ]
            [ div [ class "container page" ]
                [ div [ class "row" ]
                    [ viewCategories model.categories]
                ]
            ]
    }

viewCategories: List Category -> Html Msg
viewCategories categories = 
    div [ class "categories-list"] (List.map viewCategory categories)

viewCategory: Category -> Html Msg
viewCategory category = 
    a [Route.href Route.Home, class "link-card"] [
        text category.name
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