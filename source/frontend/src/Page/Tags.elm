module Page.Tags exposing (Model, Msg, init, subscriptions, toSession, update, view)

{-| The image page. You can get here via either the / or /#/ routes.
-}

import Browser.Dom as Dom
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)

import Http exposing (Error(..))
import Json.Decode as Decode exposing (Decoder, int, string)

import Session exposing (Session)
import Task exposing (Task)
import Route exposing (Route)

-- MODEL

type alias Model =
    { 
        session : Session
        , tags: List Tag
        , error: Maybe String
    }

type alias Tag = 
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
        , tags = []
    }
    , getTags
    )

-- VIEW

view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Tags"
    , content =
        div [ class "tags-page" ]
            [ div [ class "container page" ]
                [ div [ class "row" ]
                    [ viewTags model.tags ]
                ]
            ]
    }

viewTags: List Tag -> Html Msg
viewTags tags = 
    div [ class "tags-list"] (List.map viewTag tags)

viewTag: Tag -> Html Msg
viewTag tag = 
    div [class "link-card"] [
        a [Route.href (Route.Home)] [text tag.name]
        , 
        i [class "fas fa-times", onClick (DeleteTagMsg tag.id)][]
    ]

-- UPDATE


type Msg = 
    GotSession Session
    | GotTags (Result Http.Error (List Tag))
    | DeleteTagMsg Int
    | DeletedMsg (Result Http.Error ())

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )
        
        GotTags (Ok tags) ->
            ( { model
                | tags = tags
                , error = Nothing
              }
            , Cmd.none
            )

        GotTags (Err err) ->
            let
                _ =
                    Debug.log "An error occured" err
            in
            ( { model
                | error = Just <| errorToString err
                , tags = []
              }
            , Cmd.none
            )
        
        DeleteTagMsg id ->
            (model, deleteTag id)
        
        DeletedMsg (Err err)->
            (model, Cmd.none)

        DeletedMsg (Ok delete)->
            (model, Nav.reload)


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

getTags : Cmd Msg
getTags =
    Http.get
        { url = "http://localhost:4000/api/tags"
        , expect = Http.expectJson GotTags (Decode.field "data" (Decode.list decodeTag))
        }

deleteTag: Int -> Cmd Msg
deleteTag id = 
    Http.request
        { method = "DELETE"
        , headers = []
        , url = "http://localhost:4000/api/tags/" ++ (String.fromInt id)
        , body = Http.emptyBody
        , expect = Http.expectWhatever DeletedMsg
        , timeout = Nothing
        , tracker = Nothing
        }

decodeTag : Decoder Tag
decodeTag =
   Decode.map2 Tag
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
