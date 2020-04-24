module Page.Categories exposing (Model, Msg, init, subscriptions, toSession, update, view)

{-| The image page. You can get here via either the / or /#/ routes.
-}

import Browser.Dom as Dom
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Http exposing (Error(..))
import Json.Decode as Decode exposing (Decoder, int, string)

import Session exposing (Session)
import Task exposing (Task)
import Route exposing (Route)

-- MODEL

type alias Model =
    { 
        session : Session
        , categories: List Category
        , error: Maybe String
    }

type alias Category = 
    {
        id: Int
        , name: String
    }

init : Session -> ( Model, Cmd Msg )
init session =
    (
    { 
        session = session
        , error = Nothing
        , categories = [
        ]
    }
    , getCategories
    )

-- VIEW

view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Categories"
    , content =
        div [ class "categories-page" ]
            [ div [ class "container page" ]
                [ div [ class "row" ]
                    [ 
                        a [class "btn btn-primary", Route.href Route.NewCategory] [text "New category"]
                        , viewCategories model.categories
                    ]
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


type Msg = 
    GotSession Session
    | GotCategories (Result Http.Error (List Category))

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )
        
        GotCategories (Ok categories) ->
            ( { model
                | categories = categories
                , error = Nothing
              }
            , Cmd.none
            )

        GotCategories (Err err) ->
            let
                _ =
                    Debug.log "An error occured" err
            in
            ( { model
                | error = Just <| errorToString err
                , categories = []
              }
            , Cmd.none
            )


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

-- HTTP & DECODE

getCategories : Cmd Msg
getCategories =
    Http.get
        { url = "http://localhost:4000/api/categories"
        , expect = Http.expectJson GotCategories (Decode.field "data" (Decode.list decodeCategory))
        }

decodeCategory : Decoder Category
decodeCategory =
   Decode.map2 Category
     (Decode.field "id" Decode.int)
     (Decode.field "name" Decode.string)


errorToString : Http.Error -> String
errorToString error =
    case error of
        BadUrl url ->
            "Bad url: " ++ url

        Timeout ->
            "Request timed out."

        NetworkError ->
            "Network error. Are you online?"

        BadStatus status_code ->
            "HTTP error " ++ String.fromInt status_code

        BadBody body ->
            "Unable to parse response body: " ++ body
