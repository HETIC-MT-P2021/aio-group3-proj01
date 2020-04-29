module Page.EditCategory exposing (Model, Msg, init, subscriptions, toSession, update, view)

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
        , category: Category
        , error : Maybe String
        , id: Int
        , name: String
        , modified: String
    }

type alias Category =
    { id : Int
    , name : String
    }


decodeCategory : Decoder Category
decodeCategory =
   Decode.map2 Category
     (Decode.field "id" Decode.int)
     (Decode.field "name" Decode.string)

type Msg = 
    GotCategory (Result Http.Error (Category))
    | EditCategoryMsg Int
    | Name String
    | EditedMsg (Result Http.Error ())

init : Session -> Int -> ( Model, Cmd Msg )
init session id =
    (
    { 
        session = session
        , category = {id = id, name = ""}
        , error = Nothing
        , id = id
        , modified = ""
        , name = ""
    }
    , getCategory id
    )
getCategory : Int -> Cmd Msg
getCategory id =
    Http.get
        { url = "http://localhost:4000/api/categories/" ++ (String.fromInt id)
        , expect = Http.expectJson GotCategory (Decode.field "data" (decodeCategory))
        }


-- VIEW

view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Edit category"
    , content =      
            div [class "container page"] [  
                case model.error of
                    Nothing ->
                        case model.category of
                            category ->
                                viewForm model category

                    Just error ->
                        div [ ]
                            [ h1 [] [ text error ] ]
            ]
    }


viewForm : Model -> Category -> Html Msg
viewForm model category=
  form []
    [ 
        div [class "form-group"][label [for "name-field"] [text "Name"], viewInput "form-control" "name-field" "text" "Name" category.name Name]
        , button [type_ "submit", class "btn btn-primary", onClick (EditCategoryMsg category.id) ][text "Change name"]
        , viewValidation model
    ]


viewValidation : Model -> Html msg
viewValidation model =
  if String.length model.modified > 1 then
    div [ style "color" "green" ] [ text "Category name changed!" ]
  else 
    div [] []

viewInput: String -> String -> String -> String -> String -> (String -> msg) -> Html msg
viewInput c i t p v toMsg =
  input [ class c, id i, type_ t, placeholder p, value v, onInput toMsg ] []


-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotCategory (Ok category) ->
            ( { model
                | category = category
                , error = Nothing
              }
            , Cmd.none
            )

        GotCategory (Err err) ->
            let
                _ =
                    Debug.log "An error occured" err
            in
            ( { model
                | error = Just <| errorToString err
                , category = {id = model.id, name = ""}
              }
            , Cmd.none
            )
        
        Name newName ->
            ({
                model | category = {id = model.category.id, name = newName}
            }, Cmd.none)

        EditCategoryMsg id ->
            (model, editCategory model)

        EditedMsg (Ok category) ->
            ({model | modified = "Category modified"}, Cmd.none)

        EditedMsg (Err err) ->
            (model, Cmd.none)



-- HTTP

editCategory: Model -> Cmd Msg
editCategory model = 
    let
        body =
            Http.jsonBody <|
                    Encode.object
                        [ ( "category", Encode.object
                            [ ( "name", Encode.string model.category.name), ( "id", Encode.string (String.fromInt model.category.id) ) ] ) ]
    in
        Http.request
            { method = "PUT"
            , headers = []
            , url = "http://localhost:4000/api/categories/" ++ (String.fromInt model.category.id)
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

