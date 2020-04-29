module Page.EditTag exposing (Model, Msg, init, subscriptions, toSession, update, view)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Browser.Dom as Dom
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (class, value, src, type_, for, style, id, placeholder)
import Html.Events exposing (onInput, onClick)

import Session exposing (Session)
import Task exposing (Task)
import Route exposing (Route)

import Browser exposing (sandbox)
import Http exposing (Error(..))
import Json.Decode as Decode exposing (Decoder, int, string, field)
import Json.Encode as Encode
-- MODEL

type alias Model =
    { 
        session : Session
        , tag: Tag
        , error : Maybe String
        , id: Int
        , name: String
        , modified: String
    }

type alias Tag =
    { id : Int
    , name : String
    }


decodeTag : Decoder Tag
decodeTag =
   Decode.map2 Tag
     (Decode.field "id" Decode.int)
     (Decode.field "name" Decode.string)

type Msg = 
    GotTag (Result Http.Error (Tag))
    | EditTagMsg Int
    | Name String
    | EditedMsg (Result Http.Error ())

init : Session -> Int -> ( Model, Cmd Msg )
init session id =
    (
    { 
        session = session
        , tag = {id = id, name = ""}
        , error = Nothing
        , id = id
        , modified = ""
        , name = ""
    }
    , getTag id
    )
getTag : Int -> Cmd Msg
getTag id =
    Http.get
        { url = "http://localhost:4000/api/tags/" ++ (String.fromInt id)
        , expect = Http.expectJson GotTag (Decode.field "data" (decodeTag))
        }


-- VIEW

view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Edit tag"
    , content =      
            div [class "container page"] [  
                case model.error of
                    Nothing ->
                        case model.tag of
                            tag ->
                                viewForm model tag

                    Just error ->
                        div [ ]
                            [ h1 [] [ text error ] ]
            ]
    }


viewForm : Model -> Tag -> Html Msg
viewForm model tag=
  form []
    [ 
        div [class "form-group"][label [for "name-field"] [text "Name"], viewInput "form-control" "name-field" "text" "Name" tag.name Name]
        , button [type_ "submit", class "btn btn-primary", onClick (EditTagMsg tag.id) ][text "Change name"]
        , viewValidation model
    ]


viewValidation : Model -> Html msg
viewValidation model =
  if String.length model.modified > 1 then
    div [ style "color" "green" ] [ text "Tag name changed!" ]
  else 
    div [] []

viewInput: String -> String -> String -> String -> String -> (String -> msg) -> Html msg
viewInput c i t p v toMsg =
  input [ class c, id i, type_ t, placeholder p, value v, onInput toMsg ] []


-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotTag (Ok tag) ->
            ( { model
                | tag = tag
                , error = Nothing
              }
            , Cmd.none
            )

        GotTag (Err err) ->
            let
                _ =
                    Debug.log "An error occured" err
            in
            ( { model
                | error = Just <| errorToString err
                , tag = {id = model.id, name = ""}
              }
            , Cmd.none
            )
        
        Name newName ->
            ({
                model | tag = {id = model.tag.id, name = newName}
            }, Cmd.none)

        EditTagMsg id ->
            (model, editTag model)

        EditedMsg (Ok tag) ->
            ({model | modified = "Tag modified"}, Cmd.none)

        EditedMsg (Err err) ->
            (model, Cmd.none)



-- HTTP

editTag: Model -> Cmd Msg
editTag model = 
    let
        body =
            Http.jsonBody <|
                    Encode.object
                        [ ( "tag", Encode.object
                            [ ( "name", Encode.string model.tag.name), ( "id", Encode.string (String.fromInt model.tag.id) ) ] ) ]
    in
        Http.request
            { method = "PUT"
            , headers = []
            , url = "http://localhost:4000/api/tags/" ++ (String.fromInt model.tag.id)
            , body = body
            , expect = Http.expectWhatever EditedMsg
            , timeout = Nothing
            , tracker = Nothing
            }

scrollToTop : Task x ()
scrollToTop =
    Dom.setViewport 0 0
        -- It's not worth showing the user anything special if scrolling fails.
        -- If anything, we'd log this to an error recording service.
        |> Task.onError (\_ -> Task.succeed ())

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



-- HTTP 

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- EXPORT

toSession : Model -> Session
toSession model =
    model.session

